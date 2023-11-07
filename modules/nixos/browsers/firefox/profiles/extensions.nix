{ pkgs, lib, inputs, ... }:

let
  extensions = inputs.firefox-addons.packages;
in
{
  base = with extensions.${pkgs.system}; [
    ublock-origin
    i-dont-care-about-cookies
    don-t-fuck-with-paste
  ];

  browsing = with extensions.${pkgs.system}; [
    tridactyl
    xbrowsersync
    darkreader
  ];

  containers = with extensions.${pkgs.system}; [
    multi-account-containers
    open-url-in-container
  ];
}

