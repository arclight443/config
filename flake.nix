{
  description = "Arclight's NixOS configuration. Heavily based on Jake Hamilton's snowfall-lib.";

  inputs = {
    # System is now on Unstable (nixpkgs = unstable, stable = 23.11)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-23.11";
    master.url = "github:nixos/nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/";
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
      inputs.nixpkgs.follows = "nixpkgs";
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
			inputs.nixpkgs.follows = "stable";
			inputs.unstable.follows = "nixpkgs";
		};

    yubikey-guide = {
      url = "github:drduh/YubiKey-Guide";
      flake = false;
    };

    gpg-base-conf = {
      url = "github:drduh/config";
      flake = false;
    };

    nix-colors.url = "github:misterio77/nix-colors";

    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";

    hyprland.url = "github:hyprwm/Hyprland/2a3429d4cfdc01794b9d6fc1b49be1da019b5606";

    waybar = {
      url = "github:Alexays/Waybar/601af3de81acc0dbe5aa967d7f10f8a69d10bd02";
    };
  
    #FIX: touch gesture broke. Pin latest working commit
    hyprgrass = {
      url = "github:horriblename/hyprgrass/360bc1c2b590423d91ee7ee21049b55c5c7a1eaa";
      inputs.hyprland.follows = "hyprland";
    };

    pyprland = {
      url = "github:hyprland-community/pyprland";
    };

    #raise = {
    #  url = "github:knarkzel/raise";
    #};

    raise = {
      url = "github:arclight443/raise/feature/move-to-current";
    };

    iio-hyprland = {
      url = "github:arclight443/iio-hyprland";
    };

    nixgl.url = "github:guibou/nixGL";

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

        nixgl.overlay

        inputs.nur.overlay
        (final: prev: {
          inherit (inputs.firefox-addons.lib.${prev.system}) buildFirefoxXpiAddon;
          firefox-addons = final.callPackage ./packages/firefox-addons { };
        })
      ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
        sops-nix.nixosModules.sops
      ];

      systems.hosts."pc".specialArgs = { inherit inputs; };
      systems.hosts."yoga".specialArgs = { inherit inputs; };

      homes.users."deck@steamdeck".modules = with inputs; [
        arkenfox.hmModules.default
        nur.hmModules.nur
        hyprland.homeManagerModules.default
        nix-colors.homeManagerModules.default
        sops-nix.homeManagerModules.sops
      ];

      homes.users."deck@steamdeck".specialArgs = { inherit inputs; };

    };
}

