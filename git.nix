{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homecfg.git;
in {
  options.homecfg.git = {
    enable = mkEnableOption "git";
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "v";
      userEmail = "lirelum#disroot.org";
    };
  };
}
