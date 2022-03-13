#!/system/bin/sh

# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=false

# Set to true if you need to load system.prop
PROPFILE=true

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=true

sleep 1
ui_print "****************************************"
ui_print "      POP-ZRAM by @siimsek "
ui_print "***********************************"
sleep 1
ui_print "****************************************"
ui_print "- REPLACING OLD FILES CREATING NEW SWAP!"
sleep 1
ui_print "- SWAP PARTITION CREATED!"
ui_print "- INSTALLING PLEASE WAIT!"
sleep 1
ui_print "- INSTALLATION IS FINISHED SUCCESSFULLY!
               REBOOT NOW!"
ui_print "****************************************"