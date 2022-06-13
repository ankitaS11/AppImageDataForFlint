#!/bin/bash
# Author: Ankita Sharma (https://github.com/ankitaS11)
# This script is to faciliate building an AppImage for the FLINT repository
# The AppImage built using this script has been, so far, tested on Ubuntu 22.04 derivatives.

WORKDIR=/home/$USER/Downloads

# Install Boost
sudo apt-get install libboost-all-dev

# Build Turtle from source
cd $WORKDIR
git clone git@github.com:mat007/turtle.git && cd turtle
mkdir -p build && cd build
cmake .. && make -j$nproc && sudo make install

# Install unixODBC
cd $WORKDIR
wget http://www.unixodbc.org/unixODBC-2.3.11.tar.gz && gunzip unixODBC-2.3.11.tar.gz && tar xvf unixODBC*.tar
cd unixODBC-2.3.11 && ./configure && make -j$nproc && sudo make install

# Install sqlite3
sudo apt install libsqlite3-dev

# Install POCO
cd $WORKDIR
wget https://github.com/pocoproject/poco/archive/refs/tags/poco-1.11.1-release.tar.gz && tar xvf poco-*.tar.gz
cd poco-* && mkdir cmake-build && cd cmake-build
cmake -DCMAKE_BUILD_TYPE=RELEASE -DPOCO_UNBUNDLED=ON \
        -DENABLE_JSON=ON \
        -DENABLE_DATA=ON \
        -DENABLE_DATA_ODBC=ON \
        -DENABLE_DATA_SQLITE=ON \
        -DENABLE_DATA_MYSQL=OFF \
        -DENABLE_ACTIVERECORD=OFF \
        -DENABLE_ACTIVERECORD_COMPILER=OFF \
        -DENABLE_ENCODINGS=OFF \
        -DENABLE_ENCODINGS_COMPILER=OFF \
        -DENABLE_XML=OFF \
        -DENABLE_MONGODB=OFF \
        -DENABLE_REDIS=OFF \
        -DENABLE_PDF=OFF \
        -DENABLE_UTIL=OFF \
        -DENABLE_NET=OFF \
        -DENABLE_NETSSL=OFF \
        -DENABLE_CRYPTO=OFF \
        -DENABLE_SEVENZIP=OFF \
        -DENABLE_ZIP=OFF \
        -DENABLE_PAGECOMPILER=OFF \
        -DENABLE_PAGECOMPILER_FILE2PAGE=OFF ..
make -j$nproc && sudo make install

cd $WORKDIR
# This should be changed to moja-global/FLINT.git once this PR (https://github.com/moja-global/FLINT/pull/119)
# is merged.
git clone git@github.com:ankitaS11/FLINT.git && git checkout fix_poco_include && cd FLINT/Source
mkdir build && cd build
cmake .. && make -j$nproc && make install DESTDIR=AppDir

cd $WORKDIR/FLINT/Source/build/
# Install linuxdeploy
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage

chmod +x linuxdeploy-x86_64.AppImage

# Make sure you are in the build folder of the FLINT/Source/
# This command will fail first (and it's expected)
./linuxdeploy-x86_64.AppImage --appdir AppDir || true

cd $WORKDIR/FLINT/Source/build
# Copy the files from the GitHub repository:
git clone git@github.com:ankitaS11/AppImageDataForFlint.git && cd AppImageDataForFlint

cp icon.png ~/Downloads/FLINT/Source/build/AppDir/
cp usr/share/applications/AppDir.desktop ~/Downloads/FLINT/Source/build/AppDir/usr/share/applications/
cp ~/Downloads/FLINT/Source/build/bin/* AppDir/usr/bin/

# This will build a FLINT-x86_64.appimage file, the `x86_64` may vary depending on the system you are on.
./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage -i AppDir/icon.png
