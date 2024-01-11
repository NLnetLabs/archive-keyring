# NLnet Labs archive keyring for Debian and derivatives

This repo exists to build a `nlnetlabs-archive-keyring` package to facilitate
key rolls for our package signing key. In the event of a roll, it will supply
an updated copy of the key(s) that are used to authenticate the packages we
supply on our (third party) package repository.

[Packaging](.github/workflows/packaging.yml) and
[package tests](pkg/test-scripts/test.sh) using
[Ploutos](https://github.com/NLnetLabs/ploutos/).
