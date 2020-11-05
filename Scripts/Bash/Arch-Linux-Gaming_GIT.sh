#!/usr/bin/env bash

Arch_Linux_Gaming="$HOME/Proyectos/Github/Arch-Linux-Gaming"

cp -rfv ~/.bashrc "$Arch_Linux_Gaming"
cp -rfv /etc/pacman.conf "$Arch_Linux_Gaming"
cp -rfv ~/.config/MangoHud/MangoHud.conf "$Arch_Linux_Gaming"
cp -rfv ~/.config/vkBasalt/* "$Arch_Linux_Gaming"

cd "$Arch_Linux_Gaming"
git add .
git commit -m "Updated"
git push -u origin master

kdialog --icon "$HOME/.local/share/icons/GoVi-Ic/emblems/22/emblem-information.svg" --passivepopup "Complete" 8 && paplay $HOME/.local/share/sounds/cause-and-effect.ogg

while true; do
    echo -en "Press Enter to continue"
    echo .
    read -rsn1 input
        if [[ $input = "" ]];then
            echo "Opening Github"
            firefox https://github.com/GoVi-48/Arch-Linux-Gaming
            exit
        else 
            echo "Invalid Key."
        fi
done
