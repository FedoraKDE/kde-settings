#!/bin/sh

pkg=$1
src=${2:-${pkg}}
kde=4.7.90

set -x

if [ -d "${pkg}/" ]; then
pushd "${pkg}"
fedpkg switch-branch master
fedpkg pull
else
fedpkg clone "${pkg}"
pushd "${pkg}"
fi

#fedpkg switch-branch f16 && fedpkg pull

#git merge master && fedpkg push

## update sources
# maybe grep sources instead?  -- rex
if [ ! -f ${src}-${kde}.tar.bz2 -a -f  "../kde4/${src}-${kde}.tar.bz2" ]; then
cp -alf "../kde4/${src}-${kde}.tar.bz2" .
fedpkg new-sources ${src}-${kde}.tar.bz2
fi

## update spec
sed -i \
  -e "s|Version:.*|Version: ${kde}|" \
  -e 's|Release:.*|Release: 0%{?dist}|' \
  ${pkg}.spec

rpmdev-bumpspec --comment="${kde}" ${pkg}.spec

fedpkg commit --clog -p &&
fedpkg build --background --nowait 
#--target f16-kde

popd

set -x

echo ${pkg} >> builds.txt
sleep 2
