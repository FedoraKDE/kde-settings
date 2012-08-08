
## Make sure KDEDIRS is set
if ( ! $?KDEDIRS ) setenv KDEDIRS /usr

## When/if using prelinking, avoids use of kdeinit
if ( ! $?KDE_IS_PRELINKED ) then
  grep -qs -qs '^PRELINKING=yes' /etc/sysconfig/prelink && \
  setenv KDE_IS_PRELINKED 1
endif

## adjust QT_PLUGIN_PATH
foreach libdir ( /usr/lib64 /usr/lib )
#if ( -f ${libdir}/libkdecore.so.5 ) then
if ( $?QT_PLUGIN_PATH ) then
  if ( "${QT_PLUGIN_PATH}" !~ *${libdir}/kde4/plugins* ) then
    setenv QT_PLUGIN_PATH ${QT_PLUGIN_PATH}:${libdir}/kde4/plugins
  endif
else
  setenv QT_PLUGIN_PATH ${libdir}/kde4/plugins
endif
#endif
end

