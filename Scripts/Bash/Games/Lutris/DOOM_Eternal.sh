#!/usr/bin/env bash

game_executable="DOOMEternalx64vk.exe"

export WINEFSYNC=1
export WINEDLLOVERRIDES="mscoree,mshtml="
export MANGOHUD=1
export ENABLE_VKBASALT=1

gamemoderun lutris lutris:rungameid/7 &

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
    

##### Lutris Environment Variables ##### 
# RADV_PERFTEST llvm
# PROTON_NO_ESYNC 1
# +in_terminal 1
# +com_skipIntroVideo 1
# +com_skipKeyPressOnLoadScreens 1
# +com_skipSignInManager 1
