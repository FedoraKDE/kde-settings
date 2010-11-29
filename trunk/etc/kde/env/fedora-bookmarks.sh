#! /bin/sh

# copy default bookmarks to users homedir if not existing yet
if [ ! -e $HOME/.kde/share/apps/konqueror/bookmarks.xml ] \
   && [ -e /usr/share/kde-settings/kde-profile/default/share/apps/konqueror/bookmarks.xml ]; then
  mkdir -p $HOME/.kde/share/apps/konqueror/
  cp -p /usr/share/kde-settings/kde-profile/default/share/apps/konqueror/bookmarks.xml \
     $HOME/.kde/share/apps/konqueror/bookmarks.xml
fi
