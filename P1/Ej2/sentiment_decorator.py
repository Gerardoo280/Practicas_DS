from llm_decorator import LLMDecorator
from constants import API_URL
import requests

class SentimentDecorator(LLMDecorator):
  def generate_summary(self, text: str):
    texto_previo = super().generate_summary(text)
    response = requests.post(API_URL+self.model, headers={"Authorization": f"Bearer {self.token}"}, json={"inputs": texto_previo})
    label = response.json()[0][0]["label"]
    score = response.json()[0][0]["score"]
    return f"{texto_previo} [{label} ({score:.2f})]"