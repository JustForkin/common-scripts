#!/usr/bin/env python3
from i3pystatus import Status
from collections import defaultdict
from string import Formatter
from i3pystatus.weather import weathercom
from i3pystatus import IntervalModule

status = Status()

# Date and time,
# e.g. Saturday 22 December 2018 06:25:05 PM
status.register("clock",
    format="%A %d %B %Y %r")

# Disk usage on /data, as measured using df
# Note, this will not work if it has a Btrfs
# file system.
status.register("disk",
    path="/data",
    round_size=1,
    format="/data {used}/{total}G")

# Root filesystem usage, that even works for Btrfs
status.register("shell",
    command="/usr/local/bin/rfs-usage",
    color="#FFFFFF",
    interval=1)

# RAM usage
status.register("mem",
    format="RAM {used_mem}/{total_mem}G",
    color="#FFFFFF",
    divisor=1073741824,
    interval=1,
    round_size=3)

# CPU load
status.register("load",
    format="Load {avg1}",
    interval=1)

# CPU
status.register("cpu_usage",
    format="CPU {usage}%",
    interval=1)

# Network upload and download rates
status.register("network", 
    interface="enp24s0", 
    format_up="↓{bytes_recv}KB/s ↑{bytes_sent}KB/s",
    interval=1)

# Audio volume
status.register("pulseaudio")

# Temperature and weather conditions
status.register(
    'weather',
    format='{condition} {current_temp}{temp_unit}',
    colorize=True,
    hints={'markup': 'pango'},
    backend=weathercom.Weathercom(
        location_code='ASXX0117:1:AS',
        units="metric",
    ))

# Uptime
status.register("uptime",
    format="Up {hours}:{mins}:{secs}",
    interval=1)

# Check status of my OBS packages, whether there are any build errors
status.register("shell",
    command="/usr/local/bin/obs-error",
    color="#F3AC29",
    interval=300)

# Operating system
status.register("shell",
    command="/usr/local/bin/operating-system",
    color="#FFCA99",
    interval=10000000)

#status.register("shell",
#    command="/usr/local/bin/tville-weather",
#    color="#AAFFFF",
#    interval=1800)
