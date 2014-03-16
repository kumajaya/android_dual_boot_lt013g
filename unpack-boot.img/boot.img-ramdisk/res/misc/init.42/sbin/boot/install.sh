if busybox [ ! -f /system/blackhawk-next/release-12- ]; then
  # Remount system RW
  busybox mount -o remount,rw /system

  # Ensure /system/xbin exists
  busybox mkdir -p /system/xbin
  busybox chmod 755 /system/xbin

  # Ensure /system/etc/init.d exists
  busybox mkdir -p /system/etc/init.d
  busybox chmod 755 /system/etc/init.d

  # su
  busybox rm -f /system/bin/su
  busybox cp -f /res/misc/su /system/xbin/su
  busybox chown 0.0 /system/xbin/su
  busybox chmod 6755 /system/xbin/su

  # Superuser
  # busybox rm -f /system/app/SuperUser.apk
  # busybox rm -rf /data/data/com.noshufou.android.su
  # busybox rm -f /data/dalvik-cache/*com.noshufou.android.su-*.apk*
  # busybox rm -f /data/dalvik-cache/*SuperUser.apk*
  # if [ ! -e /system/app/Superuser.apk ]; then
  #   busybox rm -rf /data/data/eu.chainfire.supersu
  #   busybox rm -f /data/dalvik-cache/*eu.chainfire.supersu-*.apk*
  #   busybox rm -f /data/dalvik-cache/*Superuser.apk*
  # fi
  # busybox rm -f /data/app/Superuser.apk
  # busybox cp -f /res/misc/Superuser.apk /system/app/Superuser.apk
  # busybox chown 0.0 /system/app/Superuser.apk
  # busybox chmod 644 /system/app/Superuser.apk

  # Clean init.d
  # cd /system/etc/init.d/
  # for f in $(busybox ls -a | busybox grep -v ^90userinit$); do
  #   busybox rm -f $f
  # done

  # Ensure /system/lib/modules exists
  busybox mkdir -p /system/lib/modules
  busybox chmod 755 /system/lib/modules
  
  # Extended kernel modules
  busybox rm -f /system/etc/init.d/02modules
  busybox cp -f /res/misc/02modules /system/etc/init.d/02modules
  busybox chown 0.0 /system/etc/init.d/02modules
  busybox chmod 755 /system/etc/init.d/02modules

  # CM userinit
  busybox rm -f /system/etc/init.d/90userinit
  busybox cp -f /res/misc/90userinit /system/etc/init.d/90userinit
  busybox chown 0.0 /system/etc/init.d/90userinit
  busybox chmod 755 /system/etc/init.d/90userinit
  
  # Once be enough
  busybox mkdir -p /system/blackhawk-next
  busybox chmod 755 /system/blackhawk-next
  busybox rm /system/blackhawk-next/*
  echo 1 > /system/blackhawk-next/release-12-

  # Remount system RO
  busybox sync
  busybox mount -o remount,ro /system
fi;
