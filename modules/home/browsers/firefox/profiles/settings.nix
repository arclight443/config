{ config, ... }: {

  "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # userchrome.css
  "svg.context-properties.content.enabled" = false; # Nav bar fix
  "layout.css.prefers-color-scheme.content-override" = 2; # Site theme follows system

  "signon.rememberSignons" = false;
  "signon.autofillForms" = false;
  "signon.formlessCapture.enabled" = false;

  "browser.shell.checkDefaultBrowser" = false;
  "browser.uitour.enabled" = false;
  "apps.update.auto" = false;
  "browser.aboutwelcome.enabled" = false;
  "browser.meta_refresh_when_inactive.disabled" = true;

  "extensions.pocket.enabled" = false; # Pocket
  "extensions.screenshots.disabled" = true; # Firefox Screenshots
  "identity.fxaccounts.enabled" = false; # Firefox Sync Account

  "ui.key.menuAccessKeyFocuses" = false;

  "layers.acceleration.force-enabled" = true;
  "mozilla.widget.use-argb-visuals" = true;
  "widget.wayland.fractional-scale.enabled" = false;
  
  "devtools.toolbox.host" = "window";

  "ui.textScaleFactor" = 100;
  "layout.css.devPixelsPerPx" =  2.0;
  "browser.zoom.siteSpecific" = false;
  "browser.display.os-zoom-behavior" = 1;
}

