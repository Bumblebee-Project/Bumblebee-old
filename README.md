About Bumblebee
===============

Bumblebee aims to provide support for [nVidia Optimus][optimus] laptops for
GNU/Linux distributions. Using Bumblebee, you can use your nVidia card for
rendering graphics which will be displayed using the Intel card.

Note that you cannot disable the Intel GPU even with Bumblebee installed.

Support for enabling and disabling the nVidia card is in development. Please
refer to section **Power Management** below.

Bumblebee has been tested on Ubuntu and Arch Linux only at present. Please
join the [`#bumblebee`][irc] channel on `irc.freenode.net` if you wish to
help testing and creating the installer.

  [optimus]: http://en.wikipedia.org/wiki/Nvidia_Optimus
  [irc]:     http://webchat.freenode.net/?channels=#bumblebee

Installation
------------

### Prerequisites

If you were using an old version of Bumblebee (`<2.3` non-Arch distribution),
please run the `cleanup` script first:

```shell
wget https://raw.github.com/Bumblebee-Project/Bumblebee/master/cleanup
chmod +x cleanup
sudo ./cleanup
```

There are several ways to get Bumblebee:

### Using your Package Manager (stable, recommended if available)

#### Ubuntu

If you are on Ubuntu prior to 11.10 you may want [newer drivers][x-updates]
than the ones available in the official repositories (recommended):

```shell
sudo add-apt-repository ppa:ubuntu-x-swat/x-updates
```

To install Bumblebee:

```shell
sudo add-apt-repository ppa:bumblebee/stable
sudo apt-get update
sudo apt-get install bumblebee
```

  [x-updates]: https://edge.launchpad.net/~ubuntu-x-swat/+archive/x-updates

#### Arch Linux

[AUR package is available][arch-aur]. Instructions are published on the
[ArchWiki][arch-wiki].

  [arch-aur]:  http://aur.archlinux.org/packages.php?ID=49469
  [arch-wiki]: https://wiki.archlinux.org/index.php/Bumblebee

#### OpenSuSE

1. Installing Bumblebee:

    Select the Bumblebee repository for your openSuSE version:

    - **openSuSE 11.3**:

        ```shell
        sudo zypper ar -f http://download.opensuse.org/repositories/home:/Bumblebee-Project:/Bumblebee/openSUSE_11.3 "Bumblebee"
        ```

    - **openSuSE 11.4**:

        ```shell
        sudo zypper ar -f http://download.opensuse.org/repositories/home:/Bumblebee-Project:/Bumblebee/openSUSE_11.4 "Bumblebee"
        ```

    - **openSuSE Tumbleweed**:

        ```shell
        sudo zypper ar -f http://download.opensuse.org/repositories/home:/Bumblebee-Project:/Bumblebee/openSUSE_Tumbleweed "Bumblebee"
        ```

    - **openSuSE Factory**:

        ```shell
        sudo zypper ar -f http://download.opensuse.org/repositories/home:/Bumblebee-Project:/Bumblebee/openSUSE_Factory "Bumblebee"
        ```

    Install bumblebee package:

    ```shell
    sudo zypper refresh
    sudo zypper install bumblebee
    ```

Or you can use Yast to add the repositories and packages.


There are also some alternative repositories:

  - **Bumblebee-unstable**: [Bumblebee-unstable][opensuse-bumblebee-unstable]
        uses the latest cvs/svn/git packages of libturbojpeg and VirtualGL.

  - **Bumblebee-develop**: [Bumblebee-develop][opensuse-bumblebee-develop]
        uses the latest cvs/svn/git packages of libturbojpeg and VirtualGL and
        the opensuse-dev branch.

  [opensuse-bumblebee-unstable]:    http://download.opensuse.org/repositories/home:/Bumblebee-Project:/Bumblebee-unstable
  [opensuse-bumblebee-develop]:     http://download.opensuse.org/repositories/home:/Bumblebee-Project:/Bumblebee-develop


### Using the Installation Script

You need to install [VirtualGL][virtgl] `>2.2.1` (`2.2.90` is advised) and
the nVidia driver before you can install Bumblebee.

#### Tarballs (stable)

Tarballs can be found at [Github][tarballs]. Download the file named like
`bumblebee-VERSION.tar.gz`, extract and install it as shown below:

```shell
wget https://github.com/downloads/Bumblebee-Project/Bumblebee/bumblebee-VERSION.tar.gz
tar xf bumblebee-VERSION.tar.gz
cd bumblebee-VERSION
sudo ./cleanup
sudo ./install
```

