from openai import OpenAI
from PIL import Image
import base64
from io import BytesIO

client = OpenAI(base_url="http://localhost:9000/v1", api_key="EMPTY")

# Load and encode image
image = Image.open("local_image.jpg").resize((896, 896))
buffered = BytesIO()
image.save(buffered, format="JPEG")
image_base64 = base64.b64encode(buffered.getvalue()).decode("utf-8")  # Just the base64 string

messages = [
    {"role": "system", "content": "You are a helpful assistant."},
    {
        "role": "user",
        "content": [
            {"type": "image", "image": image_base64},  # Pass base64 string directly
            {"type": "text", "text": "Describe this image in detail."}
        ]
    }
]

completion = client.chat.completions.create(
    model="gemma-3-27b-it",
    messages=messages,
    max_tokens=200
)
print(completion.choices[0].message.content)

from openai import OpenAI

client = OpenAI(base_url="http://localhost:9000/v1", api_key="EMPTY")

# Minimal image input (short base64 string for testing)
test_base64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg=="  # 1x1 pixel image

messages = [
    {"role": "system", "content": "You are a helpful assistant."},
    {
        "role": "user",
        "content": [
            {"type": "image", "image": test_base64},
            {"type": "text", "text": "Describe this image."}
        ]
    }
]

try:
    completion = client.chat.completions.create(
        model="gemma-3-27b-it",
        messages=messages,
        max_tokens=200
    )
    print(completion.choices[0].message.content)
except Exception as e:
    print(f"Error: {str(e)}")
