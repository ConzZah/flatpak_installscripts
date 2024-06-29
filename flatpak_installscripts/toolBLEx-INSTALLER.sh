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
$_doso flatpak install -y flathub io.emeric.toolblex
cd /home/$USER/Desktop
echo ""; echo "CREATING DESKTOP SHORTCUT..."
wget -q -O toolBLEx-icon.png https://dl.flathub.org/media/io/emeric/toolblex/7841b31d58f23c84e8421004f6cc6ca1/icons/128x128/io.emeric.toolblex.png
$_doso mv toolBLEx-icon.png /etc/
_sc="toolBLEx.desktop"
cd /home/$USER/Desktop
echo "[Desktop Entry]">$_sc
echo "Version=1.0">>$_sc
echo "Type=Application">>$_sc
echo "Name=toolBLEx">>$_sc
echo "Comment=toolBLEx">>$_sc
echo "Exec=flatpak run io.emeric.toolblex">>$_sc
echo "Icon=/etc/toolBLEx-icon.png">>$_sc
echo "Path=">>$_sc
echo "Terminal=false">>$_sc
echo "StartupNotify=false">>$_sc
echo "CREATING ALIAS FOR toolBLEx"
[ ! -f ~/.bashrc ] && touch ~/.bashrc
_bash_aliases="[ -f ~/.bash_aliases ] && . ~/.bash_aliases"
autoload_=$(cat ~/.bashrc|grep "$_bash_aliases")
aliascheck_=$(cat ~/.bash_aliases|grep -o -m 1 toolBLEx|head -1)
[ -z "$autoload_" ] && echo "$_bash_aliases" >> ~/.bashrc
[ -z "$aliascheck_" ] && echo "alias toolBLEx='flatpak run io.emeric.toolblex'" >> ~/.bash_aliases 
echo "DONE."
}
_init
