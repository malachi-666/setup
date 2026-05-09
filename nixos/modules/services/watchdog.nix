{ config, pkgs, ... }:

{
  # 4. The Watchdog Pipeline Refactor
  # Systemd Timer and Service to run the uv-managed Python project.

  systemd.timers.panopticon-watchdog = {
    description = "Timer for Panopticon Watchdog Pipeline";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "15m";
      OnUnitActiveSec = "1h"; # Run every hour
      Unit = "panopticon-watchdog.service";
    };
  };

  systemd.services.panopticon-watchdog = {
    description = "Panopticon Watchdog Pipeline execution via uv";
    after = [ "network-online.target" "ollama.service" ];
    wants = [ "network-online.target" ];

    path = with pkgs; [
      uv
      git
      # Needed for puppeteer / fabric subprocess calls if they rely on system binaries
      puppeteer-cli
      fabric-ai
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "architect";
      # Ensure this points to where the repository is cloned on the live system.
      # For deployment, assuming the repo is in ~/workspace/watchdog
      WorkingDirectory = "/home/architect/workspace/watchdog";
      # Run the main.py using uv securely isolated
      ExecStart = "${pkgs.uv}/bin/uv run main.py";

      # OPSEC & Resource Controls
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = "read-only";
      # Allow write access specifically to Logseq folder to append the leads
      ReadWritePaths = [ "/home/architect/Logseq/pages/" ];
    };
  };
}
