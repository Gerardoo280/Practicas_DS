from abc import ABC, abstractmethod

class LLM(ABC):
  @abstractmethod
  def generate_summary(self, text: str):
      pass
  

class BasicLLM(LLM):
  def __init__(self, model: LLM, token: str ):
    self.token = token
    self.model = model

  def generate_summary(self, text: str):
    summarizer = pipeline("summarization", self.model)
    print(summarizer(text, max_length=130, min_length=30, do_sample=False))

class TranslationDecorator(BasicLLM):
  def generate_summary(self, text: str):


class SentimentDecorator(BasicLLM):
  def generate_summary(self, text: str):

