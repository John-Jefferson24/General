parameters [
  {
    key: "model"
    value: { string_value: "mistralai/Mistral-Small-3.1-24B-Instruct-2503" }
  },
  {
    key: "tensor_parallel_size"
    value: { string_value: "2" }
  },
  {
    key: "dtype"
    value: { string_value: "bfloat16" }
  },
  {
    key: "gpu_memory_utilization"
    value: { string_value: "0.8" }
  },
  {
    key: "enforce_eager"
    value: { string_value: "true" }
  },
  {
    key: "trust_remote_code"
    value: { string_value: "true" }
  },
  {
    key: "max_model_len"
    value: { string_value: "8192" }
  },
  {
    key: "chat_template_path"
    value: { string_value: "/absolute/path/to/chat_template.json" }
  }
]
