pythonimport json

# Load the JSON file
with open("chat_template.json", "r") as f:
    template_data = json.load(f)

# Extract the Jinja template
jinja_template = template_data["chat_template"]

# Save it to a .jinja file
with open("mistral_template.jinja", "w") as f:
    f.write(jinja_template)


    python3 openai_frontend/main.py \
  --model-repository /path/to/your/vllm_models \
  --tokenizer mistralai/Mistral-Small-3.1-24B-Instruct-2503 \
  --tokenizer-mode mistral \
  --config-format mistral \
  --load-format mistral \
  --tool-call-parser mistral \
  --enable-auto-tool-choice \
  --chat-template /path/to/mistral_template.jinja
