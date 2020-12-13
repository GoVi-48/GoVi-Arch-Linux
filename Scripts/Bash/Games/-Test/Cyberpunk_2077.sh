#!/usr/bin/env bash

game_executable="Cyberpunk2077.exe"
game_location="/home/$USER/Games/PC/Cyberpunk 2077/bin/x64/"

export WINEPREFIX="/home/$USER/Wine/wine_5.22/wine-pfx_mf-dxvk-1.7.3"
export WINE="/home/$USER/Wine/wine_Lutris/wine-build_5.7.10/bin/wine64"

PULSE_LATENCY_MSEC=60
export WINEFSYNC=1
export WINEDLLOVERRIDES="mscoree,mshtml="
export MANGOHUD=1
export ENABLE_VKBASALT=1

cd "$game_location"
gamemoderun $WINE $game_executable

while ! pgrep -x $game_executable > /dev/null; do sleep 1; done

if pgrep -x $game_executable; then
    qdbus org.kde.KWin /Compositor suspend
    killall latte-dock
    killall polybar
fi

while pgrep -x $game_executable > /dev/null; do sleep 1; done
    
if ! pgrep -x $game_executable; then
    qdbus org.kde.KWin /Compositor resume
    /home/$USER/Scripts/Bash/Polybar 
    /home/$USER/Scripts/Bash/Latte_Dock.sh &
    killall lutris
    sleep 1
    killall gamemoded
fi 
