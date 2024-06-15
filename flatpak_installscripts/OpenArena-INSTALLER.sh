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
$_doso flatpak install -y flathub io.github.ec_.Quake3e.OpenArena
cd /home/$USER/Desktop
echo ""; echo "CREATING DESKTOP SHORTCUT..."
wget -q -O OpenArena-icon.png https://dl.flathub.org/media/io/github/ec_.Quake3e.OpenArena/b8c383c49610357fcf7394a809128f74/icons/128x128/io.github.ec_.Quake3e.OpenArena.png
$_doso mv OpenArena-icon.png /etc/
_sc="OpenArena.desktop"
cd /home/$USER/Desktop
echo "[Desktop Entry]">$_sc
echo "Version=1.0">>$_sc
echo "Type=Application">>$_sc
echo "Name=OpenArena">>$_sc
echo "Comment=OpenArena">>$_sc
echo "Exec=flatpak run io.github.ec_.Quake3e.OpenArena">>$_sc
echo "Icon=/etc/OpenArena-icon.png">>$_sc
echo "Path=">>$_sc
echo "Terminal=false">>$_sc
echo "StartupNotify=false">>$_sc
echo "DONE."
}
_init