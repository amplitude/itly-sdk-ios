#!/usr/bin/env bash

echo "git \"$(dirname $PWD)\" \"feature\"" > ./Cartfile

./carthage.sh update --platform iOS --no-use-binaries
./carthage.sh build --platform iOS --no-use-binaries
