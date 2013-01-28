#!/bin/sh

if [ "`kreadconfig --file fedora-kde-display-handlerrc --group General --key LastRun`" = "kscreen" ]; then
 # bail-out/short-circuit
 exit 0
else
 kwriteconfig --file kdedrc --group Module-kscreen --key autoload true 
 kwriteconfig --file kdedrc --group Module-randrmonitor --key autoload false
 kwriteconfig --file fedora-kde-display-handlerrc --group General --key LastRun kscreen
 exit 0
fi
