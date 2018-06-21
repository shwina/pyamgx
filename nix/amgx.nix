{ nixpkgs ? import <nixpkgs> {} }:
let
  stdenv48 = nixpkgs.overrideCC nixpkgs.stdenv nixpkgs.pkgs.gcc48;
in
  stdenv48.mkDerivation rec {
    name = "AmgX";

    src = nixpkgs.fetchFromGitHub {
      owner = "NVIDIA";
      repo = "AMGX";
      rev = "6cb23fed26602e4873d5c1deb694a2c8480feac3";
      sha256 = "1g5zj7wzxc8b2lyn00xp7jqq70bz550q8fmzcb5mzzapa44xjk7q";
    };

    buildInputs = [
      nixpkgs.pkgs.cmake
      nixpkgs.pkgs.cudatoolkit8
    ];

    unpackPhase = ''
      cp --recursive "$src" ./
      chmod --recursive u=rwx ./"$(basename "$src")"
      cd ./"$(basename "$src")"
    '';

    configurePhase = ''
      mkdir -p build
      cd build
      mkdir --parents "$out"
      cmake -DCMAKE_INSTALL_PREFIX:PATH="$out" ../
    '';

    buildPhase = ''
      make -j"$NIX_BUILD_CORES" all
    '';
  }
