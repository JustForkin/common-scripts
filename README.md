# common-scripts
These are scripts common to all my Linux distros. They're designed to reduce my work load when adding functions that I use on all distros. I use these as submodules of most of my Linux scripts repositories, such as:

* [arch-scripts](https://github.com/fusion809/arch-scripts)
* [centos-scripts](https://github.com/fusion809/centos-scripts)
* [debian-scripts](https://github.com/fusion809/debian-scripts)
* [fedora-scripts](https://github.com/fusion809/fedora-scripts)
* [gentoo-scripts](https://github.com/fusion809/gentoo-scripts)
* [mageia-scripts](https://github.com/fusion809/mageia-scripts)
* [nixos-scripts](https://github.com/fusion809/nixos-scripts)
* [opensuse-scripts](https://github.com/fusion809/opensuse-scripts)
* [pclinuxos-scripts](https://github.com/fusion809/pclinuxos-scripts)
* [pisi-scripts](https://github.com/fusion809/pisi-scripts)
* [sabayon-scripts](https://github.com/fusion809/sabayon-scripts)
* [slackware-scripts](https://github.com/fusion809/slackware-scripts)
* [void-scripts](https://github.com/fusion809/void-scripts)

## What's in the bottom bar
The top bar has indicators as to the status (up to date or not) of the various packages I maintain, or build locally. This differs from time to time and I do not see much point listing them all. The bottom bar's right-hand corner is more invariant, and contains, from right to left:

* Date in `%A %d %B %Y %r` format in your system's timezone. 
* Root filesystem usage in GB. If you have a separate home partition (which I don't, I use /data instead and symlink what I need to into /home).
* /data filesystem usage in GB.
* RAM usage in GB.
* CPU load.
* CPU usage in %.
* Upload/download rates in KB/s.
* Audio volume in %.
* Uptime in hours, mins and seconds.
* List of openSUSE Build Service errors for my [home project](https://build.opensuse.org/project/show/home:fusion809). I sometimes edit it so that certain package errors are ignored, this is usually the case when the issue is coming from upstream (whether that be OBS maintainers, distro repo maintainers or the upstream developers of the program I am packaging) and I have either filed a bug report to the appropriate upstream party or have posted a complaint to a mailing list and am waiting for upstream to fix things. 
* My distro, including its name and version.
* My unread GitHub notifications, this one needs a [github.py](https://github.com/fusion809/i3-configs/blob/archlinux/.i3/github.py.generic) script that I have included in generic form, not including my own access token, which is something that must be generated ([here](https://github.com/settings/tokens/new) is where you do that, you must be logged into GitHub in order to do this) and not uploaded to GitHub (it will revoke it). github.py.generic needs to be copied to ~/.i3/github.py and edited accordingly (incorporating said token) in order for these configs to work.

Then there are icons/numbers pertaining to my various opened workspaces. This varies significantly from time to time. 
