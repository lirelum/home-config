{
  config,
  pkgs,
  ...
}: let
  inputs = config.homecfg.inputs;
  nixGLOverlay = final: prev: {
    nixGLWrap = pkg:
      final.runCommand "${pkg.name}-nixgl-wrapper" {} ''
        mkdir $out
        ln -s ${pkg}/* $out
        rm $out/bin
        mkdir $out/bin
        for bin in ${pkg}/bin/*; do
          wrapped_bin=$out/bin/$(basename $bin)
          echo "exec ${final.nixgl.auto.nixGLDefault}/bin/nixGL $bin \"\$@\"" > $wrapped_bin
          chmod +x $wrapped_bin
        done
      '';
  };
  unstable-pkgs = final: prev: {
    unstable = import inputs.unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
in {
  nixpkgs.overlays = [
    inputs.nixgl.overlay
    nixGLOverlay
    unstable-pkgs
  ];
}
