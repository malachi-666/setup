# NixOS Sovereign Command Center

This repository contains the declarative flake and module configurations for a highly optimized, OPSEC-hardened NixOS Sovereign Command Center. It is designed to run on bare-metal hardware with extensive optimizations for local AI orchestration, heavy context caching, and automated OSINT data pipelines.

## System Architecture Target

*   **CPU:** Intel Core i7-7800X (6 Cores / 12 Threads)
*   **RAM:** 138GB DDR4 (Aggressively optimized via near-zero swappiness, hugepages, and tmpfs mounts)
*   **GPU:** AMD Radeon RX 480 8GB (Vulkan Compute Pipeline enforced for AI)
*   **Hypervisor:** VMware Workstation Pro (configured as a bare-metal host)
*   **Containerization:** Podman (with Docker compatibility and DNS enabled)

## Key Features

1.  **AI & Compute Maximization:**
    *   The `linuxPackages_zen` kernel is utilized to aggressively reduce latency.
    *   Systemd CPU affinity pinning allocates exactly 10 threads to `ollama` / `llama.cpp`.
    *   Custom nix overlays force `-DGGML_VULKAN=1` compilation for local LLM orchestration to fully leverage the RX 480 GPU.
2.  **System Hardening & OPSEC:**
    *   AppArmor is enabled system-wide.
    *   Firejail profiles wrap external-facing binaries like `qutebrowser`, `mpv`, and `kitty`.
    *   `macchanger` is deployed to randomize network interfaces on boot.
3.  **Desktop Environment & Tooling:**
    *   **Window Manager:** Qtile (Python-based, keyboard-driven).
    *   **Browser:** Qutebrowser (Customized for dark-mode, ad-blocking, and rapid OSINT querying).
    *   **Shell:** Nushell with Starship prompts.
    *   **Python:** Strictly managed via `uv`. Zero global python packages are installed.
4.  **The Watchdog Pipeline:**
    *   A dedicated, containerized Python script (`watchdog/main.py`) running on a systemd timer.
    *   Scrapes data using `puppeteer-cli`, pipes it locally to `fabric` running a Qwen model, and deduplicates inputs using SHA256 hashing.
    *   Appends analyzed intelligence directly as Markdown into the local Logseq knowledge graph.

## File Structure

The configuration is mapped to the local directory structure to facilitate version control.

### `./nixos/` (Maps to `/etc/nixos/`)
*   `flake.nix`: The master entry point defining system outputs and overlays.
*   `configuration.nix`: The baseline system configuration (packages, boot, OPSEC, and kernel parameters).
*   `overlays/ai-vulkan.nix`: Custom compilation overrides ensuring Vulkan support for AI binaries.
*   `modules/security/pentest.nix`: Comprehensive OSINT, Reverse Engineering, and Pentesting toolchains.
*   `modules/services/ai-orchestration.nix`: Systemd service definitions controlling thread affinity and memory bounds for Ollama and llama.cpp.
*   `modules/services/watchdog.nix`: Systemd timer and service configuration for the automated data scraping pipeline.

### `./dotfiles/` (Maps to `~/.config/`)
*   `qtile/config.py`: The fully flushed-out window manager configuration.
*   `qutebrowser/config.py`: The keyboard-driven browser environment.
*   `kitty/kitty.conf`: Low-latency terminal configurations.
*   `nushell/config.nu` & `nushell/env.nu`: The custom interactive shell environment.

### `./watchdog/`
*   `pyproject.toml`: The dependency definitions strictly managed by `uv`.
*   `main.py`: The robust pipeline logic for fetching, analyzing, and writing OPSEC/Arbitrage leads.
