#!/usr/bin/env bash

set -eo pipefail
set -x

case $1 in
  post-install)
    apt-get install -y curl
    echo -e "\nINSTALLED KEYRING SHOULD MATCH ONLINE COPY:"
    curl -fsSL https://packages.nlnetlabs.nl/aptkey.asc | sudo gpg --dearmor | diff -q /usr/share/keyrings/nlnetlabs-archive-keyring.gpg -

    echo -e "\nAPT UPDATE SHOULD FAIL TO AUTHENTICATE WITHOUT SIGNED-BY LINE:"
    echo "deb [arch=$(dpkg --print-architecture)] https://packages.nlnetlabs.nl/linux/${ID} $(lsb_release -cs) main" > /etc/apt/sources.list.d/nlnetlabs.list
    ! apt-get update || false

    echo -e "\nAND AUTHENTICATE WITH SIGNED-BY LINE:"
    . /etc/os-release
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nlnetlabs-archive-keyring.gpg] https://packages.nlnetlabs.nl/linux/${ID} \
    $(lsb_release -cs) main" > /etc/apt/sources.list.d/nlnetlabs.list
    apt-get update

    echo -e "\nAND THUS ABLE TO INSTALL ROUTINATOR:"
    apt-get install --simulate --yes routinator
    ;;
  post-upgrade)
    ;;
esac
