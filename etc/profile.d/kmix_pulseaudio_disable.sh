
## Disable kmix/pulseaudio integration by default, see also
## https://bugzilla.redhat.com/563741  
[ -z "$KMIX_PULSEAUDIO_DISABLE" ] && KMIX_PULSEAUDIO_DISABLE=1 && export KMIX_PULSEAUDIO_DISABLE 