#### Git (stable, branch: master)

```shell
git clone git://github.com/Bumblebee-Project/Bumblebee.git
cd Bumblebee
sudo ./cleanup
sudo ./install
```

#### Git (unstable, branch: develop)

```shell
git clone git://github.com/Bumblebee-Project/Bumblebee.git -b develop --depth 1
cd Bumblebee
sudo ./cleanup
sudo ./install
```

**openSuSE** users please use:

```shell
sudo -s <command>
```

  [virtgl]:   http://www.virtualgl.org/
  [tarballs]: https://github.com/Bumblebee-Project/Bumblebee/downloads

Usage
-----

After the initial Bumblebee installation, you need to add yourself to the
`bumblebee` group:

#### Ubuntu, Arch Linux

```shell
sudo usermod -a -G bumblebee YOUR_USERNAME
```

Replace `YOUR_USERNAME` accordingly and **please double check the command**.
If you accidentally forget the `-a` option, you remove yourself from any
other groups.  

#### openSuSE

```shell
sudo -s usermod -G bumblebee YOUR_USERNAME
```

Replace `YOUR_USERNAME` accordingly.

After adding yourself to the `bumblebee` group, you need to re-login for the
changes to apply.

Applications can be started using Bumblebee by prefixing them with `optirun`.
For example, starting Firefox can be done with:

```shell
optirun firefox
```

Power Management
----------------

Since version 2.4, we added back-end support for enabling/disabling the card.
Please read [why ACPI was initially removed][acpi-removed], it will help you
understand the current situation about power management. If you understand
what it all means and wish to proceed, here is how to enable it:

1. You need to install the `acpi_call` module for your system.

  - **Ubuntu**: available on the PPA:

        ```shell
        sudo apt-get install acpi-call-tools
        ```

  - **Arch Linux**: [AUR package][arch-acpi-aur]

  - **openSuSE**: available in the Bumblebee repository:

        ```shell
        sudo zypper install acpi_call-kmp-$(uname -r | cut -f3 -d'-')
        ```

2. Edit `/etc/bumblebee/bumblebee.conf` and set power management to `Y`.
   You should also set `STOP_SERVICE_ON_EXIT` to `Y`:

    ```
    ENABLE_POWER_MANAGEMENT=Y
    STOP_SERVICE_ON_EXIT=Y
    ```

3. In Bumblebee configuration directory (`/etc/bumblebee`), create two text
   files `cardon` and `cardoff` which should just contain the calls to
   respectively enable and disable the card. Each line should contain a call,
   comments are not allowed.

4. Reboot (or restart Bumblebee daemon) to apply changes.

Check [`bumblebee.conf`][bumblebee-conf] for additional information.

  [acpi-removed]:   https://github.com/Bumblebee-Project/Bumblebee/wiki/ACPI-Removed
  [arch-acpi-aur]:  https://aur.archlinux.org/packages.php?ID=39470
  [bumblebee-conf]: https://github.com/Bumblebee-Project/Bumblebee/blob/master/install-files/bumblebee.conf

Uninstall
---------

If you used your package manager to install Bumblebee, you can use it to
uninstall it as well (recommended).

Otherwise, you can uninstall Bumblebee by running:

```shell
sudo bumblebee-uninstall
```

Reporting Bugs/Problems
-----------------------

If you have any problem, please read the
[wiki page on reporting issues][wiki-reporting-issues] before submitting a
report.

If a solution to your problem does not exist, create a bug report package
with the `bumblebee-bugreport` tool and
[open an issue on Github][github-issues].

  [wiki-reporting-issues]: https://github.com/Bumblebee-Project/Bumblebee/wiki/Reporting-Issues
  [github-issues]:         https://github.com/Bumblebee-Project/Bumblebee/issues

Developers
----------

The current Bumblebee developers are (in alphabetical order):

- ArchangeGabriel
- Lekensteyn
- paulvriens
- Samsagax
- Ximi1970

Check the [wiki page on Developers][wiki-developers] for more information.  
Various people have also contributed patches and are listed on
[Github][github-contribs].

  [wiki-developers]: https://github.com/Bumblebee-Project/Bumblebee/wiki/Developers
  [github-contribs]: https://github.com/Bumblebee-Project/Bumblebee/contributors

### Useful Links

- [Status updates on Twitter](https://twitter.com/Team_Bumblebee)
- [Repository commits on Twitter](https://twitter.com/Bumblebee_Git)
- [Join the Facebook group](http://tinyurl.com/bumblebeefacebook)
- [Launchpad team page](https://launchpad.net/~bumblebee)
