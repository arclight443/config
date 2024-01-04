{ pkgs, ... }:

let
  nur = pkgs.nur.repos.rycee.firefox-addons;
  personal = pkgs.firefox-addons;
in
{
  base = with nur; [
    ublock-origin
    don-t-fuck-with-paste
  ] ++ (with personal; [
    get-rss-feed-url
  ]);

  browsing = with nur; [
    tridactyl
    xbrowsersync
  ];

  containers = with nur; [
    multi-account-containers
    open-url-in-container
  ];
  
  screensharing = with personal; [
    pipewire-screenaudio
  ];
  
  streaming = with personal; [
    ultrawideo
  ];

  
}

