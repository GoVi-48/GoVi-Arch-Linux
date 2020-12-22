#!/usr/bin/env bash

game_executable="re2.exe"

export WINEDLLOVERRIDES="mscoree,mshtml="
export WINEFSYNC=1
export MANGOHUD=1
export ENABLE_VKBASALT=1

gamemoderun steam steam://rungameid/10110539261779378176 & 


while ! pgrep -x $game_executable > /dev/null; do sleep 1; done

if pgrep -x $game_executable; then
    qdbus org.kde.KWin /Compositor suspend
    killall cairo-dock
    killall polybar
fi

while pgrep -x $game_executable > /dev/null; do sleep 1; done
    
if ! pgrep -x $game_executable; then
    qdbus org.kde.KWin /Compositor resume
    /home/$USER/Scripts/Bash/Polybar 
    cairo-dock > /dev/null 2>&1 &
    killall steam
    killall lutris
    sleep 1
    killall gamemoded
fi
