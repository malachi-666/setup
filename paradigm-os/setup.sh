#!/usr/bin/env bash
set -e

echo "Starting Post-Boot Setup for Paradigm OS (Chimeric)..."

# Ensure we are in the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$DIR"

# 0. Git tracking for Nix flakes
echo "Checking Git tracking for Nix flakes..."
if ! command -v git &> /dev/null; then
    echo "git not found. Using nix run to initialize tracking..."
    nix run nixpkgs#git -- init
    nix run nixpkgs#git -- add .
    nix run nixpkgs#git -- commit -m "chore: initial flake commit for tracking" || true
else
    if [ ! -d ".git" ]; then
        git init
    fi
    git add .
    git commit -m "chore: initial flake commit for tracking" || true
fi

# 1. Setup Python Environment via `uv`
echo "Initializing Python environment using uv..."
mkdir -p ~/.local/python-envs
cd ~/.local/python-envs
if ! command -v uv &> /dev/null; then
    echo "uv command not found. Using nix run..."
    nix run nixpkgs#uv -- venv default-env
else
    uv venv default-env
fi
echo "Python environment created. Activate with: source ~/.local/python-envs/default-env/bin/activate"

# Return to script directory
cd "$DIR"

# 2. Setup LazyVim (Neovim)
echo "Setting up LazyVim..."
if [ ! -d "$HOME/.config/nvim" ]; then
  if ! command -v git &> /dev/null; then
      nix run nixpkgs#git -- clone https://github.com/LazyVim/starter ~/.config/nvim
  else
      git clone https://github.com/LazyVim/starter ~/.config/nvim
  fi
  rm -rf ~/.config/nvim/.git
else
  echo "Neovim config already exists."
fi

# 3. Setup Doom Emacs
echo "Setting up Doom Emacs..."
if [ ! -d "$HOME/.config/emacs" ]; then
  if ! command -v git &> /dev/null; then
      nix run nixpkgs#git -- clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
  else
      git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
  fi
  ~/.config/emacs/bin/doom install --no-env --no-fonts || echo "Please run doom install manually if this fails due to missing dependencies"
else
  echo "Doom Emacs config already exists."
fi

# 4. Setup Navi Cheatsheets
echo "Setting up Navi cheatsheets..."
if ! command -v navi &> /dev/null; then
    echo "navi command not found. Using nix run..."
    nix run nixpkgs#navi -- repo add denisidoro/cheats || true
else
    navi repo add denisidoro/cheats || true
fi

echo "Setup Complete!"
