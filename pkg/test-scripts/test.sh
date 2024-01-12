#!/usr/bin/env bash

set -eo pipefail
set -x

case $1 in
  post-install)
    echo -e "\nINSTALLED KEYRING SHOULD MATCH ONLINE COPY:"
    wget -qO- https://packages.nlnetlabs.nl/aptkey.asc | gpg --dearmor | diff -q /usr/share/keyrings/nlnetlabs-archive-keyring.gpg -

    # define $ID, which is 'debian', 'ubuntu', ..
    . /etc/os-release

    echo -e "\nAPT UPDATE SHOULD FAIL TO AUTHENTICATE WITHOUT SIGNED-BY LINE:"
    echo "deb [arch=$(dpkg --print-architecture)] https://packages.nlnetlabs.nl/linux/${ID} ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/nlnetlabs.list
    ! apt-get update -o Debug::Acquire::gpgv=1

    echo -e "\nAPT UPDATE SHOULD SUCCEED TO AUTHENTICATE WITH SIGNED-BY LINE:"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nlnetlabs-archive-keyring.gpg] \
    https://packages.nlnetlabs.nl/linux/${ID} ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/nlnetlabs.list
    apt-get update -o Debug::Acquire::gpgv=1
    # when debugging -o Debug::Acquire::https=1 may prove useful too

    echo -e "\nAPT INSTALL SHOULD NOW WORK:"
    apt-get install --simulate --yes routinator
    ;;
  post-upgrade)
    ;;
esac
