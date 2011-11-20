
# an attempt to workaround
# http://bugzilla.redhat.com/750423
if [ -z "${XDG_DATA_HOME}" ] ; then
mkdir -p "$HOME/.local/share" ||:
else
mkdir -p "${XDG_DATA_HOME}" ||:
fi
