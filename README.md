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
