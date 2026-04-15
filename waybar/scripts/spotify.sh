#!/bin/sh

status=$(playerctl --player=spotify status 2>/dev/null)

if [[ "$status" == "Playing" ]]; then
    artist=$(playerctl --player=spotify metadata artist)
    title=$(playerctl --player=spotify metadata title)
    echo "{\"text\": \"$artist - $title\", \"alt\": \"play\"}"
elif [ "$status" = "Paused" ]; then
    artist=$(playerctl --player=spotify metadata artist)
    title=$(playerctl --player=spotify metadata title)
    echo "{\"text\": \"$artist - $title\", \"alt\": \"pause\"}"
else
    echo '{"text": ""}'
fi
