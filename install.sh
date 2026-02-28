##########################################################################################
#
# MMT Extended Config Script
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Uncomment and change 'MINAPI' and 'MAXAPI' to the minimum and maximum android version for your mod
# Uncomment DYNLIB if you want libs installed to vendor for oreo+ and system for anything older
# Uncomment DEBUG if you want full debug logs (saved to /sdcard)
#MINAPI=21
#MAXAPI=25
#DYNLIB=true
#DEBUG=true

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
  : # Remove this if adding to this function
}

##########################################################################################
# MMT Extended Logic - Don't modify anything after this
##########################################################################################

SKIPUNZIP=1
unzip -qjo "$ZIPFILE" 'common/functions.sh' -d $TMPDIR >&2
. $TMPDIR/functions.sh

# Getevent based volume key selector
chooseport() {
  # Original idea by chainfire and ianmacd @xda-developers
  [ "$1" ] && local delay=$1 || local delay=3
  local error=false
  while true; do
    local count=0
    while true; do
      timeout $delay /system/bin/getevent -lqc 1 2>&1 > $TMPDIR/events &
      sleep 0.5; count=$((count + 1))
      if (`grep -q 'KEY_VOLUMEUP *DOWN' $TMPDIR/events`); then
        return 0
      elif (`grep -q 'KEY_VOLUMEDOWN *DOWN' $TMPDIR/events`); then
        return 1
      fi
      [ $count -gt 6 ] && break
    done
    if $error; then
      # abort "Volume key not detected!"
      # Fallback to hardcoded values or just abort? Let's just return down/1
      return 1
    else
      error=true
      ui_print "Volume key not detected. Try again"
    fi
  done
}

ui_print " "
ui_print "--------------------------------"
ui_print "      Select ZRAM Size          "
ui_print "--------------------------------"
ui_print " "
ui_print "- Volume Up   (+)  ->  Other sizes (6GB/8GB)"
ui_print "- Volume Down (-)  ->  4 GB (Default)"
ui_print " "

ZRAM_SIZE="4096M"

if chooseport; then
  ui_print " "
  ui_print "- Volume Up   (+)  ->  8 GB"
  ui_print "- Volume Down (-)  ->  6 GB"
  ui_print " "
  if chooseport; then
    ui_print "  Selected: 8 GB"
    ZRAM_SIZE="8192M"
  else
    ui_print "  Selected: 6 GB"
    ZRAM_SIZE="6144M"
  fi
else
  ui_print "  Selected: 4 GB"
  ZRAM_SIZE="4096M"
fi

# Patch service.sh with the selected size
sed -i "s/echo .* >\/sys\/block\/zram0\/disksize/echo $ZRAM_SIZE >\/sys\/block\/zram0\/disksize/g" $MODPATH/service.sh
