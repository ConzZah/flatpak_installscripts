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
$_doso flatpak install -y flathub com.gitlab.coringao.cavestory-nx
cd /home/$USER/Desktop
echo ""; echo "CREATING DESKTOP SHORTCUT..."
wget -q -O Cave_Story_NX-icon.png https://dl.flathub.org/repo/appstream/x86_64/icons/128x128/com.gitlab.coringao.cavestory-nx.png
$_doso mv Cave_Story_NX-icon.png /etc/
_sc="Cave_Story_NX.desktop"
cd /home/$USER/Desktop
echo "[Desktop Entry]">$_sc
echo "Version=1.0">>$_sc
echo "Type=Application">>$_sc
echo "Name=Cave Story NX">>$_sc
echo "Comment=Cave Story NX">>$_sc
echo "Exec=flatpak run com.gitlab.coringao.cavestory-nx">>$_sc
echo "Icon=/etc/Cave_Story_NX-icon.png">>$_sc
echo "Path=">>$_sc
echo "Terminal=false">>$_sc
echo "StartupNotify=false">>$_sc
echo "DONE."
}
_init
