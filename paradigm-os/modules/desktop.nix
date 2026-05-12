{ config, pkgs, ... }:

{
  # Enable X11 and Qtile window manager
  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
    displayManager.startx.enable = true;
  };

  # Set default shell for all users to Nushell
  environment.shells = with pkgs; [ nushell ];
  users.defaultUserShell = pkgs.nushell;

  # Essential Desktop Applications
  environment.systemPackages = with pkgs; [
    kitty         # Terminal Emulator
    nushell       # Shell
    qutebrowser   # Keyboard-focused browser
    dmenu         # Application launcher (used by Qtile often)
    picom         # Compositor
    nitrogen      # Wallpaper setter
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-emoji
  ];
}
