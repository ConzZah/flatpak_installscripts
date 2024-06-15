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
$_doso flatpak install -y flathub org.kde.isoimagewriter
cd /home/$USER/Desktop
echo ""; echo "CREATING DESKTOP SHORTCUT..."
wget -q -O ISO-Image-Writer-icon.png https://dl.flathub.org/media/org/kde/isoimagewriter.desktop/c3fe0740324a69bbbdaa7cd7c8257ee3/icons/128x128/org.kde.isoimagewriter.desktop.png
$_doso mv ISO-Image-Writer-icon.png /etc/
_sc="ISO-Image-Writer.desktop"
cd /home/$USER/Desktop
echo "[Desktop Entry]">$_sc
echo "Version=1.0">>$_sc
echo "Type=Application">>$_sc
echo "Name=ISO-Image-Writer">>$_sc
echo "Comment=ISO-Image-Writer">>$_sc
echo "Exec=flatpak run org.kde.isoimagewriter">>$_sc
echo "Icon=/etc/ISO-Image-Writer-icon.png">>$_sc
echo "Path=">>$_sc
echo "Terminal=false">>$_sc
echo "StartupNotify=false">>$_sc
echo "DONE."
}
_init