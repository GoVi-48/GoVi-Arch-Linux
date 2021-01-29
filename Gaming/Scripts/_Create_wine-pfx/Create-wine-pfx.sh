#!/bin/bash

FONTS="corefonts"
VCRUN="vcrun2019"
LIBRARIES="d3dx9"
WIN_VER="win10"

# Directories
DIR="$(dirname "$(realpath "$0")")"

while true; do

    if [ -d "${DIR}/wine-pfx" ]; then
        echo -e "\nThere is already a wine-pfx folder"
        echo -e "\nDo you want to make a new wine-prefix or overwrite this one?"
        echo -e '\nPress "n" to New "o" to Overwrite or "e" to Exit'
        read -rsn1 INPUT

        if [ $INPUT = "n" ] || [ $INPUT = "N" ]; then
            rm -rfv "${DIR}/wine-pfx"
            break

        elif [ $INPUT = "o" ] || [ $INPUT = "O" ]; then
            break

        elif [ $INPUT = "e" ] || [ $INPUT = "E" ]; then
            echo -e "\nExiting..."
            sleep 4
            exit

        else
            echo -e "\n Invalid Key\n"
        fi

    else
        break
    fi
done

[ ! -d "${DIR}/wine-build" ] && mkdir -p "${DIR}/wine-build"

while true; do

    if [ ! -f "${DIR}/wine" ]; then
        WINE=$(find -L "${DIR}/wine-build" -type f -iname "wine") 2>/dev/null
        ln -sf "$WINE" "${DIR}/wine" >/dev/null 2>&1
        echo -e "\nFolder wine-build is empty or have more than 1 wine version... "
        read -rsn1 -p "$(echo -e "\nCopy folder of wine inside or create a symlink to it and press any key to Continue...")"
        echo ""

    else
        WINE=$(find -L "${DIR}/wine-build" -type f -iname "wine") 2>/dev/null
        ln -sf "$WINE" "${DIR}/wine" >/dev/null 2>&1
        export WINE="$WINE"
        break
    fi
done

# Create WINEPREFIX
clear
echo -e "\nCreating Wine Prefix, please wait...\n"

export WINEPREFIX="${DIR}/wine-pfx"
"$WINE" winecfg >/dev/null 2>&1 &

while ! pgrep -x "winecfg.exe" >/dev/null; do sleep 1; done
sleep 2 && killall winecfg.exe
while [ ! -f "${DIR}/wine-pfx/user.reg" ] >/dev/null; do sleep 1; done

# Functions
MF() {
    while true; do
        sleep 2
        echo -e '\n-Do you want to install "Media Files"? [y/n]'
        read -rsn1 INPUT

        if [[ $INPUT == "y" ]] || [[ $INPUT == "Y" ]]; then
            echo ""
            ./MF/mf-install.sh
            break

        elif [[ $INPUT == "n" ]] || [[ $INPUT == "N" ]]; then
            echo -e '\n "Media Files" will not be installed\n'
            break

        else
            echo -e "\n Invalid Key\n"
        fi
    done
}

DXVK() {
    while true; do
        echo -e '\n-Do you want to install "DXVK"? [y/n]'
        read -rsn1 INPUT

        if [[ $INPUT == "y" ]] || [[ $INPUT == "Y" ]]; then
            echo ""
            ./DXVK-1.7.3/setup_dxvk.sh install
            break

        elif [[ $INPUT == "n" ]] || [[ $INPUT == "N" ]]; then
            echo -e '\n "DXVK" will not be installed\n'
            break

        else
            echo -e "\n Invalid Key\n"
        fi
    done
}

EXTRA_LIBRARIES() {
    while true; do
        echo -e '\n-Do you want to install "Extra dll libraries"? [y/n]'
        read -rsn1 INPUT

        if [[ $INPUT == "y" ]] || [[ $INPUT == "Y" ]]; then
            echo ""
            winetricks $LIBRARIES
            break

        elif [[ $INPUT == "n" ]] || [[ $INPUT == "N" ]]; then
            echo -e '\n "Extra dll libraries" will not be installed\n'
            break

        else
            echo -e "\n Invalid Key\n"
        fi
    done
}

# Install
cd "${DIR}/wine-pfx/drive_c/windows/Fonts" && for i in /usr/share/fonts/**/*.{ttf,otf}; do ln -sf "$i"; done >/dev/null 2>&1
cd "${DIR}/Setups/"

chmod +x "./winetricks"
winetricks $FONTS
winetricks $VCRUN

[ ! -d "${DIR}/wine-pfx/drive_c/Program Files (x86)/Microsoft XNA" ] &&
    "$WINE" msiexec /i "./xnafx40_redist.msi" >/dev/null 2>&1

[ ! -d "${DIR}/wine-pfx/drive_c/Program Files (x86)/OpenAL" ] &&
    "$WINE" "./oalinst.exe" >/dev/null 2>&1

MF
DXVK
EXTRA_LIBRARIES

#winetricks donet48
#winetricks winegstreamer=disabled
#winetricks nvapi=disabled nvapi64=disabled
#winetricks nocrashdialog d3dcompiler_43 d3dcompiler_47 d3dx9
#winetricks d3d10=disabled d3d10_1=disabled d3d10core=disabled d3d11=disabled
#winetricks d3d11=native dxgi=native
winetricks $WIN_VER

echo -e "\n ALL DONE" &
read -rsn1 -p "$(echo -e "\nPress any key to open wine prefix config...\n")"
"$WINE" winecfg
exit
