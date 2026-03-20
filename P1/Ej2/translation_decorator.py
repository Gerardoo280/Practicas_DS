from llm_decorator import LLMDecorator
from constants import API_URL
import requests


class TranslationDecorator(LLMDecorator):
  def generate_summary(self, text: str):
    response = requests.post(API_URL+self.model, headers={"Authorization": f"Bearer {self.token}"}, json={"inputs": super().generate_summary(text)})
    return response.json()[0]["translation_text"]