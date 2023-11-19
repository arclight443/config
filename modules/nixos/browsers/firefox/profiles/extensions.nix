{ pkgs, ... }:

let
  nur = pkgs.nur.repos.rycee.firefox-addons;
  personal = pkgs.firefox-addons;
in
{
  base = with nur; [
    ublock-origin
    i-dont-care-about-cookies
    don-t-fuck-with-paste
  ] ++ (with personal; [
    get-rss-feed-url
    tineye-reverse-image-search
    simple-translate
    pipewire-screenaudio
  ]);

  browsing = with nur; [
    tridactyl
    xbrowsersync
    darkreader
  ];

  containers = with nur; [
    multi-account-containers
    open-url-in-container
  ];

  streaming = with personal; [
    pipewire-screenaudio
  ];
}

