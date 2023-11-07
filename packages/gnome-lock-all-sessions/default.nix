{ pkgs, lib, writeShellApplication, ... }:

writeShellApplication
{
  name = "gnome-lock-all-sessions";
  checkPhase = "";
  runtimeInputs = [];
  text = ''
    for bus in /run/user/*/bus; do
      uid=$(basename $(dirname $bus))
      if [ $uid -ge 1000 ]; then
        user=$(id -un $uid)
        export DBUS_SESSION_BUS_ADDRESS=unix:path=$bus
        if ${pkgs.su}/bin/su -c '${pkgs.dbus}/bin/dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply  /org/freedesktop/DBus org.freedesktop.DBus.ListNames' $user | grep org.gnome.ScreenSaver; then
          ${pkgs.su}/bin/su -c '${pkgs.dbus}/bin/dbus-send --session --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock' $user
        fi
       fi
    done
  '';
}
