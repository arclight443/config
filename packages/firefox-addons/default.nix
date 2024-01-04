{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "get-rss-feed-url" = buildFirefoxXpiAddon {
      pname = "get-rss-feed-url";
      version = "2.2";
      addonId = "{15bdb1ce-fa9d-4a00-b859-66c214263ac0}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3990496/get_rss_feed_url-2.2.xpi";
      sha256 = "c332726405c6e976b19fc41bfb3ce70fa4380aaf33f179f324b67cb6fc13b7d0";
      meta = with lib;
      {
        homepage = "https://github.com/shevabam/get-rss-feed-url-extension";
        description = "Retrieve RSS feeds URLs from a WebSite. Now in Firefox!";
        license = licenses.mit;
        mozPermissions = [
          "http://*/*"
          "https://*/*"
          "notifications"
          "<all_urls>"
          ];
        platforms = platforms.all;
        };
      };
    "pipewire-screenaudio" = buildFirefoxXpiAddon {
      pname = "pipewire-screenaudio";
      version = "0.3.4";
      addonId = "pipewire-screenaudio@icenjim";
      url = "https://addons.mozilla.org/firefox/downloads/file/4186504/pipewire_screenaudio-0.3.4.xpi";
      sha256 = "a74714514f490b6d5c36e32b88510ae3e5e7f1afdcb29c2041a836d3aa484cbe";
      meta = with lib;
      {
        homepage = "https://github.com/IceDBorn/pipewire-screenaudio";
        description = "Passthrough pipewire audio to WebRTC screenshare";
        license = licenses.gpl3;
        mozPermissions = [ "nativeMessaging" "<all_urls>" ];
        platforms = platforms.all;
        };
      };
    "ultrawideo" = buildFirefoxXpiAddon {
      pname = "ultrawideo";
      version = "2.5.6";
      addonId = "{2339288d-f701-45d0-a57f-a847e9adc6cc}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4070649/ultrawideo-2.5.6.xpi";
      sha256 = "1347ee548daeb6f8005e8bb1c65fdbf00c75a710b86db1c35bd99afe1860f384";
      meta = with lib;
      {
        homepage = "https://github.com/dvlden/ultrawideo";
        description = "The cross-browser extension that manipulates video aspect ratio to fit your entire screen.\nNetflix | Prime Video | Disney+ | Hulu | ESPN | + Many others... 🚀";
        license = licenses.mit;
        mozPermissions = [ "storage" "*://*/*" ];
        platforms = platforms.all;
        };
      };
    }