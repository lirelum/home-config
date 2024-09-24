{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homecfg.helix;
  inputs = config.homecfg.inputs;
in {
  options.homecfg.helix = {
    enable = mkEnableOption "helix";
  };
  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      package = inputs.helix.packages.${pkgs.system}.default;
      defaultEditor = true;
      settings = {
        theme = "onedark";
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
        };
      };
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.alejandra}/bin/alejandra";
        }
      ];
      extraPackages = with pkgs; [
        alejandra
        nil
        rust-analyzer
        haskell-language-server
        ghc
        texlab
      ];
    };
  };
}
