#!/usr/bin/env bash

set -eo pipefail
set -x

case $1 in
  post-install)
    apt-get install -y curl
    echo -e "\nINSTALLED KEYRING SHOULD MATCH ONLINE COPY:"
    curl -fsSL https://packages.nlnetlabs.nl/aptkey.asc | sudo gpg --dearmor | diff -q /usr/share/keyrings/nlnetlabs-archive-keyring.gpg -

    echo -e "\nPACKAGE INSTALL SHOULD FAIL TO AUTHENTICATE WITHOUT SIGNED-BY LINE:"
    echo "deb [arch=$(dpkg --print-architecture)] https://packages.nlnetlabs.nl/linux/${ID} $(lsb_release -cs) main" > /etc/apt/sources.list.d/nlnetlabs.list
    apt update
    ! apt-get install --simulate --yes routinator || false

    echo -e "\nPACKAGE INSTALL SHOULD NOW AUTHENTICATE:"
    . /etc/os-release
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nlnetlabs-archive-keyring.gpg] https://packages.nlnetlabs.nl/linux/${ID} \
    $(lsb_release -cs) main" > /etc/apt/sources.list.d/nlnetlabs.list
    apt update
    apt-get install --simulate --yes routinator
    ;;
  post-upgrade)
    ;;
esac
