#!/system/bin/sh
MODDIR=${0%/*}

# Simple Bootloop protection
if [ -f "$MODDIR/boot_guard" ]; then
    # Bootloop detected (service.sh didn't run completely last time)
    touch "$MODDIR/disable"
    rm "$MODDIR/boot_guard"
    # Log the failure
    echo "Bootloop detected! POP-ZRAM module auto-disabled." > "$MODDIR/auto_disable.log"
else
    # Create guard file for this boot attempt
    touch "$MODDIR/boot_guard"
fi
