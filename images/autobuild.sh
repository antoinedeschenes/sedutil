#!/bin/bash

# Echo commands and abort on error
set -ex

# Optimal MAKEFLAGS argument if not already defined
if [ -z ${MAKEFLAGS+x} ]; then
    # Add 1 assuming disk IO will block processes from time to time.
    export MAKEFLAGS=$((1 + $(grep processor /proc/cpuinfo | wc -l)))
fi

source conf

cd ../LinuxPBA
rm -rf dist
make CONF=Release
make CONF=Release_x86_64
make CONF=Debug
make CONF=Debug_x86_64
cd ../images

cd ../linux/CLI
rm -rf dist
make CONF=Release_i686
make CONF=Release_x86_64
make CONF=Debug_i686
make CONF=Debug_x86_64
cd ../../images

./getresources

./buildpbaroot

./buildrescue

#./buildbiosLinux Release
./buildUEFI64 Release


#./buildbiosLinux Debug
./buildUEFI64 Debug


