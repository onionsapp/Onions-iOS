#!/bin/sh
set -e

xctool ARCHS=i386 ONLY_ACTIVE_ARCH=NO -project OnionStorage.xcodeproj -scheme OnionStorage -sdk iphonesimulator test