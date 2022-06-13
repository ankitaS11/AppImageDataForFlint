#!/bin/bash
# Author: Ankita Sharma (https://github.com/ankitaS11)
# This script is to faciliate building an AppImage for the FLINT repository
# The AppImage built using this script has been, so far, tested on Ubuntu 22.04 derivatives.

sudo apt -y update && sudo apt -y upgrade
sudo apt -y install cmake build-essential

WORKDIR=/home/$USER/Downloads
mkdir -p $WORKDIR

# Install Boost
sudo apt-get -y install libboost-all-dev

# Build Turtle from source
cd $WORKDIR && git clone https://www.github.com/mat007/turtle.git && cd turtle && mkdir -p build && cd build && cmake .. && make -j$nproc && sudo make install

# Install unixODBC
cd $WORKDIR && wget http://www.unixodbc.org/unixODBC-2.3.11.tar.gz && gunzip unixODBC-2.3.11.tar.gz && tar xvf unixODBC*.tar
cd $WORKDIR && cd unixODBC-2.3.11 && ./configure && make -j$nproc && sudo make install

# Install sqlite3
sudo apt -y install libsqlite3-dev
sudo apt -y libpcre3-dev

# Install POCO
cd $WORKDIR && wget https://github.com/pocoproject/poco/archive/refs/tags/poco-1.11.1-release.tar.gz && tar xvf poco-*.tar.gz

cd $WORKDIR && cd poco-poco-1.11.1-release && mkdir -p cmake-build && cd cmake-build && \
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
        -DENABLE_PAGECOMPILER_FILE2PAGE=OFF .. && make -j$nproc && sudo make install

# This should be changed to moja-global/FLINT.git once this PR (https://github.com/moja-global/FLINT/pull/119)
# is merged.
cd $WORKDIR && git clone https://www.github.com/ankitaS11/FLINT.git && cd FLINT && git checkout fix_poco_include && cd Source && mkdir -p build && cd build && \
	cmake .. && make -j$nproc && make install DESTDIR=AppDir

# Install linuxdeploy
cd $WORKDIR/FLINT/Source/build/ && wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage && chmod +x linuxdeploy-x86_64.AppImage

# Make sure you are in the build folder of the FLINT/Source/
# This command will fail first (and it's expected)
cd $WORKDIR/FLINT/Source/build/ && ./linuxdeploy-x86_64.AppImage --appdir AppDir || true

# Copy the files from the GitHub repository:
cd $WORKDIR/FLINT/Source/build && git clone https://www.github.com/ankitaS11/AppImageDataForFlint.git && cd AppImageDataForFlint && \
	cp icon.png $WORKDIR/FLINT/Source/build/AppDir && \
	cp usr/share/applications/AppDir.desktop $WORKDIR/FLINT/Source/build/AppDir/usr/share/applications/ && \
	cd $WORKDIR/FLINT/Source/build && \
	cp bin/* AppDir/usr/bin/ && \
	./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage -i AppDir/icon.png