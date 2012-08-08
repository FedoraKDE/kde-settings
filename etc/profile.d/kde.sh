
## Make sure KDEDIRS is set
[ -z "$KDEDIRS" ] && KDEDIRS="/usr" && export KDEDIRS

## When/if using prelinking, avoids (some) use of kdeinit
if [ -z "$KDE_IS_PRELINKED" ] ; then
  grep -qs '^PRELINKING=yes' /etc/sysconfig/prelink && \
  KDE_IS_PRELINKED=1 && export KDE_IS_PRELINKED
fi

## adjust QT_PLUGIN_PATH
for libdir in /usr/lib64 /usr/lib ; do
#if [ -f ${libdir}/libkdecore.so.5 ]; then
if [ -n "${QT_PLUGIN_PATH}" ]; then
  if ! echo ${QT_PLUGIN_PATH} | /bin/grep -q ${libdir}/kde4/plugins ; then
    QT_PLUGIN_PATH=${QT_PLUGIN_PATH}:${libdir}/kde4/plugins && export QT_PLUGIN_PATH
  fi
else
  QT_PLUGIN_PATH=${libdir}/kde4/plugins && export QT_PLUGIN_PATH
fi
#fi
done

