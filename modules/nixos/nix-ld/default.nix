{ inputs, options, config, pkgs, lib, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.nix-ld;
in
{
  options.arclight.nix-ld = {
    enable = mkBoolOpt false "Whether or not to enable nix-ld.";
  };

  config = mkIf cfg.enable {

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libevdev
        json_c
        libusb1
        curlFull
        openssl
      ];
    };

    environment.systemPackages = with pkgs; [
      inputs.nix-alien.packages.${pkgs.system}.default
    ];

  };

}
