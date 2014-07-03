
## Make sure KDEDIRS is set
if ( ! $?KDEDIRS ) setenv KDEDIRS /usr

## When/if using prelinking, avoids use of kdeinit
if ( ! $?KDE_IS_PRELINKED ) then
  grep -qs -qs '^PRELINKING=yes' /etc/sysconfig/prelink && \
  setenv KDE_IS_PRELINKED 1
endif

