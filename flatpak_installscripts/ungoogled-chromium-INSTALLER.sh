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
$_doso flatpak install -y flathub io.github.ungoogled_software.ungoogled_chromium
cd /home/$USER/Desktop
echo ""; echo "CREATING DESKTOP SHORTCUT..."
wget -q -O ungoogled-chromium-icon.png https://dl.flathub.org/media/io/github/ungoogled_software.ungoogled_chromium/d3cb7d99774196c0ce5c11bd78f8b9ba/icons/128x128/io.github.ungoogled_software.ungoogled_chromium.png
$_doso mv ungoogled-chromium-icon.png /etc/
_sc="ungoogled-chromium.desktop"
cd /home/$USER/Desktop
echo "[Desktop Entry]">$_sc
echo "Version=1.0">>$_sc
echo "Type=Application">>$_sc
echo "Name=ungoogled-chromium">>$_sc
echo "Comment=ungoogled-chromium">>$_sc
echo "Exec=flatpak run io.github.ungoogled_software.ungoogled_chromium">>$_sc
echo "Icon=/etc/ungoogled-chromium-icon.png">>$_sc
echo "Path=">>$_sc
echo "Terminal=false">>$_sc
echo "StartupNotify=false">>$_sc
echo "DONE."
}
_init
