# AppImageDataForFlint

## Using the AppImage

The README is for those who want to build the AppImage again, but for those who just want to use it, the instructions are:
 
1. Download the AppImage: `wget https://github.com/ankitaS11/AppImageDataForFlint/raw/main/FLINT-2c65c58-x86_64.AppImage`
2. Make it executable: `chmod +x FLINT-2c65c58-x86_64.AppImage`
3. Run it: `./FLINT-2c65c58-x86_64.AppImage`

## Install required dependencies

```bash
# Install Boost
sudo apt-get install libboost-all-dev

# Build Turtle from source
git clone git@github.com:mat007/turtle.git && cd turtle
mkdir -p build && cd build
cmake .. && make -j$nproc && sudo make install

# Install unixODBC
wget http://www.unixodbc.org/unixODBC-2.3.11.tar.gz && gunzip unixODBC-2.3.11.tar.gz && tar xvf unixODBC*.tar
cd unixODBC-2.3.11 && ./configure && make -j$nproc && sudo make install

# Install sqlite3
sudo apt install libsqlite3-dev

# Install POCO
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
```

## Installing FLINT

```bash
git clone git@github.com:moja-global/FLINT.git && cd FLINT/Source
mkdir build && cd build
cmake .. && make -j$nproc && make install DESTDIR=AppDir
```

## Setting up system for AppImage building

```bash
# Install linuxdeploy
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage

chmod +x linuxdeploy-x86_64.AppImage

# Make sure you are in the build folder of the FLINT/Source/
# This command will fail first
./linuxdeploy-x86_64.AppImage --appdir AppDir
```

Set up the desktop settings: (icons, etc.)

```bash
# Copy the files from the GitHub repository:
git clone git@github.com:ankitaS11/AppImageDataForFlint.git && cd AppImageDataForFlint

cp icon.png ~/Downloads/FLINT/Source/build/AppDir/
cp usr/share/applications/AppDir.desktop ~/Downloads/FLINT/Source/build/AppDir/usr/share/applications/
cp ~/Downloads/FLINT/Source/build/bin/* AppDir/usr/bin/
```

Build the AppImage:

```bash
./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage -i AppDir/icon.png
```

