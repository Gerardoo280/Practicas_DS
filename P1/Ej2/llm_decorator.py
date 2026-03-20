from llm import LLM

class LLMDecorator(LLM):
  def __init__(self, llm_base: LLM, model: str, token: str):
    self.modelo_decorador = llm_base
    self.model = model
    self.token = token
  
  def generate_summary(self, text: str):
    return self.modelo_decorador.generate_summary(text)