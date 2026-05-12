{ config, pkgs, ... }:

{
  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable Libvirt for local VM management
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Add users to virtualization groups
  users.users.mxi.extraGroups = [ "docker" "libvirtd" ];

  # Helpful packages for virt/container management
  environment.systemPackages = with pkgs; [
    docker-compose
    qemu
    OVMFFull
  ];
}
