#!/bin/bash

# Ketut P. Kumajaya ketut.kumajaya @ forum.xda-developers.com
# Jan 2011, Sept 2011, Feb 2013, Mar 2014
# Need unpackbootimg in your PATH

usage="usage: unpackbootimg.sh boot.img [gzip] [lzma] [lzo] [xz]"

zip="gzip"
if [ "$2" = "lzma" ]; then
  zip="lzma"
  else if [ "$2" = "lzo" ]; then
    zip="lzop"
    else if [ "$2" = "xz" ]; then
      zip="xz"
    fi
  fi
fi

cd $PWD
if [ "$1" = "" ]; then
  echo $usage
else
  mkdir -p unpack-$1
  rm -rf unpack-$1/*
  unpackbootimg -i $1 -o unpack-$1
  mkdir -p unpack-$1/$1-ramdisk
  cd unpack-$1/$1-ramdisk
  $zip -dc ../$1-ramdisk.gz | cpio -i
  cd ../../
  rm unpack-$1/$1-ramdisk.gz
fi;
