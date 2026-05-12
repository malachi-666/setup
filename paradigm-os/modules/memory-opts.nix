{ config, lib, pkgs, ... }:

{
  # System memory optimizations for 138GB RAM (Intel i7-7800X target)

  # Aggressive reduction of swapping to force RAM utilization
  boot.kernel.sysctl = {
    "vm.swappiness" = 1;

    # Hugepages configured explicitly for llama.cpp context caching.
    # 138GB total. Reserving 64GB specifically for Hugepages.
    # 64GB = 65536MB. Assuming 2MB default page size: 65536 / 2 = 32768 pages
    "vm.nr_hugepages" = 32768;

    # Optimize VFS cache pressure for heavy IO workloads (pentesting/compiling)
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
  };

  # Tmpfs mounts for /tmp and build directories to eliminate disk I/O bottlenecks
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    # Allow 64GB of RAM to be used for /tmp operations dynamically
    options = [ "nosuid" "nodev" "relatime" "size=64G" ];
  };

  # Also use tmpfs for nix builds. This dramatically speeds up rebuilds.
  systemd.services.nix-daemon = {
    environment = {
      TMPDIR = "/tmp/nix-build";
    };
  };

  # Ensure the Nix build directory exists on the tmpfs mount
  systemd.tmpfiles.rules = [
    "d /tmp/nix-build 0755 root root - -"
  ];
}
