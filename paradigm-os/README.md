# Paradigm OS

Paradigm OS is a highly optimized, declarative, bare-metal NixOS distribution tailored for an Intel Core i7-7800X, 138GB RAM, and an AMD Radeon RX 480 (8GB VRAM). It synergizes system management, penetration testing, OSINT gathering, AI orchestration, and developer productivity by chaining multiple state-of-the-art open-source projects into seamless pipelines.

## Exact Implementation Directions

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
    # Ensure you copy your new hardware-configuration.nix over the cloned one in /mnt/etc/nixos
    ```
5.  **Install NixOS:**
    Apply the flake configuration using the `chimeric` host profile.
    ```bash
    nixos-install --flake /mnt/etc/nixos#chimeric
    ```
6.  **Reboot & Login:** Reboot into the newly installed system and log in as the `mxi` user.
7.  **Post-Boot Setup:**
    Navigate to the OS directory and run the initialization script. This script dynamically resolves missing dependencies (like `uv`, `git`, `navi`) using `nix run`.
    ```bash
    cd /etc/nixos
    chmod +x setup.sh
    ./setup.sh
    ```

---

## The Core Repository Synergy Network (40+ Repositories)

The true strength of Paradigm OS lies in how we chain these repositories together. By integrating functional pipelines, the output of one tool dynamically feeds the context of the next.

### Phase 1: The Declarative Foundation & Optimization (1-8)
1.  **[NixOS/nixpkgs](https://github.com/NixOS/nixpkgs)**: The core Unstable package repository.
2.  **[nix-community/home-manager](https://github.com/nix-community/home-manager)**: Manages the `mxi` user environment natively alongside system config.
3.  **[nix-community/awesome-nix](https://github.com/nix-community/awesome-nix)**: The baseline inspiration for module splitting and best practices.
4.  **[systemd/systemd](https://github.com/systemd/systemd)**: Underlying service orchestrator, configured here for tmpfs mounting.
5.  **[torvalds/linux](https://github.com/torvalds/linux)**: Deeply optimized in `memory-opts.nix` (swappiness=1, hugepages for LLMs).
6.  **[qtile/qtile](https://github.com/qtile/qtile)**: The python-based Tiling Window Manager.
7.  **[picom/picom](https://github.com/yshui/picom)**: X11 Compositor.
8.  **[kovidgoyal/kitty](https://github.com/kovidgoyal/kitty)**: GPU-accelerated terminal emulator, chaining seamlessly with TWMs.

### Phase 2: The Hacker & OSINT Pipeline (9-18)
*Workflow:* Recon-ng pulls data -> passed to TheHarvester -> processed by JQ -> visualized.
9.  **[trimstray/the-book-of-secret-knowledge](https://github.com/trimstray/the-book-of-secret-knowledge)**: Foundational methodology for the pentesting stack.
10. **[lanmaster53/recon-ng](https://github.com/lanmaster53/recon-ng)**: Initial OSINT data gathering.
11. **[laramies/theHarvester](https://github.com/laramies/theHarvester)**: Secondary email/subdomain scraping.
12. **[jqlang/jq](https://github.com/jqlang/jq)**: Crucial for parsing JSON outputs from OSINT tools.
13. **[owasp-amass/amass](https://github.com/owasp-amass/amass)**: In-depth DNS enumeration.
14. **[rapid7/metasploit-framework](https://github.com/rapid7/metasploit-framework)**: Exploitation execution layer.
15. **[sqlmapproject/sqlmap](https://github.com/sqlmapproject/sqlmap)**: Automated SQL injection.
16. **[OJ/gobuster](https://github.com/OJ/gobuster)**: Directory/DNS brute-forcing.
17. **[nmap/nmap](https://github.com/nmap/nmap)**: Network discovery.
18. **[wireshark/wireshark](https://github.com/wireshark/wireshark)**: Deep packet analysis.

### Phase 3: The AI & Automation Engine (19-25)
*Workflow:* Puppeteer scrapes dynamic data -> piped to Llama.cpp -> fabric structures the output.
19. **[ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp)**: Core LLM inference, compiled explicitly with `-DGGML_VULKAN=1` for the RX 480.
20. **[ollama/ollama](https://github.com/ollama/ollama)**: API orchestration layer sitting on top of the Vulkan drivers.
21. **[danielmiessler/fabric](https://github.com/danielmiessler/fabric)**: AI workflow augmentation, standardizing prompts.
22. **[puppeteer/puppeteer](https://github.com/puppeteer/puppeteer)**: Used via `puppeteer-cli` for headless scraping of dynamic React/SPA targets.
23. **[GPUOpen-Drivers/AMDVLK](https://github.com/GPUOpen-Drivers/AMDVLK)**: Open-source AMD Vulkan drivers enabling AI acceleration.
24. **[KhronosGroup/Vulkan-Headers](https://github.com/KhronosGroup/Vulkan-Headers)**: Required build dependency for Llama Vulkan overriding.
25. **[RadeonOpenCompute/ROCm](https://github.com/RadeonOpenCompute/ROCm)**: Secondary GPU compute stack available in the environment.

### Phase 4: Developer Productivity & Environments (26-34)
*Workflow:* Nushell acts as data fabric -> uv manages Python boundaries -> Editors interact with AST.
26. **[denisidoro/navi](https://github.com/denisidoro/navi)**: Interactive cheatsheet, dynamically loading context via post-boot script.
27. **[nushell/nushell](https://github.com/nushell/nushell)**: Structured data shell replacing bash/zsh.
28. **[astral-sh/uv](https://github.com/astral-sh/uv)**: Extremely fast Python package installer, enforcing the zero-global-python policy.
29. **[LazyVim/LazyVim](https://github.com/LazyVim/LazyVim)**: Neovim distribution bootstrapped dynamically.
30. **[doomemacs/doomemacs](https://github.com/doomemacs/doomemacs)**: Emacs distribution, demonstrating dual-editor competence.
31. **[mhinz/vim-galore](https://github.com/mhinz/vim-galore)**: Editor configuration methodology.
32. **[rust-lang/cargo](https://github.com/rust-lang/cargo)**: Rust package manager (Virtualisation/Dev module).
33. **[golang/go](https://github.com/golang/go)**: Go compiler.
34. **[nodejs/node](https://github.com/nodejs/node)**: Node backend support.

### Phase 5: Virtualization & Cloud Readiness (35-42)
*Workflow:* Build isolated containers -> host via Libvirt -> prep for deployment to Free-for-dev PaaS.
35. **[docker/cli](https://github.com/docker/cli)**: Containerization management.
36. **[libvirt/libvirt](https://github.com/libvirt/libvirt)**: Bare-metal VM hypervisor orchestrator.
37. **[virt-manager/virt-manager](https://github.com/virt-manager/virt-manager)**: GUI for managing libvirt domains.
38. **[qemu/qemu](https://github.com/qemu/qemu)**: Machine emulator underneath Libvirt.
39. **[ripienaar/free-for-dev](https://github.com/ripienaar/free-for-dev)**: The target destination logic; developing locally to deploy free globally.
40. **[codecrafters-io/build-your-own-x](https://github.com/codecrafters-io/build-your-own-x)**: The learning architecture; ensuring tools are understood, not just used.
41. **[junegunn/fzf](https://github.com/junegunn/fzf)**: The fuzzy finder powering Navi and terminal history workflows.
42. **[starship/starship](https://github.com/starship/starship)**: Cross-shell prompt integrated into Nushell.
