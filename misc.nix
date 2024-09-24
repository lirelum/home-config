{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homecfg.misc;
in {
  options.homecfg.misc = {
    enable = mkEnableOption "miscellaneous programs";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        zip
        unzip
        xz
        p7zip
        file
        which
        btop
        lsof
      ]
      ++ (
        if config.homecfg.linux
        then [
          (discord.override
            {
              withVencord = true;
              withOpenASAR = true;
            })
          (config.homecfg.nixGLWrap config.homecfg.pkgs-unstable.zotero)
        ]
        else []
      );
  };
}
