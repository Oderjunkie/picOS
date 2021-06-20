#!/bin/bash

[ ! -d "./src/" ] && mkdir src
cd src

export PREFIX="$PWD/cross/"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

[ ! -f "./binutils.tar.gz" ] && curl https://ftp.gnu.org/gnu/binutils/binutils-2.36.tar.gz --output binutils.tar.gz
[ ! -d "./binutils-2.36/" ]  && tar -xzf binutils.tar.gz
[ ! -f "./gcc.tar.gz" ]      && curl https://ftp.gnu.org/gnu/gcc/gcc-11.1.0/gcc-11.1.0.tar.gz --output gcc.tar.gz
[ ! -d "./gcc-11.1.0/" ]     && tar -xzf gcc.tar.gz
[ -d "./build-binutils/" ]   && rm -rf ./build-binutils/
[ -d "./build-gcc/" ]        && rm -rf ./build-gcc/
mkdir build-binutils
mkdir build-gcc
cd build-binutils
../binutils-2.36/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install
cd ../build-gcc/
../gcc-11.1.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
