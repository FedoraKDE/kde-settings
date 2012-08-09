
if ( ! $?QT_GRAPHICSSYSTEM_CHECKED ) then
  setenv QT_GRAPHICSSYSTEM_CHECKED 1 
  if ( ! $?QT_GRAPHICSSYSTEM ) then
    # workarond cirrus/qt bug, http://bugzilla.redhat.com/810161
    /usr/sbin/lspci |& grep -qi "VGA compatible controller: Cirrus Logic GD 5446" && setenv QT_GRAPHICSSYSTEM native
  endif
endif
