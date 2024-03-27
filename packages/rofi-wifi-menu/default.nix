{ pkgs, lib, writeShellApplication, ... }:

with lib;
with lib.arclight;

let
  rofi-wifi-menu = pkgs.fetchFromGitHub {
    owner = "ericmurphyxyz";
    repo = "rofi-wifi-menu";
    rev = "d6debde6e302f68d8235ced690d12719124ff18e";
    sha256 = "0vjl2js3qznnsqik6i86xzq7hpcrw8g3rqdi30536j4ws52w3sqz";
    name = "rofi-wifi-menu";
  };

in
  writeShellApplication {
    name = "rofi-wifi-menu";
    checkPhase = "";
    runtimeInputs = [];
    text = builtins.replaceStrings 
      [ "rofi" "Wi-Fi SSID:" "device wifi list"] 
      [ "rofi -normal-window -theme '~/.config/rofi/wifi.rasi'" "SSID" "device wifi list --rescan yes" ]
        ''
          ${ builtins.readFile ( builtins.toPath "${rofi-wifi-menu}/rofi-wifi-menu.sh" ) };
        '';
  }

