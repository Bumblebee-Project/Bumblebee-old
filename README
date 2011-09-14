-------------------
## About Bumblebee
-------------------

Bumblebee aims to provide support for nVidia Optimus laptops for GNU/Linux
distributions. Using Bumblebee, you can use your nVidia card for rendering
graphics which will be displayed using the Intel card.

Note that you cannot disable the Intel GPU even with Bumblebee installed.

Support for enabling and disabling the the nVidia card is in development.
Please refer to section 'Power Management' below.

Currently, Bumblebee has only been tested on Ubuntu and Arch Linux. Please join
#bumblebee channel on Freenode if you wish to help testing and creating the
installer.

----------------
## Installation
----------------

There are several ways to get Bumblebee:

### Using your package manager (recommended if available):

If you were using an old version of Bumblebee (<2.3 non-Arch distribution),
please run this the first time before switching to a newer version:
1. wget https://raw.github.com/Bumblebee-Project/Bumblebee/master/cleanup
2. chmod +x cleanup
2. sudo ./cleanup

Ubuntu:
1. sudo add-apt-repository ppa:bumblebee/stable

1bis. If you are on Ubuntu prior to 11.10 and want newer drivers (recommended)
than the ones available in the official repos, run:

    sudo add-apt-repository ppa:ubuntu-x-swat/x-updates

2. sudo apt-get update
3. sudo apt-get install bumblebee

Arch Linux:
AUR package: http://aur.archlinux.org/packages.php?ID=49469
Instructions in the ArchWiki: https://wiki.archlinux.org/index.php/Bumblebee

### Using the installation script:

If you were using an old version of Bumblebee (<2.3), please run this the first
time before switching to a newer version:
1. wget https://raw.github.com/Bumblebee-Project/Bumblebee/master/cleanup
2. chmod +x cleanup
2. sudo ./cleanup

Then, you need to install VirtualGL > 2.2.1 (2.2.90 is advised) and nvidia driver.

Tarballs can be found at https://github.com/Bumblebee-Project/Bumblebee/downloads
Download the tarball named like bumblebee-VERSION.tar.gz, extract and install it:

1. Download
2. Extract:
    $ tar xf bumbleee-VERSION.tar.gz
3. Change your directory to the extracted folder:
    $ cd bumblebee-VERSION
4. (if you've previously installed Bumblebee < 2.3:)
    $ sudo ./cleanup
5. Run the installer:
    $ sudo ./install

Installation instructions for getting the code from git:

    $ git clone git://github.com/Bumblebee-Project/Bumblebee.git

Users who want to test the development code should run:

    $ git clone git://github.com/Bumblebee-Project/Bumblebee.git -b develop --depth 1

Then in order to install:

    $ cd Bumblebee
    $ sudo ./install

---------
## Usage
---------

After the initial bumblebee installation, you need to add yourself to the
'bumblebee' group:

    $ sudo usermod -a -G bumblebee YOURUSERNAME

Replace YOURUSERNAME accordingly and please double check the command, if you
forget the '-a' option, you remove yourself from other groups. After adding
yourself to the group, you need to re-login for the changes to apply.

Applications can be started using bumblebee by prefixing it with optirun. For
example, starting Firefox can be done with:

    optirun firefox

--------------------
## Power Management
--------------------

Since 2.4, we added backend support for enabling/disabling the card.

You should first read the following page:
https://github.com/Bumblebee-Project/Bumblebee/wiki/ACPI-Removed

It will help you understand the current situation about Power Management. If you
understand what that does mean, then, here is how to enable it.

You need to install acpi_call module for your system.

Ubuntu: available on the PPA. To install it, run:
sudo apt-get install acpi-call-tools

Arch Linux:
AUR package: https://aur.archlinux.org/packages.php?ID=39470

First, edit the 'bumblebee.conf' file and set power management to Y.
You should also set STOP_SERVICE_ON_EXIT to Y:

    ENABLE_POWER_MANAGEMENT=Y
    STOP_SERVICE_ON_EXIT=Y

Then, in the bumblebee conf dir, create the textfiles 'cardon' and 'cardoff'
which should just contain the calls to respectively enable and disable the card.
Each line should contain a call, comments are not allowed.
Check 'bumblebee.conf' file comments on Power Management for more informations.

After that, reboot (or restart daemon) to apply changes.

-------------
## Uninstall
-------------

If you're unsatisfied with Bumblebee, you can remove it by running:

    $ sudo bumblebee-uninstall

If you used a package version of Bumblebee, then use your package manager to
uninstall.

---------------------------
## Reporting bugs/problems
---------------------------

First of all: If you have any problem, please read this article:
https://github.com/Bumblebee-Project/Bumblebee/wiki/Reporting-Issues

Then create a bug report package with the bumblebee-bugreport tool and open an
issue on GitHub at https://github.com/Bumblebee-Project/Bumblebee/issues

--------------
## Developers
--------------

The current developers for Bumblebee are:
- ArchangeGabriel
- Lekensteyn
- Samsagax
- paulvriens
- Ximi1970
Check the https://github.com/Bumblebee-Project/Bumblebee/wiki/Developers page
for developer information.

----------------
## Useful Links
----------------

Status updates can be found here on twitter: https://twitter.com/Team_Bumblebee
Commits are flooded here:               https://twitter.com/Bumblebee_Git
You may also join the facebook group:   http://tinyurl.com/bumblebeefacebook
Launchpad Team page:                    https://launchpad.net/~bumblebee
