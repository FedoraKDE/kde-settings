#!/bin/sh

if [ -f /usr/share/themes/QtCurve/gtk-2.0/gtkrc ]; then

GTK2RC_KDE4=/usr/share/kde-settings/kde-profile/default/gtkrc-2.0-kde4
GTK2RC_KDE4_HOME=${HOME}/.gtkrc-2.0-kde4

if [ -f "$GTK2RC_KDE4" -a ! -f "$GTK2RC_KDE4_HOME" ]; then
  install -p "${GTK2RC_KDE4}" "${GTK2RC_KDE4_HOME}"
fi

if [ -z "${GTK2_RC_FILES}" ]; then
  GTK2_RC_FILES=${GTK2RC_KDE4_HOME}
elif ! echo ${GTK2_RC_FILES} | /bin/grep -q ${GTK2RC_KDE4_HOME} ; then
  GTK2_RC_FILES=${GTK2_RC_FILES}:${GTK2RC_KDE4_HOME}
fi
unset GTK2RC_KDE4 GTK2RC_KDE4_HOME

export GTK2_RC_FILES

fi

