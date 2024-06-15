#!/usr/bin/env bash
_doso="sudo"
is_alpine=$(uname -v|grep -o -w Alpine)
is_debian=$(uname -v|grep -o -w Debian)
add_alpine="apk add"
add_debian="apt install"
function _init {
if [[ "$is_alpine" == "Alpine" ]]; then _os=$is_alpine; add=$add_alpine; _doso="doas"; _install; fi
if [[ "$is_debian" == "Debian" ]]; then _os=$is_debian; add=$add_debian; y="-y"; _install; fi
if [[ "$_os" == "" ]]; then add=$add_debian; _install; fi
}
function _install {
$_doso $add $y flatpak && $_doso flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
$_doso flatpak install -y flathub io.github.fabiangreffrath.Doom
cd /home/$USER/Desktop
echo ""; echo "CREATING DESKTOP SHORTCUT..."
wget -q -O CrispyDoom-icon.png https://dl.flathub.org/repo/appstream/x86_64/icons/128x128/io.github.fabiangreffrath.Doom.png
$_doso mv CrispyDoom-icon.png /etc/
_sc="CrispyDoom.desktop"
cd /home/$USER/Desktop
echo "[Desktop Entry]">$_sc
echo "Version=1.0">>$_sc
echo "Type=Application">>$_sc
echo "Name=CrispyDoom">>$_sc
echo "Comment=CrispyDoom">>$_sc
echo "Exec=flatpak run io.github.fabiangreffrath.Doom">>$_sc
echo "Icon=/etc/CrispyDoom-icon.png">>$_sc
echo "Path=">>$_sc
echo "Terminal=false">>$_sc
echo "StartupNotify=false">>$_sc
echo "DONE."
}
_init