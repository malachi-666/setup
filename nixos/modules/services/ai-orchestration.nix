{ config, pkgs, ... }:

{
  # 1. LLM Threading & Compute Maximization
  # The Intel i7-7800X has 6 cores / 12 threads.
  # We explicitly pin 10 threads for compute, leaving 2 for system overhead.
  # We optimize batch sizes for the RX 480 8GB Vulkan backend.

  systemd.services.ollama = {
    description = "Ollama AI Orchestration Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    environment = {
      OLLAMA_HOST = "127.0.0.1:11434";
      OLLAMA_NUM_PARALLEL = "1"; # Focus on single fast generation
      OLLAMA_MAX_VRAM = "8192"; # Explicitly define the 8GB limit for the RX 480
      # Thread pinning: 10 threads for compute
      OLLAMA_NUM_THREADS = "10";
      # AMD Vulkan specific Overrides
      GGML_VULKAN = "1";
      HSA_OVERRIDE_GFX_VERSION = "8.0.3";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";
    };
    serviceConfig = {
      ExecStart = "${pkgs.ollama}/bin/ollama serve";
      Restart = "always";
      User = "architect";
      # Systemd resource controls to prevent locking up the host
      CPUAffinity = "0,1,2,3,4,5,6,7,8,9"; # Pin to first 10 threads
      MemoryMax = "32G"; # Prevent Ollama from gobbling the 138GB RAM, keeping it reserved for caching
    };
  };

  # Optional llama.cpp server configuration if used instead of Ollama
  systemd.services.llamacpp = {
    description = "llama.cpp API Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    environment = {
      GGML_VULKAN = "1";
      HSA_OVERRIDE_GFX_VERSION = "8.0.3";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";
    };
    serviceConfig = {
      # -t 10 sets 10 threads. -ng 99 offloads all layers to GPU. -b 512 optimizes batch size for 8GB VRAM
      ExecStart = "${pkgs.llama-cpp}/bin/llama-server -m /var/lib/models/qwen.gguf -t 10 -ng 99 -c 8192 -b 512 --host 127.0.0.1 --port 8080";
      Restart = "on-failure";
      User = "architect";
      CPUAffinity = "0,1,2,3,4,5,6,7,8,9";
    };
  };
}
