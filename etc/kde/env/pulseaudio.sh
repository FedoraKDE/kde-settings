#!/bin/sh

if [ -x /usr/bin/pulseaudio ]; then
  /usr/bin/pulseaudio -D
fi
