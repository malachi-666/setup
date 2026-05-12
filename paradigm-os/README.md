<div align="center"><img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nixos.svg" height="150" alt="NixOS Logo"></div>
<h1 align="center">Paradigm OS: Bare-Metal NixOS with Vulkan AI & Pentesting</h1>

<div align="center">

![nixos](https://img.shields.io/badge/NixOS-Unstable-informational.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A&colorB=8aadf4)
![python](https://img.shields.io/badge/Python-uv-informational.svg?style=flat&logo=python&logoColor=f4dbd6&colorA=24273A&colorB=b7bdf8)
![qtile](https://img.shields.io/badge/Qtile-X11-informational.svg?style=flat&logo=python&logoColor=eed49f&colorA=24273A&colorB=91d7e3)
![vulkan](https://img.shields.io/badge/Vulkan-Accelerated-informational.svg?style=flat&logo=vulkan&logoColor=f5a97f&colorA=24273A&colorB=f5a97f)
![ai](https://img.shields.io/badge/AI-llama.cpp%20|%20Ollama-informational.svg?style=flat&logo=openai&logoColor=a6da95&colorA=24273A&colorB=a6da95)

</div>

## 📑 Table of Contents
- [About](#-about)
- [Features](#-features)
- [Installation](#-installation)
- [The Core Repository Synergy Network](#-the-core-repository-synergy-network)
  - [Phase 1: Declarative Foundation](#phase-1-declarative-foundation)
  - [Phase 2: Hacker & OSINT Pipeline](#phase-2-hacker--osint-pipeline)
  - [Phase 3: AI & Automation Engine](#phase-3-ai--automation-engine)
  - [Phase 4: Developer Productivity](#phase-4-developer-productivity)
  - [Phase 5: Virtualization & Cloud](#phase-5-virtualization--cloud)

## 📖 About

This repository houses **Paradigm OS**, a highly optimized, declarative, bare-metal NixOS distribution. Tailored specifically for hardware profiles akin to an Intel Core i7-7800X, 138GB RAM, and an AMD Radeon RX 480 (8GB VRAM), it synergizes system management, penetration testing, OSINT gathering, AI orchestration, and developer productivity.

> [!NOTE]
> It is essential to note that this configuration strictly enforces a **Zero Global Python** policy via `uv`, compiles LLM orchestration tools with `GGML_VULKAN=1` for immediate AMD GPU offloading, and aggressively optimizes memory handling for 138GB RAM via `tmpfs` and hugepages.

## ✨ Features

*   **Vulkan-Accelerated AI:** Native compilation overrides for `llama.cpp` and `ollama` utilizing AMD RX 480.
*   **Massive Memory Tuning:** `vm.swappiness=1` and pre-allocated hugepages for lightning-fast LLM context caching.
*   **Sandboxed Penetration Testing:** Dedicated modules aggregating top-tier OSINT and exploit frameworks.
*   **Dual Editor Ethos:** Pre-configured bootstraps for both `LazyVim` (Neovim) and `Doom Emacs`.
*   **Zero Global Packages:** Absolute containment of Python environments using `uv`.

## ⚙️ Installation

Follow these steps exactly to bootstrap Paradigm OS from a vanilla NixOS installation.

1.  **Boot the NixOS Live ISO:** Obtain the latest `nixos-unstable` ISO and boot your target machine.
2.  **Partition and Format:** Ensure your drives are partitioned correctly. Mount your root to `/mnt` and boot to `/mnt/boot`.
3.  **Clone the Configuration:**
    ```bash
    nix-shell -p git
    git clone <your-repo-url>/paradigm-os /mnt/etc/nixos
    ```
4.  **Hardware Configuration Sync:**
    If you are on different hardware, regenerate the hardware config:
    ```bash
    nixos-generate-config --root /mnt
    # Overwrite the hardware-configuration.nix in the cloned repo
    ```
5.  **Install NixOS:**
    Apply the flake configuration using the `chimeric` host profile.
    ```bash
    nixos-install --flake /mnt/etc/nixos#chimeric
    ```
6.  **Reboot & Login:** Reboot into the newly installed system and log in as the `mxi` user.
7.  **Post-Boot Setup:**
    Run the initialization script to dynamically resolve missing dependencies and bootstrap user environments.
    ```bash
    cd /etc/nixos
    chmod +x setup.sh
    ./setup.sh
    ```

---

## 🔗 The Core Repository Synergy Network

The true strength of Paradigm OS lies in how we chain these 42+ repositories together. By integrating functional pipelines, the output of one tool dynamically feeds the context of the next.

### Phase 1: Declarative Foundation
*The core structural components enabling the OS layer.*
| Component | Repository | Role |
| :--- | :--- | :--- |
| **OS Core** | [NixOS/nixpkgs](https://github.com/NixOS/nixpkgs) | The core Unstable package repository. |
| **User Space** | [nix-community/home-manager](https://github.com/nix-community/home-manager) | Native management of the `mxi` user environment. |
| **Methodology** | [nix-community/awesome-nix](https://github.com/nix-community/awesome-nix) | Baseline inspiration for module splitting. |
| **Init System** | [systemd/systemd](https://github.com/systemd/systemd) | Service orchestration & `tmpfs` mounts. |
| **Kernel** | [torvalds/linux](https://github.com/torvalds/linux) | Deeply optimized via `memory-opts.nix`. |
| **Window Manager**| [qtile/qtile](https://github.com/qtile/qtile) | Tiling Window Manager. |
| **Compositor** | [picom/picom](https://github.com/yshui/picom) | X11 Compositing. |
| **Terminal** | [kovidgoyal/kitty](https://github.com/kovidgoyal/kitty) | GPU-accelerated terminal emulator. |

### Phase 2: Hacker & OSINT Pipeline
*Workflow: Recon-ng pulls data -> passed to TheHarvester -> processed by JQ -> visualized.*
| Component | Repository | Role |
| :--- | :--- | :--- |
| **Methodology** | [trimstray/the-book-of-secret-knowledge](https://github.com/trimstray/the-book-of-secret-knowledge) | Foundational methodology for pentesting. |
| **Recon Base** | [lanmaster53/recon-ng](https://github.com/lanmaster53/recon-ng) | Initial OSINT data gathering. |
| **Data Scraping** | [laramies/theHarvester](https://github.com/laramies/theHarvester) | Secondary email/subdomain scraping. |
| **Data Parsing** | [jqlang/jq](https://github.com/jqlang/jq) | Parsing JSON outputs from OSINT tools. |
| **DNS Enum** | [owasp-amass/amass](https://github.com/owasp-amass/amass) | In-depth DNS enumeration. |
| **Exploitation** | [rapid7/metasploit-framework](https://github.com/rapid7/metasploit-framework) | Execution layer. |
| **Injection** | [sqlmapproject/sqlmap](https://github.com/sqlmapproject/sqlmap) | Automated SQL injection. |
| **Bruteforcing** | [OJ/gobuster](https://github.com/OJ/gobuster) | Directory/DNS brute-forcing. |
| **Discovery** | [nmap/nmap](https://github.com/nmap/nmap) | Network discovery. |
| **Packet Analysis**| [wireshark/wireshark](https://github.com/wireshark/wireshark) | Deep packet analysis. |

### Phase 3: AI & Automation Engine
*Workflow: Puppeteer scrapes dynamic data -> piped to Llama.cpp -> fabric structures the output.*
| Component | Repository | Role |
| :--- | :--- | :--- |
| **Inference Engine**| [ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp) | Core LLM inference, compiled with Vulkan. |
| **AI API** | [ollama/ollama](https://github.com/ollama/ollama) | Orchestration layer over Vulkan drivers. |
| **Prompt Logic** | [danielmiessler/fabric](https://github.com/danielmiessler/fabric) | AI workflow augmentation. |
| **Automation** | [puppeteer/puppeteer](https://github.com/puppeteer/puppeteer) | Headless scraping of dynamic targets. |
| **Drivers** | [GPUOpen-Drivers/AMDVLK](https://github.com/GPUOpen-Drivers/AMDVLK) | Open-source AMD Vulkan drivers. |
| **Headers** | [KhronosGroup/Vulkan-Headers](https://github.com/KhronosGroup/Vulkan-Headers) | Build dependency for Llama Vulkan. |
| **Compute Stack** | [RadeonOpenCompute/ROCm](https://github.com/RadeonOpenCompute/ROCm) | Secondary GPU compute stack. |

### Phase 4: Developer Productivity
*Workflow: Nushell acts as data fabric -> uv manages Python boundaries -> Editors interact with AST.*
| Component | Repository | Role |
| :--- | :--- | :--- |
| **Cheatsheets** | [denisidoro/navi](https://github.com/denisidoro/navi) | Interactive cheatsheet loading context. |
| **Shell** | [nushell/nushell](https://github.com/nushell/nushell) | Structured data shell. |
| **Python Env** | [astral-sh/uv](https://github.com/astral-sh/uv) | Python package installer (zero-global). |
| **Editor (Neo)** | [LazyVim/LazyVim](https://github.com/LazyVim/LazyVim) | Neovim distribution. |
| **Editor (Emacs)**| [doomemacs/doomemacs](https://github.com/doomemacs/doomemacs) | Emacs distribution. |
| **Editor Meta** | [mhinz/vim-galore](https://github.com/mhinz/vim-galore) | Editor configuration methodology. |
| **Rust Env** | [rust-lang/cargo](https://github.com/rust-lang/cargo) | Rust package manager. |
| **Go Env** | [golang/go](https://github.com/golang/go) | Go compiler. |
| **Node Env** | [nodejs/node](https://github.com/nodejs/node) | Node backend support. |

### Phase 5: Virtualization & Cloud
*Workflow: Build isolated containers -> host via Libvirt -> prep for deployment to Free-for-dev PaaS.*
| Component | Repository | Role |
| :--- | :--- | :--- |
| **Containers** | [docker/cli](https://github.com/docker/cli) | Containerization management. |
| **Hypervisor** | [libvirt/libvirt](https://github.com/libvirt/libvirt) | VM hypervisor orchestrator. |
| **VM GUI** | [virt-manager/virt-manager](https://github.com/virt-manager/virt-manager) | GUI for libvirt domains. |
| **Machine Emu** | [qemu/qemu](https://github.com/qemu/qemu) | Emulator underneath Libvirt. |
| **Cloud Logic** | [ripienaar/free-for-dev](https://github.com/ripienaar/free-for-dev) | Target destination & deployment tracking. |
| **Learning Arch** | [codecrafters-io/build-your-own-x](https://github.com/codecrafters-io/build-your-own-x) | Ensuring tools are understood, not just used. |
| **Fuzzy Finder** | [junegunn/fzf](https://github.com/junegunn/fzf) | Powering Navi and terminal workflows. |
| **Prompt UI** | [starship/starship](https://github.com/starship/starship) | Cross-shell prompt integrated into Nushell. |

<div align="center">
  <sub>Built with precision. Chained for massive strength.</sub>
</div>
