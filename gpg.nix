{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homecfg.gpg;
in {
  options.homecfg.gpg = {
    enable = mkEnableOption "gnupg";
  };
  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
    };
  };
}
