#!/usr/bin/env bash
set -e

echo "========================================================="
echo "  PARADIGM-OS: ZERO-TRUNCATION DEPLOYMENT BOOTSTRAPPER   "
echo "========================================================="

# Ensure we are in the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$DIR"

# 1. BULLETPROOF DEPENDENCY RESOLUTION
echo "[*] Verifying critical bootstrap dependencies..."
DEPS=""
if ! command -v git &> /dev/null; then DEPS="$DEPS git"; fi
if ! command -v uv &> /dev/null; then DEPS="$DEPS uv"; fi
if ! command -v navi &> /dev/null; then DEPS="$DEPS navi"; fi

if [ -n "$DEPS" ]; then
    echo "[!] Missing dependencies detected: $DEPS"
    echo "[*] Relaunching setup via nix-shell..."
    exec nix-shell -p $DEPS --run "bash $0"
fi

# 2. GIT TRACKING FOR FLAKE EVALUATION (PRE-REBUILD)
echo "[*] Ensuring Git tracking for Nix Flake evaluation..."
if [ ! -d ".git" ]; then
    git init
    git branch -m main || true
fi

# We must add everything so Nix can see the files during `nixos-rebuild`
git add .
# Commit if there are changes (will fail gracefully if clean, which is fine)
git commit -m "chore: paradigm-os bootstrap commit" || echo "[*] Working tree clean."

# 3. PYTHON ENVIRONMENT CONTAINMENT (ZERO GLOBAL PYTHON)
echo "[*] Initializing isolated Python environment via uv..."
mkdir -p ~/.local/python-envs
cd ~/.local/python-envs

if [ ! -d "default-env" ]; then
    uv venv default-env
    echo "[+] Created default-env."
else
    echo "[*] default-env already exists."
fi
echo ">>> Activate with: source ~/.local/python-envs/default-env/bin/activate"

cd "$DIR"

# 4. EDITOR BOOTSTRAPPING (LazyVim & Doom Emacs)
echo "[*] Bootstrapping Editors..."

if [ ! -d "$HOME/.config/nvim" ]; then
  echo "[+] Cloning LazyVim..."
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
else
  echo "[*] Neovim config already exists."
fi

if [ ! -d "$HOME/.config/emacs" ]; then
  echo "[+] Cloning Doom Emacs..."
  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
  echo "[!] Run '~/.config/emacs/bin/doom install' manually if you wish to finalize Doom."
else
  echo "[*] Doom Emacs config already exists."
fi

# 5. NAVI CHEATSHEET SEEDING
echo "[*] Seeding Navi cheatsheets..."
navi repo add denisidoro/cheats || echo "[*] Navi cheats already seeded."

echo "========================================================="
echo "  BOOTSTRAP COMPLETE. READY FOR nixos-rebuild switch.    "
echo "========================================================="
