{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homecfg.shell;
in {
  options.homecfg.shell = {
    enable = mkEnableOption "shell configuration";
  };
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ls = "ls --color=auto";
        ll = "ls -l";
        la = "ls -la";
        hm = "home-manager";
        hms = "home-manager switch --impure";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
    };
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.zellij = {
      enable = true;
      settings = {
        default_shell = "${pkgs.zsh}/bin/zsh";
        default_layout = "compact";
      };
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
