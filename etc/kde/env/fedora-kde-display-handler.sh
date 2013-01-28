#!/bin/sh

# fedora-kde-display-handler.sh
# Helper script to enable kscreen kded4 module (if installed), 
# else use legacy randrmonitor, ensuring use of only one or the other

if [ -x "`kde4-config --install module`/kded_kscreen.so" ]; then
 if [ "`kreadconfig --file fedora-kde-display-handlerrc --group General --key LastRun`" = "kscreen" ]; then
  # bail-out/short-circuit
  exit 0
else
  kwriteconfig --file kdedrc --group Module-kscreen --key autoload true 
  kwriteconfig --file kdedrc --group Module-randrmonitor --key autoload false
  kwriteconfig --file fedora-kde-display-handlerrc --group General --key LastRun kscreen
  exit 0
 fi
fi

if [ -x "`kde4-config --install module`/kded_randrmonitor.so" ]; then
 if [ "`kreadconfig --file fedora-kde-display-handlerrc --group General --key LastRun`" = "randrmonitor" ]; then
  # bail-out/short-circuit
  exit 0
 else
  kwriteconfig --file kdedrc --group Module-kscreen --key autoload false 
  kwriteconfig --file kdedrc --group Module-randrmonitor --key autoload true 
  kwriteconfig --file fedora-kde-display-handlerrc --group General --key LastRun randrmonitor 
  exit 0
 fi
fi

