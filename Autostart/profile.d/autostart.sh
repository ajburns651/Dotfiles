#!/bin/sh
xrandr --output HDMI-0 --mode 3840x2160 --rate 60 --left-of eDP-1-1
xrandr --output eDP-1-1 --mode 1920x1080 --rate 144 --right-of HDMI-0
pactl unload-module 6
# pactl unload-module 8
pactl set-default-source 0
xsetroot -cursor_name left_ptr
timedatectl set-ntp true
