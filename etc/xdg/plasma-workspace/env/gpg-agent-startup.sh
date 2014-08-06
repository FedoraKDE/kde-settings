#!/bin/sh

GPG_AGENT=/usr/bin/gpg-agent
## Run gpg-agent only if not already running, and available
if [ -x "${GPG_AGENT}" ] ; then

  # gpg-agent uses ~/.gpg-agent-info by default, but we'll try to use 
  # XDG_RUNTIME_DIR too for added safety
  GPG_AGENT_INFO_FILE=${XDG_RUNTIME_DIR:-${HOME}}/.gpg-agent-info

  # check validity of GPG_SOCKET (in case of session crash)
  if [ -f "${GPG_AGENT_INFO_FILE}" ]; then
    GPG_AGENT_PID=`cat ${GPG_AGENT_INFO_FILE} | cut -f2 -d:`
    GPG_PID_NAME=`ps -p ${GPG_AGENT_PID} -o comm=`
    if [ ! "x${GPG_PID_NAME}" = "xgpg-agent" ]; then
      rm -f "${GPG_AGENT_INFO_FILE}" 2>&1 >/dev/null
    else
       GPG_SOCKET=`cat "${GPG_AGENT_INFO_FILE}" | cut -f1 -d: | cut -f2 -d=`
       if ! test -S "${GPG_SOCKET}" -a -O "${GPG_SOCKET}" ; then
         rm -f "${GPG_AGENT_INFO_FILE}" 2>&1 >/dev/null
       fi
    fi
    unset GPG_AGENT_PID GPG_SOCKET GPG_PID_NAME
  fi

  if [ -f "${GPG_AGENT_INFO_FILE}" ]; then
    eval "$(cat "${GPG_AGENT_INFO_FILE}")"
    eval "$(cut -d= -f1 < "${GPG_AGENT_INFO_FILE}" | xargs echo export)"
    export GPG_TTY=$(tty)
  else
    eval "$(${GPG_AGENT} -s --daemon --write-env-file ${GPG_AGENT_INFO_FILE})"
  fi

  unset GPG_AGENT_INFO_FILE

fi

unset GPG_AGENT
