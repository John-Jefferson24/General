name: "gemma-3-27b-it"  # Make sure this matches your model name
backend: "vllm"

input [
  {
    name: "text_input"
    data_type: TYPE_STRING
    dims: [ -1 ]
  },
  {
    name: "image_input"
    data_type: TYPE_STRING
    dims: [ -1 ]
    optional: true
  }
]

output [
  {
    name: "text_output"
    data_type: TYPE_STRING
    dims: [ -1 ]
  }
]

instance_group [
  # Your existing instance_group configuration
]

parameters [
  {
    key: "enable_multimodal"
    value: { string_value: "true" }
  },
  {
    key: "vision_encoder_name"
    value: { string_value: "siglip" }
  },
  {
    key: "image_size" 
    value: { string_value: "896" }
  }
]
