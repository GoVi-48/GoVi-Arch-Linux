 #!/usr/bin/env bash

export WINEPREFIX=~/Wine/wine-pfx_5.16/wine-pfx_5.16-mf
export WINE=~/Wine/wine-build_5.16-tkg/usr/bin/wine64
 
cd $HOME"/Games/Epic Games/Launcher/Engine/Binaries/Win64"
gamemoderun $WINE "EpicGamesLauncher.exe"
