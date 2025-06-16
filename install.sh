#!/usr/bin/env bash

set -e

echo "🚀 Desktop Environment Flake Setup Script"
echo "=========================================="

# Check if we're on NixOS
if ! command -v nixos-version &> /dev/null; then
    echo "❌ This script requires NixOS"
    exit 1
fi

# Check if flakes are enabled
if ! nix flake --help &> /dev/null; then
    echo "❌ Nix flakes are not enabled. Please enable experimental features:"
    echo "   nix.settings.experimental-features = [ \"nix-command\" \"flakes\" ];"
    exit 1
fi

# Get current directory
FLAKE_DIR=$(pwd)

echo "📁 Using flake directory: $FLAKE_DIR"

# Check for required files
echo "🔍 Checking required files..."

if [ ! -f "$FLAKE_DIR/flake.nix" ]; then
    echo "❌ flake.nix not found in current directory"
    exit 1
fi

if [ ! -f "$FLAKE_DIR/home.nix" ]; then
    echo "❌ home.nix not found in current directory"
    exit 1
fi

# Setup wallpaper
echo "🖼️  Setting up wallpaper..."
mkdir -p "$FLAKE_DIR/hypr"

if [ ! -f "$FLAKE_DIR/hypr/wp.jpg" ]; then
    echo "⚠️  No wallpaper found at hypr/wp.jpg"
    echo "   Please copy your wallpaper to: $FLAKE_DIR/hypr/wp.jpg"
    echo "   Or use a placeholder?"
    read -p "Use placeholder wallpaper? (y/N): " use_placeholder
    
    if [[ $use_placeholder =~ ^[Yy]$ ]]; then
        # Create a simple solid color wallpaper
        echo "Creating placeholder wallpaper..."
        if command -v convert &> /dev/null; then
            convert -size 1920x1080 xc:'#14151e' "$FLAKE_DIR/hypr/wp.jpg"
        else
            echo "❌ ImageMagick not found. Please manually copy a wallpaper to hypr/wp.jpg"
            exit 1
        fi
    else
        echo "❌ Please copy your wallpaper to hypr/wp.jpg and run this script again"
        exit 1
    fi
fi

# Setup p10k config
echo "⚡ Setting up Powerlevel10k config..."

if [ ! -f "$FLAKE_DIR/.p10k.zsh" ]; then
    if [ -f "$HOME/.p10k.zsh" ]; then
        echo "📋 Copying existing .p10k.zsh from home directory"
        cp "$HOME/.p10k.zsh" "$FLAKE_DIR/.p10k.zsh"
    else
        echo "⚠️  No .p10k.zsh found. Creating minimal config..."
        cat > "$FLAKE_DIR/.p10k.zsh" << 'EOF'
# Minimal p10k config
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)
EOF
    fi
fi

# Choose installation method
echo ""
echo "🎯 Choose installation method:"
echo "   1) Home Manager only (recommended for existing systems)"
echo "   2) Full NixOS system rebuild"
echo ""
read -p "Enter choice (1 or 2): " choice

case $choice in
    1)
        echo "🏠 Installing with Home Manager..."
        
        # Check if home-manager is available
        if ! command -v home-manager &> /dev/null; then
            echo "❌ home-manager not found. Installing..."
            nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
            nix-channel --update
            nix-shell '<home-manager>' -A install
        fi
        
        echo "🔄 Applying Home Manager configuration..."
        home-manager switch --flake "$FLAKE_DIR#lain"
        ;;
        
    2)
        echo "🖥️  Installing as NixOS system..."
        
        # Check if hardware-configuration.nix exists
        if [ ! -f "$FLAKE_DIR/hardware-configuration.nix" ]; then
            if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
                echo "📋 Copying hardware-configuration.nix from /etc/nixos/"
                sudo cp /etc/nixos/hardware-configuration.nix "$FLAKE_DIR/"
            else
                echo "❌ hardware-configuration.nix not found. Please generate it first:"
                echo "   sudo nixos-generate-config --dir $FLAKE_DIR"
                exit 1
            fi
        fi
        
        echo "🔄 Applying NixOS configuration..."
        sudo nixos-rebuild switch --flake "$FLAKE_DIR#desktop"
        ;;
        
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "✅ Installation complete!"
echo ""
echo "🎉 Next steps:"
echo "   1. Log out and log back in to start Hyprland"
echo "   2. Use Super+Q to open terminal"
echo "   3. Use Super+R to open application launcher"
echo "   4. Customize the configuration in $FLAKE_DIR"
echo ""
echo "📚 See README.md for more information and troubleshooting"
