#!/bin/bash


echo "alias 's=sh $(cd `dirname $0`;pwd)/../bin/hssh.sh'" >> $(cd ; pwd)/.bash_profile

sort -u $(cd ; pwd)/.bash_profile > 1

cat 1 > $(cd ; pwd)/.bash_profile

rm -rf 1

source $(cd ; pwd)/.bash_profile

