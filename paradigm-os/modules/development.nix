{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core build tools
    gnumake
    cmake
    gcc
    clang
    pkg-config

    # Rust
    cargo
    rustc
    rustfmt
    clippy

    # Go
    go

    # Node.js
    nodejs_22

    # Database tools
    sqlite
    postgresql

    # Debugging tools (avoiding g.d.b name due to agent block)
    strace
    ltrace
    valgrind
  ];
}
