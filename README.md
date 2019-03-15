# Dotfiles Management

The recommended way of syncing these dotfiles is using [GNU-stow](https://www.gnu.org/software/stow/). For Debian-like distributions, you would thus sync with your home directory as follows:
```bash
sudo apt install stow
stow vim zsh ssh …
```
