{
  nixConfig.extra-substituters = [
    "https://programmerino.cachix.org"
  ];

  nixConfig.extra-trusted-public-keys = [
    "programmerino.cachix.org-1:v8UWI2QVhEnoU71CDRNS/K1CcW3yzrQxJc604UiijjA="
  ];

  description = "Forum Analysis";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
  };
  inputs.obsidianhtml = {
    #url = "path:///home/davis/Downloads/obsidian-html";
    url = "github:obsidian-html/obsidian-html";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nixpkgs = {
    url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  inputs.notes = {
    #url = "/home/davis/Documents/Obsidian";
    url = "github:Programmerino/notes";
    flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    obsidianhtml,
    notes,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };

        name = "Forum Analysis";

        project = obsidianhtml.mkProject."${system}" {
          inherit name;
          src = "${notes}/ObsidianVault";
          entrypoint = "Forum Analysis.md";
        };
      in rec {
        packages.default = project.compile;

        devShells.default = pkgs.mkShell {
          inherit name;
          buildInputs = [
            obsidianhtml.packages."${system}".default
          ];
        };

        apps.run = flake-utils.lib.mkApp {
          drv = project.run;
        };
      }
    );
}
