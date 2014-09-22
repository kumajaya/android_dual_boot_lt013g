VERSION=$(/sbin/busybox cat /res/misc/version.txt)

set_perm() {
  busybox chown $1.$2 $4
  busybox chmod $3 $4
}

ch_con() {
  busybox chcon u:object_r:system_file:s0 $1
}

if busybox [ ! -f /system/blackhawk-next/release-$VERSION- ]; then
  # Remount system RW
  busybox mount -o remount,rw /system

  # Ensure /system/xbin exists
  busybox mkdir -p /system/xbin
  set_perm 0 0 0755 /system/xbin

  # Ensure /system/etc/init.d exists
  busybox mkdir -p /system/etc/init.d
  set_perm 0 0 0755 /system/etc/init.d

  # su
  busybox rm -f /system/bin/su
  busybox rm -f /system/xbin/su
  busybox rm -f /system/xbin/daemonsu
  busybox rm -f /system/bin/.ext/.su
  # busybox rm -f /system/etc/install-recovery.sh
  busybox rm -f /system/etc/init.d/99SuperSUDaemon
  busybox rm -f /system/etc/.installed_su_daemon

  busybox mkdir -p /system/bin/.ext
  busybox cp -f /res/misc/su /system/xbin/su
  busybox cp -f /res/misc/su /system/bin/.ext/.su

  set_perm 0 0 0777 /system/bin/.ext
  set_perm 0 0 06755 /system/bin/.ext/.su
  set_perm 0 0 06755 /system/xbin/su

  ch_con /system/bin/.ext/.su
  ch_con /system/xbin/su

  if /sbin/busybox [ -f /system/priv-app/SecSettings.apk ]; then
    # KitKat su daemon
    busybox cp -f /res/misc/su /system/xbin/daemonsu
    busybox cp -f /res/misc/99SuperSUDaemon /system/etc/init.d/99SuperSUDaemon
    # busybox cp -f /res/misc/install-recovery.sh /system/etc/install-recovery.sh
    busybox echo 1 > /system/etc/.installed_su_daemon

    set_perm 0 0 0755 /system/xbin/daemonsu
    set_perm 0 0 0755 /system/etc/init.d/99SuperSUDaemon
    # set_perm 0 0 0755 /system/etc/install-recovery.sh
    set_perm 0 0 0644 /system/etc/.installed_su_daemon

    ch_con /system/xbin/daemonsu
    ch_con /system/etc/init.d/99SuperSUDaemon
    # ch_con /system/etc/install-recovery.sh
    ch_con /system/etc/.installed_su_daemon

    # KitKat external sdcard access for user apps
    cd /
    busybox patch -N -p1 < /res/misc/platform.xml.patch
  fi

  /system/xbin/su --install

  # Ensure /system/lib/modules exists
  busybox mkdir -p /system/lib/modules
  set_perm 0 0 0755 /system/lib/modules
  
  # Extended kernel modules
  busybox rm -f /system/etc/init.d/02modules
  busybox cp -f /res/misc/02modules /system/etc/init.d/02modules
  set_perm 0 0 0755 /system/etc/init.d/02modules

  # CM userinit
  busybox rm -f /system/etc/init.d/90userinit
  busybox cp -f /res/misc/90userinit /system/etc/init.d/90userinit
  set_perm 0 0 0755 /system/etc/init.d/90userinit
  
  # Once be enough
  busybox mkdir -p /system/blackhawk-next
  set_perm 0 0 0755 /system/blackhawk-next
  busybox rm /system/blackhawk-next/*
  busybox echo 1 > /system/blackhawk-next/release-$VERSION-

  # Remount system RO
  busybox sync
  busybox mount -o remount,ro /system
fi;
