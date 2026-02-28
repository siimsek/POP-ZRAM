#!/system/bin/sh
MODDIR=${0%/*}

# Wait for boot completion
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done
sleep 10

# Simple write function that was missing
write() {
    if [ -f "$1" ]; then
        echo "$2" > "$1"
    fi
}

# Find ZRAM block device location dynamically
ZRAM_BLOCK=""
if [ -b "/dev/block/zram0" ]; then
    ZRAM_BLOCK="/dev/block/zram0"
elif [ -b "/data/zram0" ]; then
    ZRAM_BLOCK="/data/zram0"
else
    # Try to find it if it's somewhere else
    FOUND_ZRAM=$(find /dev/block -name "zram0" 2>/dev/null | head -n 1)
    if [ -n "$FOUND_ZRAM" ]; then
        ZRAM_BLOCK="$FOUND_ZRAM"
    fi
fi

if [ -n "$ZRAM_BLOCK" ]; then
    # Disable existing swap
    swapoff $ZRAM_BLOCK 2>/dev/null
    echo 1 > /sys/block/zram0/reset 2>/dev/null

    # Set new ZRAM size (this will be patched by install.sh)
    echo 4096M >/sys/block/zram0/disksize

    # Initialize and enable ZRAM swap
    mkswap $ZRAM_BLOCK
    swapon $ZRAM_BLOCK
fi

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
fi
done

# Bootloop protection - Remove guard file if boot completed successfully
if [ -f "$MODDIR/boot_guard" ]; then
    rm "$MODDIR/boot_guard"
fi
