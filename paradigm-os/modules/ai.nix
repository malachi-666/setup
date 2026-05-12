{ config, pkgs, ... }:

let
  # Override llama-cpp to use Vulkan for the AMD Radeon RX 480 (8GB VRAM)
  llama-cpp-vulkan = pkgs.llama-cpp.overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or []) ++ [ "-DGGML_VULKAN=1" ];
    buildInputs = (old.buildInputs or []) ++ [ pkgs.vulkan-headers pkgs.vulkan-loader ];
  });

  # Apply the same Vulkan override conceptually for Ollama if supported,
  # otherwise ensure it uses the GPU via rocm/vulkan appropriately.
  ollama-vulkan = pkgs.ollama.override {
    acceleration = "rocm"; # or rely on Vulkan if supported in the specific Nixpkgs derivation
  };
in
{
  environment.systemPackages = [
    llama-cpp-vulkan
    ollama-vulkan

    # AI CLI Tooling (Orchestrators/Augmentation)
    pkgs.fabric       # Daniel Miessler's AI augmentation framework
    pkgs.aichat       # Chat with LLMs in the terminal
    pkgs.mods         # AI on the command line
    pkgs.tgpt         # Terminal GPT (No API key required)
  ];

  # Setup services if needed
  services.ollama = {
    enable = true;
    package = ollama-vulkan;
  };

  # Hardware acceleration support for AMD
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr
    rocmPackages.clr.icd
    amdvlk
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
}
