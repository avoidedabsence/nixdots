#!/usr/bin/env python3

import argparse
import json
import logging
import os
import signal
import subprocess
import sys
import time
from threading import Event, Thread
from typing import Optional, Dict, List

logger = logging.getLogger(__name__)


class PlayerctlManager:
    def __init__(self, selected_player: Optional[str] = None, excluded_players: List[str] = None):
        self.selected_player = selected_player
        self.excluded_players = excluded_players or []
        self.stop_event = Event()
        self.current_output = ""
        
        # Set up signal handlers
        signal.signal(signal.SIGINT, self._signal_handler)
        signal.signal(signal.SIGTERM, self._signal_handler)
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)

    def _signal_handler(self, _sig, _frame):
        """Handle termination signals"""
        logger.info("Received signal to stop, exiting")
        self.stop_event.set()
        sys.stdout.write("\n")
        sys.stdout.flush()
        sys.exit(0)

    def _run_playerctl(self, args: List[str], player: Optional[str] = None) -> Optional[str]:
        """Run playerctl command and return output"""
        cmd = ["playerctl"]
        if player:
            cmd.extend(["--player", player])
        cmd.extend(args)
        
        try:
            result = subprocess.run(
                cmd, 
                capture_output=True, 
                text=True, 
                timeout=5
            )
            if result.returncode == 0:
                return result.stdout.strip()
            return None
        except (subprocess.TimeoutExpired, subprocess.CalledProcessError, FileNotFoundError):
            return None

    def _get_available_players(self) -> List[str]:
        """Get list of available media players"""
        output = self._run_playerctl(["--list-all"])
        if not output:
            return []
        
        players = []
        for line in output.split('\n'):
            if line.strip():
                player_name = line.strip()
                # Filter out excluded players
                if player_name not in self.excluded_players:
                    # If specific player selected, only include that one
                    if not self.selected_player or player_name == self.selected_player:
                        players.append(player_name)
        
        return players

    def _get_player_status(self, player: str) -> Optional[str]:
        """Get playback status for a player"""
        return self._run_playerctl(["status"], player)

    def _get_player_metadata(self, player: str) -> Dict[str, str]:
        """Get metadata for a player"""
        metadata = {}
        
        # Get artist
        artist = self._run_playerctl(["metadata", "artist"], player)
        if artist:
            metadata["artist"] = artist
            
        # Get title
        title = self._run_playerctl(["metadata", "title"], player)
        if title:
            metadata["title"] = title
            
        # Get track ID for Spotify ad detection
        track_id = self._run_playerctl(["metadata", "mpris:trackid"], player)
        if track_id:
            metadata["trackid"] = track_id
            
        return metadata

    def _get_playing_player(self) -> Optional[str]:
        """Get the first playing player, or first available if none playing"""
        players = self._get_available_players()
        if not players:
            return None
            
        playing_players = []
        paused_players = []
        
        for player in players:
            status = self._get_player_status(player)
            if status == "Playing":
                playing_players.append(player)
            elif status == "Paused":
                paused_players.append(player)
                
        # Prefer playing players, then paused, prioritizing the selected player
        all_candidates = playing_players + paused_players
        
        if self.selected_player and self.selected_player in all_candidates:
            return self.selected_player
            
        return all_candidates[0] if all_candidates else None

    def _format_track_info(self, player: str, metadata: Dict[str, str], status: str) -> str:
        """Format track information for display"""
        # Check for Spotify advertisements
        if (player == "spotify" and 
            "trackid" in metadata and 
            ":ad:" in metadata["trackid"]):
            return "Advertisement"
            
        # Format artist - title
        artist = metadata.get("artist", "")
        title = metadata.get("title", "")
        
        if artist and title:
            track_info = f"{artist} - {title}"
        elif title:
            track_info = title
        else:
            return ""
            
        # Escape HTML entities
        track_info = track_info.replace("&", "&amp;")
        
        # Add status icon
        if status == "Playing":
            return f" {track_info}"
        else:
            return f" {track_info}"

    def _write_output(self, text: str, player: str):
        """Write JSON output for Waybar"""
        if text == self.current_output:
            return  # Don't spam identical output
            
        self.current_output = text
        logger.debug(f"Writing output: {text}")
        
        output = {
            "text": text,
            "class": f"custom-{player}",
            "alt": player,
        }
        
        sys.stdout.write(json.dumps(output) + "\n")
        sys.stdout.flush()

    def _clear_output(self):
        """Clear output"""
        if self.current_output:
            self.current_output = ""
            sys.stdout.write("\n")
            sys.stdout.flush()

    def _monitor_players(self):
        """Monitor players for changes"""
        last_state = {}
        
        while not self.stop_event.is_set():
            try:
                current_player = self._get_playing_player()
                
                if not current_player:
                    if last_state:  # Only clear if we had output before
                        self._clear_output()
                        last_state = {}
                    self.stop_event.wait(1)
                    continue
                
                status = self._get_player_status(current_player)
                metadata = self._get_player_metadata(current_player)
                
                # Create state key for comparison
                state_key = (current_player, status, 
                           metadata.get("artist", ""), 
                           metadata.get("title", ""),
                           metadata.get("trackid", ""))
                
                if state_key != last_state.get("key"):
                    track_info = self._format_track_info(current_player, metadata, status)
                    if track_info:
                        self._write_output(track_info, current_player)
                    else:
                        self._clear_output()
                    
                    last_state = {"key": state_key}
                
                self.stop_event.wait(0.5)  # Check every 500ms
                
            except Exception as e:
                logger.error(f"Error in monitor loop: {e}")
                self.stop_event.wait(1)

    def run(self):
        """Start monitoring"""
        logger.info("Starting player monitoring")
        try:
            self._monitor_players()
        except KeyboardInterrupt:
            logger.info("Interrupted by user")
        finally:
            self._clear_output()


def parse_arguments():
    parser = argparse.ArgumentParser(description="Waybar media player widget using playerctl")
    
    parser.add_argument("-v", "--verbose", action="count", default=0,
                       help="Increase verbosity with every occurrence of -v")
    
    parser.add_argument("-x", "--exclude", 
                       help="Comma-separated list of excluded players")
    
    parser.add_argument("--player", 
                       help="Specific player to monitor (e.g., 'spotify')")
    
    parser.add_argument("--enable-logging", action="store_true",
                       help="Enable logging to file")
    
    return parser.parse_args()


def main():
    arguments = parse_arguments()
    
    # Initialize logging
    if arguments.enable_logging:
        logfile = os.path.join(
            os.path.dirname(os.path.realpath(__file__)), "media-player-nix.log"
        )
        logging.basicConfig(
            filename=logfile,
            level=logging.DEBUG,
            format="%(asctime)s %(name)s %(levelname)s:%(lineno)d %(message)s",
        )
    
    # Set logging level based on verbosity
    logger.setLevel(max((3 - arguments.verbose) * 10, 0))
    
    logger.info("Creating playerctl manager")
    if arguments.player:
        logger.info(f"Filtering for player: {arguments.player}")
    if arguments.exclude:
        logger.info(f"Excluding players: {arguments.exclude}")
    
    # Parse excluded players
    excluded_players = []
    if arguments.exclude:
        excluded_players = [p.strip() for p in arguments.exclude.split(",")]
    
    # Create and run manager
    manager = PlayerctlManager(
        selected_player=arguments.player,
        excluded_players=excluded_players
    )
    
    manager.run()


if __name__ == "__main__":
    main()
