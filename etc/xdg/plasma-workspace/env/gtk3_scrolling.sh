#!/bin/sh

# see https://bugzilla.redhat.com/show_bug.cgi?id=1226465#c20
if [ -z "${GDK_CORE_DEVICE_EVENTS}" ]; then
GDK_CORE_DEVICE_EVENTS=1
export GDK_CORE_DEVICE_EVENTS
fi
