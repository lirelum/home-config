{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.homecfg) nixGLWrap;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homecfg.alacritty;
in {
  options.homecfg.alacritty = {
    enable = mkEnableOption "alacritty";
  };
  config = mkIf cfg.enable {
    homecfg.fonts.nerdfonts = true;
    programs.alacritty = {
      enable = true;
      package =
        if config.homecfg.linux
        then nixGLWrap pkgs.alacritty
        else pkgs.alacritty;
      settings = {
        env.TERM = "xterm-256color";
        shell.program = "${pkgs.zellij}/bin/zellij";
        font = {
          normal = {
            family = "MesloLGL Nerd Font";
            style = "Regular";
          };
          size =
            if config.homecfg.darwin
            then 14
            else 11.25;
        };
        window.option_as_alt = "OnlyLeft";
      };
    };
  };
}
