# Paradigm OS: Methodology & Integration Guide

Paradigm OS is a custom, bare-metal NixOS Unstable distribution engineered to optimize hardware potential (specifically for an Intel Core i7-7800X, 138GB RAM, and an AMD Radeon RX 480). This document outlines the rationale, principles, and integration of various state-of-the-art tools and philosophies drawn from the open-source community.

## 1. System Foundation & Nix Philosophy
**Inspired by:** [awesome-nix](https://github.com/nix-community/awesome-nix)

*   **Declarative Infrastructure:** The entire system state is defined in `flake.nix` and supporting modules, ensuring absolute reproducibility.
*   **Module Categorization:** Functional domains (AI, Memory Optimization, Pentesting, Desktop) are strictly segregated into independent Nix modules for clarity and maintainability.
*   **Unstable Channel:** Utilizing `nixos-unstable` provides the most up-to-date packages required for rapid AI and pentesting developments.

## 2. Resource Management & Hardware Optimization
*   **Memory (138GB RAM):** Aggressive tuning in `memory-opts.nix` minimizes swapping (`vm.swappiness = 1`) and leverages `tmpfs` mounts for `/tmp` and Nix build directories. Hugepages (`16384 * 2MB = 32GB`) are explicitly pre-allocated to support rapid Large Language Model (LLM) context caching.
*   **GPU Utilization (AMD Radeon RX 480):** AI services like `llama.cpp` and `Ollama` are compiled with the `-DGGML_VULKAN=1` flag. This bypasses typical CPU bottlenecks and forces compute through the Vulkan API for optimized performance.

## 3. The Hacker's Workflow
**Inspired by:** [The Book of Secret Knowledge](https://github.com/trimstray/the-book-of-secret-knowledge) & [Navi](https://github.com/denisidoro/navi)

*   **Interactive Command Recall:** `navi` is pre-configured and seeded via `setup.sh` to provide an interactive, fzf-powered cheatsheet system. This eliminates the friction of memorizing complex pentesting or Nix command syntax.
*   **Pentesting Module:** Tools like `fabric`, `jq`, `puppeteer-cli`, `nmap`, and `wireshark` are clustered to facilitate immediate OSINT gathering and security auditing without polluting the global environment.

## 4. The Editor & Environment Philosophy
**Inspired by:** [vim-galore](https://github.com/mhinz/vim-galore) & [build-your-own-x](https://github.com/codecrafters-io/build-your-own-x)

*   **Zero Global Python:** Global Python package pollution is strictly forbidden. All Python development and scripting environments are managed via `uv`, initialized per-project or via the `setup.sh` post-boot script.
*   **Keyboard-Centric Interface:** The desktop module implements `Qtile` (TWM), `Kitty` (terminal), `Nushell` (data-aware shell), and `Qutebrowser` (Vim-like browsing) to maximize efficiency and minimize mouse interaction.
*   **Dual Editor Support:** Both `LazyVim` (Neovim) and `Doom Emacs` are bootstrapped in user-space, adhering to the "Vim-galore" ethos of extensible, modal text editing.

## 5. Deployment and Beyond
**Inspired by:** [free-for-dev](https://github.com/ripienaar/free-for-dev)

The configuration serves as a robust local foundation for development and reverse engineering, preparing artifacts that can be seamlessly deployed leveraging modern, cost-effective PaaS/SaaS solutions identified in the free-for-dev compilation.
