#!/bin/bash
# a script to recursively find and split MP3 files in ~/gPodder folder to the USB drive in /dev/sdd1
# Even works with files with $ or spaces
#
minutes=$(whiptail --title "Podcast Processor" --inputbox "Enter split in minutes with decimal; e.g. 3.0 " 10 40 3>&1 1>&2 2>&3)
# next four lines are in case "cancel" is selected
exitstatus=$?
if [ $exitstatus != 0 ]; then
  exit $exitstatus
fi
# this gets mount point for the usb sdd1:
usb=$(findmnt -nr -o target -S /dev/sdd1)
#
if (whiptail --title "Podcast Processor" --yesno "Confirm that the usb in mounted at /dev/sdd1 is $usb" 10 60) 
then
whiptail --title "Podcast Processor" --msgbox "Confirm USB usb not open in Dolphin" 10 30
find ~/gPodder -type f -iname '*.mp3' -print0 |
while IFS= read -r -d '' f; 
do 
    filename=$(basename "$f")
    short=$(whiptail --title "Podcast Processor" --inputbox "Enter a short name for $filename " --ok-button "OK" --cancel-button "Skip" 10 40 3>&1 1>&2 2>&3)    
 exitstatus=$?
 if [ $exitstatus = 0 ]; 
  then
# for next mp3splt command:
# -  since the gpodder folders have spaces, the $f needs to be in quotes, else error
# -  custom name with the -o option:
    mp3splt -f -t $minutes -a -d $usb -o $short@n "$f"
    fi
done
# these two commands are needed to sort the mp3 files or else the media player won't play in order.
umount /dev/sdd1
sudo fatsort /dev/sdd1
else
whiptail --title "Podcast Processor" --msgbox "All done -  pull out the USB" 10 30
fi
