#!/system/bin/sh

# e/frandom permissions
chmod 444 /dev/erandom
chmod 444 /dev/frandom

# allow untrusted apps to read from debugfs
/system/xbin/supolicy --live \
	"allow untrusted_app debugfs file { open read getattr }" \
	"allow untrusted_app sysfs_lowmemorykiller file { open read getattr }" \
	"allow untrusted_app persist_file dir { open read getattr }" \
	"allow debuggerd gpu_device chr_file { open read getattr }" \
	"allow netd netd capability fsetid" \
	"allow netd { hostapd dnsmasq } process fork" \
	"allow { system_app shell } dalvikcache_data_file file write" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file dir { search r_file_perms r_dir_perms }" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file file { r_file_perms r_dir_perms }" \
	"allow system_server { rootfs resourcecache_data_file } dir { open read write getattr add_name setattr create remove_name rmdir unlink link }" \
	"allow system_server resourcecache_data_file file { open read write getattr add_name setattr create remove_name unlink link }" \
	"allow system_server dex2oat_exec file rx_file_perms" \
	"allow mediaserver mediaserver_tmpfs file execute" \
	"allow drmserver theme_data_file file r_file_perms" \
	"allow netd self capability fsetid" \
	"allow radio tap2wake_dev file r_file_perms" \
	"allow suclient sudaemon unix_stream_socket { connectto read write setopt ioctl }" \
	"allow suclient superuser_device dir { create rw_dir_perms setattr unlink }" \
	"allow suclient superuser_device sock_file { create setattr unlink write }" \
	"allow suclient untrusted_app_devpts chr_file { read write ioctl }" \
	"allow system_app superuser_device sock_file { read write create setattr unlink getattr }" \
	"allow system_app sudaemon unix_stream_socket { connectto read write setopt ioctl }" \
	"allow system_app superuser_device dir { create rw_dir_perms setattr unlink }" \
	"allow sudaemon superuser_device dir { create rw_dir_perms setattr unlink }" \
	"allow sudaemon superuser_device sock_file { create setattr unlink write }" \
	"dontaudit sudaemon self capability_class_set *" \
	"dontaudit sudaemon kernel security *" \
	"dontaudit sudaemon kernel system *" \
	"dontaudit sudaemon self:memprotect *" \
	"dontaudit sudaemon domain process *" \
	"dontaudit sudaemon domain fd *" \
	"dontaudit sudaemon domain dir *" \
	"dontaudit sudaemon domain lnk_file *" \
	"dontaudit sudaemon domain { fifo_file file } *" \
	"dontaudit sudaemon domain socket_class_set *" \
	"dontaudit sudaemon domain ipc_class_set *" \
	"dontaudit sudaemon domain key *" \
	"dontaudit sudaemon fs_type:filesystem *" \
	"dontaudit sudaemon {fs_type dev_type file_type} dir_file_class_set *" \
	"dontaudit sudaemon node_type node *" \
	"dontaudit sudaemon node_type { tcp_socket udp_socket rawip_socket } *" \
	"dontaudit sudaemon netif_type netif *" \
	"dontaudit sudaemon port_type socket_class_set *" \
	"dontaudit sudaemon port_type { tcp_socket dccp_socket } *" \
	"dontaudit sudaemon domain peer *;" \
	"dontaudit sudaemon domain binder *" \
	"dontaudit sudaemon property_type property_service *" \
	"allow suclient sudaemon unix_stream_socket { connectto read write setopt ioctl }"

# take a little more RAM from file/dir caches and give them to apps 
echo 200 > /proc/sys/vm/vfs_cache_pressure

# for lkconfig
[ ! -d "/data/data/leankernel" ] && mkdir /data/data/leankernel
chmod 755 /data/data/leankernel
chmod 755 /sbin/lkcc

# init.d support
/system/xbin/busybox run-parts /system/etc/init.d

# boot without cpu boost
echo N > /sys/modules/cpu_boost/parameters/cpuboost_enable

#
# lkconfig settings below
#

# screen_off_maxfreq
CFILE="/data/data/leankernel/screen_off_maxfreq"
SFILE="/sys/devices/system/cpu/cpufreq/interactive/screen_off_maxfreq"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# MMC CRC
CFILE="/data/data/leankernel/use_spi_crc"
SFILE="/sys/module/mmc_core/parameters/use_spi_crc"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# cpu boost
CFILE="/data/data/leankernel/cpuboost_enable"
SFILE="/sys/module/cpu_boost/parameters/cpuboost_enable"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# charging led
CFILE="/data/data/leankernel/charging_led"
SFILE="/sys/class/leds/charging"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE/trigger && echo 1 > $SFILE/max_brightness

# rgb control
CFILE="/data/data/leankernel/kcal"
SFILE="/sys/devices/platform/kcal_ctrl.0"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE/kcal && echo 1 > $SFILE/kcal_ctrl

# wake gesture control
CFILE="/data/data/leankernel/tsp"
SFILE="/sys/bus/i2c/devices/1-004a/tsp"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE
CFILE="/data/data/leankernel/doubletap2wake"
SFILE="/sys/android_touch/doubletap2wake"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE
CFILE="/data/data/leankernel/sweep2wake"
SFILE="/sys/android_touch/sweep2wake"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# vibe strength
CFILE="/data/data/leankernel/pwmvalue"
SFILE="/sys/vibrator/pwmvalue"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# cpu scheduler
CFILE="/data/data/leankernel/current_sched_balance_policy"
SFILE="/sys/devices/system/cpu/sched_balance_policy/current_sched_balance_policy"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# smb135x wakelock
CFILE="/data/data/leankernel/smb135x_use_wlock"
SFILE="/sys/module/smb135x_charger/parameters/use_wlock"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# sensor_ind wakelock
CFILE="/data/data/leankernel/sensor_ind"
SFILE="/sys/module/wakeup/parameters/enable_si_ws"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

# lkcc
CFILE="/data/data/leankernel/cc"
if [ -f "/data/data/leankernel/cc" ]; then
	val=`cat /data/data/leankernel/cc`
	case $val in
	  1)
		echo N > /sys/module/cpu_boost/parameters/cpuboost_enable
		# nofreq mpdecision binary should be in already
		# add mp5sum check etc later
		;;
	  2)
		echo Y > /sys/module/cpu_boost/parameters/cpuboost_enable
		stop mpdecision
		echo 1 > /sys/devices/system/cpu/cpu1/online
		echo 1 > /sys/devices/system/cpu/cpu2/online
		echo 1 > /sys/devices/system/cpu/cpu3/online
		echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
		echo 300000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
		echo 300000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
		echo 300000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
		;;
	  3)
		echo N > /sys/module/cpu_boost/parameters/cpuboost_enable
		stop mpdecision
		echo 1 > /sys/devices/system/cpu/cpu1/online
		echo 1 > /sys/devices/system/cpu/cpu2/online
		echo 1 > /sys/devices/system/cpu/cpu3/online
		echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
		echo 300000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
		echo 300000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
		echo 300000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
		;;
	esac
fi

# faux sound control
CFILE="/data/data/leankernel/sc"
SFILE="/sys/module/snd_soc_wcd9320/parameters/enable_fs"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE
