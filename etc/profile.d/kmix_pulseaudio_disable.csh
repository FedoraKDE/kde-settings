
## Disable kmix/pulseaudio integration by default, see also
## https://bugzilla.redhat.com/563741
if ( ! $?KMIX_PULSEAUDIO_DISABLE ) setenv KMIX_PULSEAUDIO_DISABLE 1 

