#!/usr/bin/env bash
 
killall polybar

qdbus org.kde.KWin /Compositor suspend

cd $HOME"/Games/-Library-/PC/Green Hell"

gamemoderun WINEPREFIX=~/Wine/wine-pfx_5.14/wine-pfx_5.14-dxvk-1.7.1-mf ~/Wine/wine-build_5.14-tkg/bin/wine64 "GH.exe"

sleep 5

while pgrep -x "GH.exe" > /dev/null; do sleep 1; done

qdbus org.kde.KWin /Compositor resume

killall lutris
killall gamemoded

~/Scripts/Bash/Polybar
