#!/usr/bin/env bash

games_location="/home/$USER/Games/PC/"
game_folder="Star Wars Jedi Fallen Order/SwGame/Binaries/Win64/"
game_executable="starwarsjedifallenorder.exe"

export WINEPREFIX="/home/$USER/Wine/wine_6.0-RC4/wine-pfx_mf-dxvk-1.7.3"
export WINE="/home/$USER/Wine/wine_6.0-RC4/wine-build_tkg/usr/bin/wine64"

export MESA_EXTENSION_MAX_YEAR=2003
export WINEDLLOVERRIDES="mscoree,mshtml="
export WINEFSYNC=1
export MANGOHUD=1
export ENABLE_VKBASALT=1


cd "$games_location""$game_folder"
gamemoderun $WINE $game_executable &


while ! pgrep -x $game_executable > /dev/null; do sleep 1; done
    sleep 5
    killall lutris
    killall polybar
    killall cairo-dock
    qdbus org.kde.KWin /Compositor suspend

while pgrep -x $game_executable > /dev/null; do sleep 1; done
    qdbus org.kde.KWin /Compositor resume
    /home/$USER/Scripts/Bash/Polybar/launch.sh
    cairo-dock > /dev/null 2>&1 &
    sleep 1
    killall gamemoded
