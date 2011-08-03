#!/bin/bash -l

# ----------------------------------------------------------------------------
# "Red Bull License"
# <mj@casalogic.dk> wrote this file and is providing free support
# in any spare time. If you need extended support, you can fuel him up by
# donating a Red Bull here to get him through the nights..:
#
# http://tinyurl.com/bumblebee-project
# 
# ----------------------------------------------------------------------------

#
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <mj@casalogic.dk> wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return Martin Juhl
# ----------------------------------------------------------------------------
#

#    This file is part of bumblebee.
#
#    bumblebee is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    bumblebee is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with bumblebee.  If not, see <http://www.gnu.org/licenses/>.
#
BUMBLEBEEVERSION=1.7.10

source stages/determinedistro

echo
echo $DISTRO"-based distribution found."
echo

source stages/$DISTRO/checkrights

#Determine Arch x86_64 or i686
ARCH=`uname -m`

#Get tools location 
LSPCI=`which lspci`
MODPROBE=`which modprobe`

#Variables
BUMBLEBEEPWD=$PWD
CONNECTEDMONITOR="UNDEFINED"
IMAGETRANSPORT="UNDEFINED"
POWERON="UNDEFINED"
POWEROFF="UNDEFINED"
INTELBUSID="UNDEFINED"
NVIDIABUSID="UNDEFINED"

source stages/welcome 

echo
echo "Installing needed packages..."
echo 

source stages/$DISTRO/packageinstall

echo
echo "Installing acpi_module..."
echo

source stages/$DISTRO/acpicall

echo
echo "Backing up configuration..."
echo

source stages/$DISTRO/backupconf

echo
echo "Installing Bumblebee configuration and files"
echo

source stages/$DISTRO/installbumblebee.pre

source stages/$DISTRO/installbumblebee

source stages/installbumblebee.post

echo
echo "Auto-detecting hardware"
echo

source stages/autoconfiguration

source stages/busiddetection

source stages/$DISTRO/autodetectmonitor

source stages/manualselectmonitor

source stages/$DISTRO/powerconfiguration

echo
echo "Setting output device to: $CONNECTEDMONITOR"
echo

sed -i 's/REPLACEWITHCONNECTEDMONITOR/'$CONNECTEDMONITOR'/g' /etc/X11/xorg.conf.nvidia

echo
echo "Setting up Bumblebee Service"
echo

source stages/$DISTRO/setupbumblebeeservice

echo
echo "Setting up Environment variables"
echo

source stages/enviromentvariables

source stages/$DISTRO/setvariables

if [ "$DISTRO" != ubuntu ] && [ "$DISTRO" != opensuse ] ; then
    source stages/setupvglclient
fi

echo
echo "Setting up bumblebee user rights and/or stating services."
echo

source stages/$DISTRO/userrights

echo
echo
echo
echo "Ok... Installation complete..."
echo

source stages/goodbye

echo "Bumblebee Version: "$BUMBLEBEEVERSION > /etc/bumblebee

echo
echo "Press any key to finish installation..."
read

exit 0
