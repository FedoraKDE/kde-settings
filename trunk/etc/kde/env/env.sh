## from http://standards.freedesktop.org/menu-spec/latest/

# XDG_DATA_DIRS
if [ -z "${XDG_DATA_DIRS}" ] ; then
   XDG_DATA_DIRS=/usr/share/kde-settings/kde-profile/default/share:/usr/local/share:/usr/share
   export XDG_DATA_DIRS
fi

# XDG_MENU_PREFIX
if [ -z "${XDG_MENU_PREFIX}" ] ; then
   XDG_MENU_PREFIX="kde4-"
   export XDG_MENU_PREFIX
fi
