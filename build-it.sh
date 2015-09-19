#!/bin/sh

pkg=$1
src=${2:-${pkg}}

# which git branch to operate on
branch=master

## if defined, merge from this branch rather than editing anything
#merge=master

## koji options
koji_opts="--background --skip-nvr-check"
if [ "${branch}" != "master" ]; then
koji_opts="${koji_opts} --target ${branch}-kde"
fi

# log builds done to this file
build_log=build-log.txt

#kde=4.14.12
kde=15.08.1

# true if fedpkg prep should be executed before pushing
use_prep="true"

# copious debug output
#set -x

if [ -d "${pkg}/" ]; then
pushd "${pkg}" >& /dev/null
git reset --hard HEAD && \
fedpkg switch-branch ${branch} && \
fedpkg pull

if [ ! -z "${merge}" ]; then
fedpkg switch-branch ${merge} && fedpkg pull
fi

else
fedpkg clone "${pkg}"
pushd "${pkg}" >& /dev/null
fi

# bail if package is eol'd
if [ -f "dead.package" ]; then
echo -n "dead.package: "
cat dead.package
exit 0
fi

if [ ! -z "${merge}" ]; then

fedpkg switch-branch ${branch} && \
git merge --no-edit ${merge}
if [ $? -ne 0 ]; then
  date >> FAILED.log
  exit $?
fi

else

## update sources

# check for sources.basename
if [ "${src}" == "${pkg}" -a -f "sources.basename" ]; then
src="$(cat sources.basename)"
fi

# maybe grep sources instead?  -- rex
ext=xz
if [ ! -f ${src}-${kde}.tar.${ext} -a -f  "../src/${src}-${kde}.tar.${ext}" ]; then
cp -alf "../src/${src}-${kde}.tar.${ext}" .
fedpkg new-sources ${src}-${kde}.tar.${ext}
fi

## update spec
# check if needed
old_version=$(grep "^Version:" ${pkg}.spec | awk '{print $2}')

rpmdev-vercmp $kde $old_version > /dev/null
case $? in
    0)  printf "Package has been already updated\n"
        exit 0
        ;;
    12) printf "Package has newer version that you are trying to update to\n"
        exit 1
        ;;
esac

# kde-applications bumps (should only need to do this once, and did in 14.12.1 -- rex )
#sed -i \
#  -e "s|^Source0: http://download.kde.org/%{stable}/%{version}/|Source0: http://download.kde.org/%{stable}/applications/%{version}/|g" \
#  -e "s|^BuildRequires: kdelibs4-devel >= %{version}|BuildRequires: kdelibs4-devel >= 4.14|g" \
#  -e "s|^Requires: kde-runtime%{?_kde4_version: >= %{_kde4_version}}|%{?kde_runtime_requires}|g" \
#  -e "s|^Requires: kdelibs4%{?_isa}%{?_kde4_version: >= %{_kde4_version}}|%{?kdelibs4_requires}|g" \
#  ${pkg}.spec

# update
sed -i \
  -e "s|^Version:.*|Version: ${kde}|" \
  -e 's|^Release:.*|Release: 0%{?dist}|' \
  ${pkg}.spec

rpmdev-bumpspec --comment="${kde}" ${pkg}.spec

# Test prep to see if all patches can be applied successfully
if [ "$use_prep" == "true" ]; then
    fedpkg prep > /dev/null
    if [ $? -ne 0 ]; then
        date >> FAILED.log
        exit $? 
    fi
fi

fedpkg commit --clog 
fi

fedpkg push && \
fedpkg build --nowait ${koji_opts}
fedpkg clean

popd >& /dev/null

echo ${pkg} >> ${build_log} 

# silly requirement @ rex's site, whose IT assumes you're a hacker 
# for doing > 25 outgoing ssh connects in 5 minutes
#sleep 20
