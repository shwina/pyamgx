let
  nixpkgs = import ./nixpkgs_version.nix;
  pypkgs = nixpkgs.python36Packages;
in
  import ./env.nix { inherit nixpkgs; inherit pypkgs; }
