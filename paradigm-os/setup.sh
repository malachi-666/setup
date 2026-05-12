#!/usr/bin/env bash
set -e

echo "Starting Post-Boot Setup for Paradigm OS..."

# 1. Setup Python Environment via `uv`
echo "Initializing Python environment using uv..."
mkdir -p ~/.local/python-envs
cd ~/.local/python-envs
uv venv default-env
echo "Python environment created. Activate with: source ~/.local/python-envs/default-env/bin/activate"

# 2. Setup LazyVim (Neovim)
echo "Setting up LazyVim..."
if [ ! -d "$HOME/.config/nvim" ]; then
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
else
  echo "Neovim config already exists."
fi

# 3. Setup Doom Emacs
echo "Setting up Doom Emacs..."
if [ ! -d "$HOME/.config/emacs" ]; then
  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
  ~/.config/emacs/bin/doom install --no-env --no-fonts
else
  echo "Doom Emacs config already exists."
fi

# 4. Setup Navi Cheatsheets
echo "Setting up Navi cheatsheets..."
navi repo add denisidoro/cheats

echo "Setup Complete!"
