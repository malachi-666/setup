{ config, lib, pkgs, ... }:

{
  # System memory optimizations for 138GB RAM

  # Aggressive reduction of swapping
  boot.kernel.sysctl = {
    "vm.swappiness" = 1;
    # Hugepages configured for LLM context caching.
    # 138GB total, let's reserve a chunk for hugepages (e.g. 32GB = 16384 * 2MB)
    "vm.nr_hugepages" = 16384;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
  };

  # Tmpfs mounts for /tmp and build directories to reduce disk I/O
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "nosuid" "nodev" "relatime" "size=64G" ];
  };

  # Also use tmpfs for nix builds if desired (speeds up build, requires RAM)
  systemd.services.nix-daemon = {
    environment = {
      TMPDIR = "/tmp/nix-build";
    };
  };

  # Ensure the Nix build directory exists on tmpfs
  systemd.tmpfiles.rules = [
    "d /tmp/nix-build 0755 root root - -"
  ];
}
