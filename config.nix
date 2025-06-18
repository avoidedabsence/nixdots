{
  hostname = "navi";
  username = "lain";
  userDescription = "lain";

  gitEnable = true;
  gitName = "alexey";
  gitEmail = "schwartzalexey@yandex.com";

  defaultEditor = "code";
  
  timeZone = "Europe/Moscow";
  locale = "en_US.UTF-8";
  
  enableNvidia = true; # open drivers, if you have legacy gpu change that in configuration.nix
  enableTLP = true; # tlp (power mgmt) for AMD iGPU, practically disables any powersaving, set to false or modify in configuration.nix you have Intel

  enableShadowsocks = true;
  shadowsocksConfigPath = "/home/lain/proj/cfg.json"; # shadowsocks server config, set enable to false if you do not want to use shadowsocks

  enablePostgreSQL = true;
  enableRedis = true;
  enableClickhouse = true;
}
