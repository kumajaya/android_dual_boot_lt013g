#!/bin/bash

# Ketut P. Kumajaya ketut.kumajaya @ forum.xda-developers.com
# Jan 2011, Sept 2011, Feb 2013, Mar 2014
# Need mkbootfs and mkbootimg in your PATH

usage="usage: repackbootimg.sh boot.img [gzip] [lzma] [lzo] [xz]"

zip="gzip"
if [ "$2" = "lzma" ]; then
  zip="lzma"
  else if [ "$2" = "lzo" ]; then
    zip="lzop"
    else if [ "$2" = "xz" ]; then
      zip="xz --check=crc32 --arm --lzma2=,dict=32MiB"
    fi
  fi
fi

cd $PWD
if [ "$1" = "" ]; then
  echo $usage
else
  if [ ! -f unpack-$1/$1-base ] || [ ! -f unpack-$1/$1-cmdline ] || [ ! -f unpack-$1/$1-pagesize ] ||
     [ ! -f unpack-$1/$1-zImage ] || [ ! -d unpack-$1/$1-ramdisk ]; then
    echo "Error: Invalid ramdisk!"
  else
    echo "#!/bin/bash" > /tmp/packbootimg.sh
    echo "mkbootfs unpack-$1/$1-ramdisk | $zip > unpack-$1/$1-ramdisk.gz" >> /tmp/packbootimg.sh
    echo "mkbootimg --kernel unpack-$1/$1-zImage --ramdisk unpack-$1/$1-ramdisk.gz --base $(cat unpack-$1/$1-base) --cmdline \"$(cat unpack-$1/$1-cmdline)\" --output $1-repack" >> /tmp/packbootimg.sh
    echo "rm unpack-$1/$1-ramdisk.gz" >> /tmp/packbootimg.sh
    chmod 755 /tmp/packbootimg.sh
    /tmp/packbootimg.sh
  fi;
fi;
