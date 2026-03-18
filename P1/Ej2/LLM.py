from abc import ABC, abstractmethod
import requests

API_URL = "https://router.huggingface.co/hf-inference/models/"

class LLM(ABC):
  @abstractmethod
  def generate_summary(self, text: str):
    pass
  

class BasicLLM(LLM):
  def __init__(self, model: str, token: str ):
    self.token = token
    self.model = model

  def generate_summary(self, text: str):
    response = requests.post(API_URL+self.model, headers={"Authorization": f"Bearer {self.token}"}, json={"inputs": text})
    return response.json()[0]["summary_text"]

class LLMDecorator(LLM):
  def __init__(self, llm_base: LLM, model: str, token: str):
    self.modelo_decorador = llm_base
    self.model = model
    self.token = token
  
  def generate_summary(self, text: str):
    return self.modelo_decorador.generate_summary(text)

class TranslationDecorator(LLMDecorator):
  def generate_summary(self, text: str):
    response = requests.post(API_URL+self.model, headers={"Authorization": f"Bearer {self.token}"}, json={"inputs": super().generate_summary(text)})
    return response.json()[0]["translation_text"]


class SentimentDecorator(LLMDecorator):
  def generate_summary(self, text: str):
    texto_previo = super().generate_summary(text)
    response = requests.post(API_URL+self.model, headers={"Authorization": f"Bearer {self.token}"}, json={"inputs": texto_previo})
    label = response.json()[0][0]["label"]
    score = response.json()[0][0]["score"]
    return f"{texto_previo} [{label} ({score:.2f})]"

