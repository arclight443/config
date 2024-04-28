{ options, inputs, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.wlroots.swaylock;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

in
{
  options.arclight.desktop.utils.wlroots.swaylock = with types; {
    enable = mkBoolOpt false "Whether or not to enable swaylock";
  };


  config = mkIf cfg.enable {
 
    security.pam.services.swaylock = {};

    # udev rule works but can't unlock with yubico pam if swaylock is run by the udev rule (usb error: permission denied). Lock manually for now
    #services.udev.extraRules = if config.arclight.security.yubikey.enable then ''
    #  ACTION=="remove", ENV{DEVTYPE}=="usb_device", ENV{PRODUCT}=="1050/407*", RUN+="${pkgs.su}/bin/su - ${config.arclight.user.name} -c 'XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-1 ${pkgs.swaylock-effects}/bin/swaylock --debug'"
    #'' else "";

    arclight.home.extraOptions = {

      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings = {
          screenshots             = true;
          clock                   = true;
          grace                   = 0.5;
          grace-no-mouse          = true;
          indicator-idle-visible  = true;
          indicator-radius        = 100;
          indicator-thickness     = 7;
          submit-on-touch         = true;
          fade-in                 = 0.2;
          font                    = "Iosevka";
          effect-blur             = "7x5";
          effect-vignette         = "0.5:0.5";
          effect-scale            = 0.5;
          text-color              = "ddc7a1";
          text-clear-color        = "ddc7a1";
          text-caps-lock-color    = "ddc7a1";
          text-ver-color          = "ddc7a1";
          text-wrong-color        = "ddc7a1";
          ring-color              = "32302f";
          ring-clear-color        = "f2e5bc";
          ring-caps-lock-color    = "7daea3";
          ring-ver-color          = "89b482";
          ring-wrong-color        = "ea6962";
          inside-color            = "29282888";
          inside-clear-color      = "29282888";
          inside-ver-color        = "29282888";
          inside-wrong-color      = "29282888";
          key-hl-color            = "7daea3";
          line-color              = "00000000";
          line-clear-color        = "00000000";
          line-caps-lock-color    = "00000000";
          line-ver-color          = "00000000";
          line-wrong-color        = "00000000";
          separator-color         = "00000000";
        };
      };

    };

  };

}
