final: prev: {
  llama-cpp = prev.llama-cpp.override {
    vulkanSupport = true;
  };
  ollama = prev.ollama.override {
    acceleration = "vulkan";
  };
}
