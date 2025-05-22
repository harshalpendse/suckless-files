#!/bin/bash

set -e

echo "[1/7] Updating system..."
sudo pacman -Syu --noconfirm

echo "[2/7] Installing essentials..."
sudo pacman -S --noconfirm git base-devel xorg xorg-xinit xterm

echo "[3/7] Installing DWM dependencies..."
sudo pacman -S --noconfirm libx11 libxft libxinerama

echo "[4/7] Installing additional tools: picom, pywal..."
sudo pacman -S --noconfirm picom python-pywal feh

echo "[5/7] Cloning suckless tools into ~/suckless..."
mkdir -p ~/suckless
cd ~/suckless

for repo in dwm st dmenu; do
  if [ ! -d "$repo" ]; then
    git clone https://git.suckless.org/$repo
  else
    echo "$repo already exists, skipping..."
  fi
done

echo "[6/7] Building suckless tools..."
for dir in dwm st dmenu; do
  cd ~/suckless/$dir
  sudo make clean install
done

echo "[7/7] Setting up .xinitrc to start dwm..."
cat <<EOF > ~/.xinitrc
#!/bin/sh
wal -i ~/Pictures/wallpapers/default.jpg &  # Update this path to your wallpaper
picom --config ~/.config/picom/picom.conf & # Optional: set config path
exec dwm
EOF

chmod +x ~/.xinitrc

echo "✅ DWM environment setup complete. Run 'startx' to launch dwm."

