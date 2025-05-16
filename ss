{
  "add_bos_token": true,
  "add_eos_token": false,
  "chat_template": "{% for message in messages %}{% if message['role'] == 'system' %}<|system|>{{ message['content'] }}<|end|>{% elif message['role'] == 'user' %}<|user|>{{ message['content'] }}<|end|>{% elif message['role'] == 'assistant' %}<|assistant|>{{ message['content'] }}<|end|>{% endif %}{% endfor %}<|assistant|>",
  "clean_up_tokenization_spaces": false,
  "model_max_length": 32768,
  "tokenizer_class": "LlamaTokenizer",
  "use_default_system_prompt": false
}
