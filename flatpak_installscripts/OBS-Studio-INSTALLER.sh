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
_portal="xdg-desktop-portal"
_DE=$(echo $XDG_CURRENT_DESKTOP|grep -o -e XFCE -e LXDE -e LXQT -e GNOME -e KDE)
if [[ "$_DE" == "XFCE" || "LXDE" ]]; then $_doso $add $_portal-gtk; fi
if [[ "$_DE" == "GNOME" ]]; then $_doso $add $_portal-gnome; fi
if [[ "$_DE" == "LXQT" ]]; then $_doso $add $_portal-lxqt; fi
if [[ "$_DE" == "KDE" ]]; then $_doso $add $_portal-kde; fi
$_doso $add $y flatpak && $_doso flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
$_doso flatpak install -y flathub com.obsproject.Studio
cd /home/$USER/Desktop
echo ""; echo "CREATING DESKTOP SHORTCUT..."
wget -q -O "OBS-Studio_icon.png" https://dl.flathub.org/media/com/obsproject/Studio/5d31c7d48c6848658c98c5bfb645a016/icons/128x128/com.obsproject.Studio.png
$_doso mv "OBS-Studio_icon.png" /etc/
_sc="OBS-Studio.desktop"
cd /home/$USER/Desktop
echo "[Desktop Entry]">$_sc
echo "Version=1.0">>$_sc
echo "Type=Application">>$_sc
echo "Name=OBS Studio">>$_sc
echo "Comment=OBS Studio">>$_sc
echo "Exec=flatpak run com.obsproject.Studio">>$_sc
echo "Icon=/etc/OBS-Studio_icon.png">>$_sc
echo "Path=">>$_sc
echo "Terminal=false">>$_sc
echo "StartupNotify=false">>$_sc
echo "CREATING ALIAS FOR OBS-Studio"
echo "alias OBS-Studio='flatpak run com.obsproject.Studio'" >> ~/.bash_aliases
echo "DONE."
}
_init
