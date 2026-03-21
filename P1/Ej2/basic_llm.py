import requests
from llm import LLM
from constants import API_URL

class BasicLLM(LLM):
  def __init__(self, model: str, token: str ):
    self.token = token
    self.model = model

  def generate_summary(self, text: str):
    response = requests.post(API_URL+self.model, headers={"Authorization": f"Bearer {self.token}"}, json={"inputs": text})
    return response.json()[0]["summary_text"]