# MCU-Env - an environment for the NodeMCU
This is a small set of programs to improve interacting with ESP8266-based devices running the
NodeMCU firmware.

It currently provides

1. Bootstrapping
1. Device discovery
1. On-network file uploading

## Components
There is a small `init.lua` module that intercepts boot. It sends a broadcast packet for discovery,
then opens a telnet server on port 2323 for 25 seconds. Then, it proceeds with normal boot. It boots
to `main.lua`.

The utility program, `mcutool`, provides a simple client program for interacting with this firmware.
It can also bootstrap fresh ESP devices over serial.

# Using

## Quickstart

```
mcutool wifi --port /dev/tty.usbserial SSID PASSWORD
mcutool bootstrap --port /dev/tty.usbserial
mcutool watch
# Reboot your ESP now, watch for IP
mcutool send --ip <IP> lua/blink.lua main.lua #yay blinking lights
```


## Modes
### wifi
A simple convenience method - set the SSID and password over serial. Fortunately
these settings are persistent across reboots

### bootstrap
Send the `init.lua` file up via serial. **This formats all files on the chip!**

### send
Upload a file to a system. If no target is specified, it will upload to the next
ESP that boots. If given a chip ID, it will wait for that unit to broadcast. If
given an IP, it will connect directly.

### watch
Print the IP and Chip IDs of every ESP that boots.
