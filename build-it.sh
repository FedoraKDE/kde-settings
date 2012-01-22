#!/bin/sh

pkg=$1
src=${2:-${pkg}}

# which git branch to operate on
branch=master

## if defined, merge from this branch rather than editing anything
#merge=master

## koji options
#koji_opts=--background
#koji_opts=--target f16-kde

# log builds done to this file
build_log=build-log.txt

kde=4.8.0 

# true if fedpkg prep should be executed before pushing
use_prep="true"

# copious debug output for now
set -x

if [ -d "${pkg}/" ]; then
pushd "${pkg}"
fedpkg switch-branch ${branch} && \
fedpkg pull
else
fedpkg clone "${pkg}"
pushd "${pkg}"
fi



if [ ! -z "${merge}" ]; then

fedpkg switch-branch ${merge} && fedpkg pull 

fedpkg switch-branch ${branch} && \
git merge ${merge} && \
fedpkg push

else

## update sources
# maybe grep sources instead?  -- rex
if [ ! -f ${src}-${kde}.tar.bz2 -a -f  "../kde4/${src}-${kde}.tar.bz2" ]; then
cp -alf "../kde4/${src}-${kde}.tar.bz2" .
fedpkg new-sources ${src}-${kde}.tar.bz2
fi

## update spec
# check if needed
old_version=$(grep "^Version:" ${pkg}.spec | awk '{print $2}')

rpmdev-vercmp $kde $old_version
case $? in
    0)  printf "Package has been already updated\n"
        exit 0
        ;;
    12) printf "Package has newer version that you are trying to update to\n"
        exit 1
        ;;
esac

# update
sed -i \
  -e "s|Version:.*|Version: ${kde}|" \
  -e 's|Release:.*|Release: 0%{?dist}|' \
  ${pkg}.spec

rpmdev-bumpspec --comment="${kde}" ${pkg}.spec

fi

# Test prep to see if all patches can be applied successfully
if [ "$use_prep" == "true" ];
then
    fedpkg prep || exit 1
fi

fedpkg commit --clog -p && \
fedpkg build --nowait ${koji_opts}

popd

echo ${pkg} >> ${build_log} 

# stupid requirement @ rex's site, whose IT assumes you're a hacker 
# for doing > 25 outgoing ssh connects in 5 minutes
sleep 15
