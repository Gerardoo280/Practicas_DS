import json
from dotenv import load_dotenv
import os
from LLM import BasicLLM, TranslationDecorator, SentimentDecorator

with open("config.json", "r") as file:
  config = json.load(file)

load_dotenv()
token = os.getenv("huggingface_api_token")

def main():
  basico = BasicLLM(config["model_llm"], token)
  resumen = basico.generate_summary(config["texto"])

  traduccion = TranslationDecorator(basico, config["model_translation"], token)
  resumen_traducido = traduccion.generate_summary(config["texto"])

  sentimiento = SentimentDecorator(basico, config["model_sentiment"], token)
  resumen_sentimiento = sentimiento.generate_summary(config["texto"])

  # Combinamos traducción y sentimientos
  combinado = SentimentDecorator(traduccion, config["model_sentiment"], token)
  resumen_combinado = combinado.generate_summary(config["texto"])

  resultados = {
    "resumen_basico": resumen,
    "resumen_traducido": resumen_traducido,
    "resumen_sentimiento": resumen_sentimiento,
    "resumen_combinado": resumen_combinado
  }

  with open("resultados.json", "w", encoding="utf-8") as f:
    json.dump(resultados, f, ensure_ascii=False, indent=2)


if __name__ == '__main__':
  main()