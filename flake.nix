{
  description = "Arclight's NixOS configuration. Heavily based on Jake Hamilton's snowfall-lib.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "unstable";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    };

    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
    };

		plusultra = {
			url = "github:jakehamilton/config";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.unstable.follows = "unstable";
		};

    yubikey-guide = {
      url = "github:drduh/YubiKey-Guide";
      flake = false;
    };

    gpg-base-conf = {
      url = "github:drduh/config";
      flake = false;
    };

  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "arclight";
            title = "Arclight";
          };

          namespace = "arclight";
        };

      };
    in

    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
          permittedInsecurePackages = [
          "electron-20.3.11"
          "nodejs-16.20.0"
          "python-2.7.18.6"
          "electron-22.3.27"
        ];
      };

      overlays = with inputs; [
        snowfall-flake.overlays."package/flake"

        # Jake Hamilton's packages
        plusultra.overlays."package/nix-update-index"
        plusultra.overlays."package/nixos-option"
        plusultra.overlays."package/nixos-revision"
        plusultra.overlays."package/nix-get-protonup"
        plusultra.overlays."package/list-iommu"

        inputs.nur.overlay
        (final: prev: {
          inherit (inputs.firefox-addons.lib.${prev.system}) buildFirefoxXpiAddon;
          firefox-addons = final.callPackage ./packages/firefox-addons { };
        })
      ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
        nix-ld.nixosModules.nix-ld
        sops-nix.nixosModules.sops
      ];


    };
}

