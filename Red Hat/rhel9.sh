#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

sudo dnf upgrade 
sudo dnf config-manager --set-enabled crb
sudo dnf install \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm \
	https://download1.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm \
	https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm
	
# sudo rpm -Uvh http://mirror.ppa.trinitydesktop.org/trinity/rpm/el9/trinity-r14/RPMS/noarch/trinity-repo-14.0.13-1.el9.noarch.rpm
	
sudo dnf install vim xdg-user-dirs git sddm thunar firefox cmake g++ wget pavucontrol meson bison bison-devel startup-notification startup-notification-devel \
flexiblas-devel libX11-common gdk-pixbuf2-devel boost boost-devel pip pango-devel tar xclip clang xcb-proto python-sphinx xcb-util-cursor \
xcb-util-xrm cairo-devel libuv-devel xcb-util-* libev libev-devel uthash-devel libconfig libconfig-devel mesa-libGL-devel dbus-devel libnotify-devel \
xfce-polkit xfce4-power-manager libXtst-devel imlib2-devel pulseaudio-libs-devel ImageMagick ffmpeg gstreamer1-libav cabal-install libXrandr-devel \
libXScrnSaver-devel libXScrnSaver xorg-x11-xinit-session libogg-devel libxkbcommon-x11-devel libjpeg-turbo-devel pam-devel libXinerama-devel \
libcurl-devel libXt-devel xorg-x11-utils glew glew-devel glm-devel gtk2-devel exiv2-devel xorg-x11-util-macros xorg-x11-xbitmaps libXmu-devel \
mesa-libEGL-devel flex check-devel check alsa-lib-devel jsoncpp-devel libnl3-devel

mkdir -p ~/.config/xmonad && cd ~/.config/xmonad
curl -sSL https://get.haskellstack.org/ | sh


git clone --branch v0.17.0 https://github.com/xmonad/xmonad
git clone --branch v0.17.0 https://github.com/xmonad/xmonad-contrib
git clone https://github.com/LeifW/xmonad-utils.git

cabal update
cabal install --package-env=$HOME/.config/xmonad --lib xmonad xmonad-contrib
cabal install --package-env=$HOME/.config/xmonad xmonad
cabal install --package-env=$HOME/.config/xmonad xmonad-utils

# MPD install
pip install sphinx_rtd_theme
git clone https://github.com/MusicPlayerDaemon/MPD.git
cd MPD
meson . output/release --buildtype=debugoptimized -Db_ndebug=true
meson configure output/release
meson configure output/release -Dsysconfdir='/etc' ; meson configure output/release |grep syscon
ninja -C output/release
sudo ninja -C output/release install
cd ..

# libmpdclient
git clone https://github.com/MusicPlayerDaemon/libmpdclient.git
cd libmpdclient
meson . output
ninja -C output
sudo ninja -C output install
cd ..

# Install mpc
git clone https://github.com/MusicPlayerDaemon/mpc.git
cd mpc
meson . output
ninja -C output
sudo ninja -C output install
cd ..


# installing wireless-tools
git clone https://github.com/HewlettPackard/wireless-tools.git
cd wireless_tools/wireless_tools
make
sudo make install
# *** Don't forget to add /usr/local/lib/ to /etc/ld.so.conf, and run ldconfig as root. ***
sudo ldconfig
cd ../..

# Install i3lock-color
git clone https://github.com/Raymo111/i3lock-color
cd i3lock-color
sudo ./install-i3lock-color.sh
cd ..

# install feh
git clone https://git.finalrewind.org/feh
cd feh
make
sudo make install app=1
cd ..

# Install dunst (uten wayland pakker)
git clone https://github.com/dunst-project/dunst.git
cd dunst
make WAYLAND=0
sudo make install WAYLAND=0
cd ..

# install betterlockscreen
# Se https://github.com/betterlockscreen/betterlockscreen for mer info
wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system

# install slop
git clone https://github.com/naelstrof/slop.git
cd slop
cmake -DCMAKE_INSTALL_PREFIX="/usr" ./
make && sudo make install
cd ..

# Installing veiwnior 
wget https://github.com/hellosiyan/Viewnior/archive/viewnior-1.8.tar.gz
tar zxvf viewnior-1.8.tar.gz
cd Viewnior-viewnior-1.8
meson --prefix=/usr builddir
cd ./builddir
ninja
sudo ninja install
cd ../..

# Installing ksuperkey
git clone https://github.com/hanschen/ksuperkey.git
cd ksuperkey
make
sudo make install
cd ..

# installing hsetroot
git clone https://github.com/himdel/hsetroot.git
cd hsetroot
make
sudo make install
cd ..

# Install xorg-xsetroot
git clone https://gitlab.freedesktop.org/xorg/app/xsetroot.git
cd xsetroot
./autogen.sh
sudo make install
cd ..

# Installing nerd fonts
git clone https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh
cd ..

# Installing Rofi
git clone --recursive https://github.com/DaveDavenport/rofi
cd rofi/
autoreconf -i
mkdir build && cd build
../configure
make
sudo make install
cd ../..


# Installing picom
git clone https://github.com/yshui/picom.git
cd picom/
git submodule update --init --recursive
meson setup --buildtype=release . build
ninja -C build
sudo ninja -C build install
cd ..

# Install polybar
git clone --recursive https://github.com/polybar/polybar
cd polybar/
mkdir build && cd build
cmake ..
make -j$(nproc)
sudo make install
cd ../..

git clone https://github.com/archcraft-os/archcraft-xmonad.git

xdg-user-dirs-update
sudo chmod +x /etc/rc.d/rc.local
sudo systemctl enable sddm

curl https://sh.rustup.rs -sSf | sh
cargo install alacritty
 

# https://github.com/LeifW/xmonad-utils.git


# Finner ikke disse firvillige avhengighetene for polybar: xcb-xkb
