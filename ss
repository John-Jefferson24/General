from openai import OpenAI
from PIL import Image
import base64
from io import BytesIO

client = OpenAI(base_url="http://localhost:9000/v1", api_key="EMPTY")

# Load and encode image
image = Image.open("local_image.jpg").resize((896, 896))
buffered = BytesIO()
image.save(buffered, format="JPEG")
image_base64 = base64.b64encode(buffered.getvalue()).decode("utf-8")

messages = [
    {"role": "system", "content": "You are a helpful assistant."},
    {
        "role": "user",
        "content": [
            {"type": "image_url", "image_url": {"url": f"data:image/jpeg;base64,{image_base64}"}},
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
