#!/bin/bash

echo 1 | sudo tee /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy
echo 80 | sudo tee /sys/class/power_supply/BAT1/charge_control_end_threshold

ln -s .config/bash/.bash_profile .bash_profile
ln -s .config/bash/.bashrc .bashrc
sudo ../.config/custom-fonts/init-fonts.sh
