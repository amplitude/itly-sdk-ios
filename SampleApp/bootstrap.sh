#!/usr/bin/env bash

./carthage.sh update --platform iOS --no-use-binaries
./carthage.sh build --platform iOS --no-use-binaries
