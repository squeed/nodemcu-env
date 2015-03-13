# MCU-Env - an environment for the NodeMCU
This is a small project to produce a simple environment and library for the NodeMCU firmware
for the ESP8266. It tries to solve these problems:

* Device discovery
* File loading
* Bootstrap control

It has two parts: a python script for control on the host side, and a lua environment
to run on the Node side


## Structure
The `init.lua` program grabs the boot process and waits for wifi. Once connected,
it sends a UDP broadcast ping to be discovered. A host program, with an open socket,
can detect this ping.

The init shim then opens a telnet server for 10 seconds. If no connections are made, it
closes the server and runs `main.lua`. If there is no such file, it keeps the telnet
server open.

The host program can "upload" files to the device by acting as a TFTP (or similar protocol)
server. It telnets to the device and issues a get command

### TODO:
python program to
- set wifi settings
- shove up bootstrapping
- send files

lua:
- TFTP client



### Incomprehensible notes.
These notes are for my own record

After a time, load main.lua

commands:
norun - don't run main.lua
run - shut down server, run main.lua

putfile <name> <addr> - have it get a file
exec <line> - run the line

probably just write functions instead of anything complicated

