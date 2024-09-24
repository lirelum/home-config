{
  description = "A very basic flake";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "unstable";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = inputs @ {self, ...}: {
    homeModules = rec {
      linuxHome = {lib, ...}: {
        imports = [
          common
        ];
        config = {
          homecfg = {
            linux = true;
          };
        };
      };

      darwinHome = {lib, ...}: {
        imports = [
          common
        ];
        config = {
          homecfg = {
            darwin = true;
          };
        };
      };

      common = {
        lib,
        config,
        pkgs,
        ...
      }: {
        imports = [
          ./alacritty.nix
          ./fonts.nix
          ./git.nix
          ./gpg.nix
          ./helix.nix
          ./shell.nix
          ./misc.nix
        ];
        options.homecfg = {
          inputs = lib.mkOption {};
          pkgs-unstable = lib.mkOption {};
          nixGLWrap = lib.mkOption {};
          linux = lib.mkEnableOption "linux profile";
          darwin = lib.mkEnableOption "darwin profile";
        };
        config = {
          homecfg = {
            inherit inputs;
            pkgs-unstable = import inputs.unstable {
              system = pkgs.system;
              config.allowUnfree = true;
            };
            nixGLWrap = import ./nixgl.nix {inherit inputs pkgs;};

            alacritty.enable = true;
            fonts.enable = true;
            git.enable = true;
            gpg.enable = true;
            helix.enable = true;
            shell.enable = true;
            misc.enable = true;
          };
        };
      };
    };
  };
}
