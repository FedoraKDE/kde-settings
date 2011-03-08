#!/bin/sh

GTK2RC_FILE=/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc
GTK2RC_KDE4=/usr/share/kde-settings/kde-profile/default/gtkrc-2.0-kde4
GTK2RC_KDE4_HOME=${HOME}/.gtkrc-2.0-kde4

if [ -f "${GTK2RC_FILE}" -a -f "${GTK2RC_KDE4}" -a ! -f "${GTK2RC_KDE4_HOME}" ]; then
  install -m644 -p "${GTK2RC_KDE4}" "${GTK2RC_KDE4_HOME}"
fi

if [ -f "${GTK2RC_KDE4_HOME}" ];then
  if [ -z "${GTK2_RC_FILES}" ]; then
    GTK2_RC_FILES=${GTK2RC_KDE4_HOME}
  elif ! echo ${GTK2_RC_FILES} | /bin/grep -q ${GTK2RC_KDE4_HOME} ; then
    GTK2_RC_FILES=${GTK2_RC_FILES}:${GTK2RC_KDE4_HOME}
  fi
  export GTK2_RC_FILES
fi

unset GTK2RC_FILE GTK2RC_KDE4 GTK2RC_KDE4_HOME

