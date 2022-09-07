# dotfiles
This repository is here for me to easily backup and restore my dotfiles across multiple systems.

# Setup as `$HOME`
When loading into a fresh new system, make sure `git` and `ssh` are installed and setup, then run the following commands:
```sh
cd ~
git init
git remote add origin git@github.com:HoloTheDrunk/dotfiles.git
git fetch
git checkout -f master
```

# Dependencies
```
Rust cargo:
  exa

AUR helper:
  yay

polybar
rofi
rust
xfce4-clipman
xfce4-screenshooter
```

# Quickstart
Save this in a script and run it
```bash
sudo pacman -Syyu polybar rofi
yay xfce4-screenshooter
yay xfce4-clipman
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install exa
```

# Where is stuff?
X keyboard options lists: /usr/share/X11/xkb/rules/*.lst
