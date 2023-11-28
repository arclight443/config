{ config, ... }: {
  "browser.rememberSignons" = false;
  "browser.shell.checkDefaultBrowser" = false;
  "browser.aboutwelcome.enabled" = false;
  "browser.meta_refresh_when_inactive.disabled" = true;
  "ui.key.menuAccessKeyFocuses" = false;
  "extensions.pocket.enabled" = false;
  "browser.tabs.showViewButtonInToolbar" = false;
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  "layers.acceleration.force-enabled" = true; 
}
  // (
  if config.arclight.hardware.laptop.tabletpc.enable
  then {
    "layout.css.devPixelsPerPx" = 1.1;
    "ui.textScaleFactor" = 110;
  }
  else { }
)
