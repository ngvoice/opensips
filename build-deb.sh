#!/bin/bash

set -e

cd /tmp/build/opensips
mkdir /tmp/deb/
# make
# make tar
make deb
# dpkg-buildpackage -rfakeroot -us -uc
cp ../*.deb /tmp/deb
cd /tmp/deb
ls -allh .
dpkg-scanpackages . /dev/null > Packages
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
