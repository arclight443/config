{ config, ... }: {

  "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # userchrome.css
  "svg.context-properties.content.enabled" = true; # Nav bar fix
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
  "identity.fxaccounts.enabled" = false; # Firefox Account Sync

  "ui.key.menuAccessKeyFocuses" = false;

  "layers.acceleration.force-enabled" = true;
  "mozilla.widget.use-argb-visuals" = true;
 
  "ui.textScaleFactor" = 140;
  "layout.css.devPixelsPerPx" = 1.0;
  "browser.zoom.siteSpecific" = false;
  "browser.display.os-zoom-behavior" = 1;
}

