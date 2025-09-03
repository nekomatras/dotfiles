#!/bin/bash

echo 1 | sudo tee /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy
echo 80 | sudo tee /sys/class/power_supply/BAT1/charge_control_end_threshold

ln -s .config/bash/.bash_profile .bash_profile
ln -s .config/bash/.bashrc .bashrc
sudo ../.config/custom-fonts/init-fonts.sh

ELECTRON_FLAGS="--enable-features=WaylandWindowDecorations --ozone-platform-hint=auto"
MARK_W="thisfileshouldpassthroughwaylandsupportargumentsaboba"
POSTFIX_W=".bakw"

pass_wayland_flags_to_electron_apps() {
  for arg in "$@"; do
    if ! grep --binary-files=without-match -q $MARK_W $arg; then
        sudo rm -f "$arg$POSTFIX_W"
        sudo cp "$arg" "$arg$POSTFIX_W"
	sudo rm -f "$arg"
	echo -e "#!/bin/bash\n$MARK_W\n$arg$POSTFIX_W $ELECTRON_FLAGS" | sudo tee "$arg"
	sudo chmod +x $arg
    fi
  done
}

restore_wayland_flags_to_electron_apps() {
  for arg in "$@"; do
    if [ -e "$arg$POSTFIX_W" ]; then
      sudo mv $arg$POSTFIX_W $arg
    fi
  done  
}

apps=( "/usr/bin/chromium" )

if [ "$XDG_SESSION_TYPE" = "wayland" ] || [ -n "$WAYLAND_DISPLAY" ]; then
  pass_wayland_flags_to_electron_apps "${apps[@]}"
else
  restore_wayland_flags_to_electron_apps "${apps[@]}"
fi
