sleep 10
echo 4096M >/sys/block/zram0/disksize
mkswap /data/zram0
swapon  /data/zram0
# VM settings to improve overall user experience and performance.
for vm in /proc/sys/vm/
do
if [[ -d "/proc/sys/vm" ]]
then
write "${vm}drop_caches" "6"
write "${vm}dirty_background_ratio" "100"
write "${vm}dirty_ratio" "100"
write "${vm}dirty_expire_centisecs" "6000"
write "${vm}dirty_writeback_centisecs" "6000"
write "${vm}page-cluster" "0"
write "${vm}stat_interval" "10"
write "${vm}swappiness" "200"
write "${vm}swap_ratio_enable" "1"
write "${vm}swap_ratio" "200"
write "${vm}vfs_cache_pressure" "200"