#!/usr/bin/env bash

killall polybar
qdbus org.kde.KWin /Compositor suspend

export WINEPREFIX=~/Wine/wine-pfx_5.18/wine-pfx_dxvk-1.7.1-mf
export WINE=~/Wine/wine-build_5.18-tkg/bin/wine64

cd "$HOME/Games/-Library-/PC/Star Wars Jedi Fallen Order/SwGame/Binaries/Win64/"
gamemoderun $WINE "starwarsjedifallenorder.exe"

sleep 5

while pgrep -x "starwarsjedifallenorder.exe" > /dev/null; do sleep 1; done
    qdbus org.kde.KWin /Compositor resume
    killall lutris
    killall gamemoded
    ~/Scripts/Bash/Polybar
