#!/bin/sh
if [ -z "$KDEDIRS" ]; then
  export KDEDIRS=/usr/share/kde-settings/kde-profile/minimal/:/usr/share/kde-settings/kde-profile/default/
else
  export KDEDIRS=/usr/share/kde-settings/kde-profile/minimal/:$KDEDIRS
fi
