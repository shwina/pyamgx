{ nixpkgs, pypkgs}:
let
  amgx = import ./amgx.nix { inherit nixpkgs; };
in
  pypkgs.buildPythonPackage rec {
    pname = "pyamgx";
    version = "";
    src = ../.;
    doCheck=true;
    buildInputs = [
      pypkgs.scipy
      pypkgs.numpy
      amgx
      pypkgs.cython
    ];
    AMGX_DIR = "${amgx.out}";
  }

