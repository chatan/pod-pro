#!/bin/bash
# a script to recursively find and copy files to a desired location  
# even works with files with $ or spaces
#
minutes=$(whiptail --title "Podcast Processor" --inputbox "Enter minute split with decimal; e.g. 3.0" 10 40 3>&1 1>&2 2>&3)
#
find ~/gPodder -type f -iname '*.mp3' -print0 |
while IFS= read -r -d '' f; 
do 
#    echo ****************  processing filename=$f
#    cp -- "$f" /media/user/VIDEO-ETC/podcasts-for-car ;
    filename=$(basename "$f")
    short=${filename:0:3}
    echo  $f
    echo
    echo  $filename
    echo
    echo   short folder name = $short
    echo
# since the gpodder folders have spaces, the $f needs to be in quotes, else error
    mp3splt -f -t $minutes -a -d $short "$f"
done 
#
#
