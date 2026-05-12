{ config, pkgs, ... }:

{
  home.username = "paradigm";
  home.homeDirectory = "/home/paradigm";
  home.stateVersion = "24.05";

  # User specific packages.
  # Note: Zero global python packages are installed. `uv` handles python.
  home.packages = with pkgs; [
    # uv for python environment management
    uv

    # Editors
    neovim
    pkgs.emacs

    # Utilities
    git
    gh
    ripgrep
    fd
    fzf
    starship

    # Navi cheatsheet
    navi
  ];

  # Basic Git config
  programs.git = {
    enable = true;
    userName = "Paradigm User";
    userEmail = "user@paradigm.local";
  };

  # Shell configurations (Nushell is default)
  programs.nushell = {
    enable = true;
    # Add starship prompt initialization
    extraConfig = ''
      # Nushell config here
    '';
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
