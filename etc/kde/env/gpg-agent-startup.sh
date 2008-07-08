#!/bin/sh

GPG_AGENT=/usr/bin/gpg-agent
## Run gpg-agent only if not already running, and available
if [ -x "${GPG_AGENT}" ] ; then

  # check validity of GPG_SOCKET (in case of session crash)
  GPG_AGENT_INFO_FILE=${HOME}/.gpg-agent-info
  if [ -f "${GPG_AGENT_INFO_FILE}" ]; then
    GPG_AGENT_PID=`cat ${GPG_AGENT_INFO_FILE} | cut -f2 -d:`
    GPG_PID_NAME=`ps -p ${GPG_AGENT_PID} -o comm=`
    if [ ! "x${GPG_PID_NAME}" = "xgpg-agent" ]; then
      rm -f "${GPG_AGENT_INFO_FILE}" 2>&1 >/dev/null
    else
       GPG_SOCKET=`cat "${GPG_AGENT_INFO_FILE}" | cut -f1 -d:`
       if ! test -S "${GPG_SOCKET}" -a -O "${GPG_SOCKET}" ; then
         rm -f "${GPG_AGENT_INFO_FILE}" 2>&1 >/dev/null
       fi
    fi
    unset GPG_AGENT_PID GPG_SOCKET GPG_PID_NAME
  fi

  if [ -f "${GPG_AGENT_INFO_FILE}" ]; then
    export GPG_AGENT_INFO=$(cat "${GPG_AGENT_INFO_FILE}")
    export GPG_TTY=$(tty)
  else
    eval "$(${GPG_AGENT} -s --daemon ${GPG_OPTIONS})"
    echo ${GPG_AGENT_INFO} > "${HOME}/.gpg-agent-info"
  fi

fi
