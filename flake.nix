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
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";

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
    nix-wallpaper.url = "github:lunik1/nix-wallpaper";
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
    nixgl.url = "github:guibou/nixGL";

    #hyprland.url = "github:hyprwm/Hyprland/c5e28ebcfe00a510922779b2c568cfa52a317445";
    hyprland.url = "github:hyprwm/Hyprland/3875679755014997776e091ff8903acfb311dd2f";
    raise.url = "github:arclight443/raise/feature/move-to-current";
    pypr.url = "github:hyprland-community/pyprland";
    iio-hyprland.url = "github:arclight443/iio-hyprland";
    #hyprgrass = {
    #  url = "github:horriblename/hyprgrass/65eb25c156800d62d20d0565f5e0948b9352b63a";
    #  inputs.hyprland.follows = "hyprland";
    #};

    hyprgrass = {
      url = "github:horriblename/hyprgrass/";
      inputs.hyprland.follows = "hyprland";
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

