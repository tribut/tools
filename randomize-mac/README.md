# Randomize MAC automatically on Ubuntu systems

This directory contains
 * **if-post-down.d/randomize-mac** a shell script to randomize an interface's mac address using macchanger, possibly shutting down the interface first (for wifi cards that generally are up for scanning) while logging the result to syslog. This script is compatible with NetworkMangager's post-down hook.
 * **init/randomize-mac.conf** an upstart job to randomize the MAC address of all interfaces on system startup using said script

Please see the comments in the respective files for more information.
