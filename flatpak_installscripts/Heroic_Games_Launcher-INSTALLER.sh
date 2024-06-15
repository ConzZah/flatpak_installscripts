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
$_doso flatpak install -y flathub com.heroicgameslauncher.hgl
cd /home/$USER/Desktop
echo ""; echo "CREATING DESKTOP SHORTCUT..."
wget -q -O Heroic_Games_Launcher-icon.png https://dl.flathub.org/media/com/heroicgameslauncher/hgl/56dc96fff207a331a6f12270efb30fae/icons/128x128/com.heroicgameslauncher.hgl.png
$_doso mv Heroic_Games_Launcher-icon.png /etc/
_sc="Heroic_Games_Launcher.desktop"
cd /home/$USER/Desktop
echo "[Desktop Entry]">$_sc
echo "Version=1.0">>$_sc
echo "Type=Application">>$_sc
echo "Name=Heroic Games Launcher">>$_sc
echo "Comment=Heroic Games Launcher">>$_sc
echo "Exec=flatpak run com.heroicgameslauncher.hgl">>$_sc
echo "Icon=/etc/Heroic_Games_Launcher-icon.png">>$_sc
echo "Path=">>$_sc
echo "Terminal=false">>$_sc
echo "StartupNotify=false">>$_sc
echo "DONE."
}
_init