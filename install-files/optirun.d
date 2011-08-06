#!/bin/bash

### BEGIN LICENSE
#
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <davy.renaud@laposte.net> wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return Davy Renaud (glyptostroboides)
# ----------------------------------------------------------------------------
#

#    This file is part of bumblebee-ui.
#
#    bumblebee-ui is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    bumblebee-ui is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with bumblebee-ui.  If not, see <http://www.gnu.org/licenses/>.
#
### END LICENSE


### COMMENT
#This is a optirun script which takes arguments: compression, architecture, display (just for testing purpose).
#If the force argument is omitted, the script will not launch the app with bumblebee if the computer is on battery
#Usage :
#    ecoptirun -f -32 -c <compression_value> -d <display value>
# -f : Force optirun : force the app to be run with bumblebee if on battery
# -32 : 32Bits library : use the 32bits Nvidia driver (ecoptirun -32 is equivalent to optirun32)
# -c <compression_value> : Compression : -c must be followed by jpeg, proxy, rgb, yuv or xv argument (See the VGL doc)
# -d <display_value> : -d must be followed by :0, :1 or :2 argument (See the VGL doc)
### END COMMENT

#DEFAULT VALUE
. /etc/bumblebee/bumblebee.conf

# Should be checked!
VGL_DRIVER="/usr/lib/nvidia-bumblebee"
get_compression='0'
get_display='0'

# READ ARGUMENTS
#echo "Arguments: $@"
for arg in "$@"
    do
    case $arg in
        -f)
          ECO_MODE='0'
          echo "ECOPTIRUN : The application will be run with Bumblebee even"
          echo "if the computer is not plugged to a power supply"
          shift #force optirun if on battery
          ;;
        -32)
          VGL_DRIVER="/usr/lib32/nvidia-bumblebee" # path should be checked
          echo "ECOPTIRUN : The application will be run with Bumblebee and"
          echo "the 32bits Nvidia libraries"
          shift #launch vglrun with 32 bits nvidia driver
          ;;
        -c)
          get_compression='1'
          shift
          ;;
        -d)
          get_display='1'
          shift
          ;;
        jpeg|proxy|rgb|yuv|xv) 
          if [ "$get_compression" -eq "1" ]; then
            VGL_COMPRESS=$arg
            echo "ECOPTIRUN : Bumblebee will be used with compression : " $VGL_COMPRESS
            shift
            get_compression='0'
          else
            echo "The value jpeg, proxy, rgb, xv or xuv for the compression"
            echo "must be preceeded by the -c argument"
            exit 1
          fi
          ;;
        :0|:1|:2)
          if [ "$get_display" -eq "1" ]; then
            VGL_DISPLAY=$arg
            VGL_DISPLAY=:1
            echo "ECOPTIRUN : Bumblebee will be used with display : " $VGL_DISPLAY
            shift
            get_display='0'
          else 
            echo "The value :0, :1: ,:2 for a display must be preceeded by"
            echo "the -d argument"
            exit 2
          fi
          ;;
        *)
          if [ "$get_compression" -eq "1" ]; then 
            echo "The argument -c must be followed by one of this compression"
            echo "value : jpeg, proxy, rgb, xv or xuv."
            exit 1
          elif [ "$get_display" -eq "1" ]; then
            echo "The argument -d must be followed by one of this common"
            echo "display values : :0, :1, :2."
            exit 2
          else
                break
          fi            
          ;;
    esac
done

# Maybe output ECOPTIRUN messages after parameter validation
echo "Arguments for the application:" "$@"
echo "Eco mode:" $ECO_MODE #make sure it's set even if it's not used
echo "32 bits mode:" $lib32_mode
echo "Compression mode:" $VGL_COMPRESS
echo "Display:" $VGL_DISPLAY 

# if executed from a symlink named optirun32, use the 32b path
# Maybe remove this, use -32 arg instead

if [ "${0##*/}" = "optirun32" -a -d /usr/lib32 ]; then
    VGL_DRIVER=/usr/lib32/nvidia-bumblebee
fi

#OPTIRUN
function bumblerun_launcher 
{
# Remove colon and everything before it: :1.0 -> 1.0
display=${VGL_DISPLAY##*:}
# Remove dot and everything after it: 1.0 -> 0
display=${display%%.*}

export VGL_READBACK
export VGL_LOG

bumblerun "-c $VGL_COMPRESS -d $VGL_DISPLAY -ld $VGL_DRIVER $@"

}

##### This maybe needed in the daemon side
# CHECK IF ON BATTERY OR NOT

POWER_STATE=0
for state in /sys/class/power_supply/*/online; do
    POWER_STATE=$(cat "$state")
    break
done

##### This maybe needed in the daemon side
if [ "$POWER_STATE" -eq "1" ] || [ "$ECO_MODE" -eq "0" ]; then
    bumblerun_launcher $@
elif [ "$POWER_STATE" -eq "0" ]; then
    $@
else
    $@
fi

