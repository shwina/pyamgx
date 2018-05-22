let
  nixpkgs = import ./nixpkgs_version.nix;
  pypkgs = nixpkgs.python27Packages;
in
  import ./env.nix { inherit nixpkgs; inherit pypkgs; }


