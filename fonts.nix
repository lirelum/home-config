{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.homecfg.fonts;
in {
  options.homecfg.fonts = {
    enable = mkEnableOption "fonts";
    nerdfonts = mkEnableOption "patched nerdfonts";
  };
  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs;
      [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        liberation_ttf
      ]
      ++ (
        if cfg.nerdfonts
        then [(pkgs.nerdfonts.override {fonts = ["DejaVuSansMono" "Hack" "Meslo" "Noto"];})]
        else []
      );
  };
}
