#!/usr/bin/env bash

STATUS=$(systemctl is-active "$@" | xargs)

case "$STATUS" in
    active)
        echo "󰄬"
        exit 0
        ;;
    inactive)
        echo "󰓛"
        exit 0
        ;;
    failed)
        echo "󰅚"
        exit 0
        ;;
    *)
        echo "󰋗"
        exit 0
        ;;
esac
