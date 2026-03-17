import requests
import csv
from abc import ABC, abstractmethod
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

URL = "https://www.scrapethissite.com/pages/forms/?page_num={}"
CAMPOS = ["Team Name", "Year", "Wins", "Losses", "OT Losses", "Win %", "Goals For", "Goals Against", "+/-"]


def getURLs(soup):
    datos = []
    filas = soup.select("tr.team")
    for fila in filas:
        columnas = fila.find_all('td')
        if len(columnas) >= 9:
            datos.append({
                "Team Name": columnas[0].text.strip(),
                "Year": columnas[1].text.strip(),
                "Wins": columnas[2].text.strip(),
                "Losses": columnas[3].text.strip(),
                "OT Losses": columnas[4].text.strip(),
                "Win %": columnas[5].text.strip(),
                "Goals For": columnas[6].text.strip(),
                "Goals Against": columnas[7].text.strip(),
                "+/-": columnas[8].text.strip()
            })
    return datos


class Estrategia(ABC):
    @abstractmethod
    def ejecutar(self) -> list:
        pass


class Estrategia_BeautifulSoup(Estrategia):
    def ejecutar(self) -> list:
        datos = []

        # Iterar para las 5 primeras páginas
        for pagina in range(1, 6):
            response = requests.get(URL.format(pagina))
            soup = BeautifulSoup(response.text, 'html.parser')
            datos.extend(getURLs(soup))
    
        return datos


class Estrategia_Selenium(Estrategia):
    def ejecutar(self) -> list:
        opciones = webdriver.ChromeOptions()
        opciones.add_argument('--headless')
        driver = webdriver.Chrome(service=Service(), options=opciones)
        
        datos = []
        # Iterar para las 5 primeras páginas
        for pagina in range(1, 6):
            driver.get(URL.format(pagina))

            WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CSS_SELECTOR, "tr.team")))

            filas = driver.find_elements(By.CSS_SELECTOR, "tr.team")
            for fila in filas:
                columnas = fila.find_elements(By.TAG_NAME, 'td')
                if len(columnas) >= 9:
                    datos.append({
                        "Team Name": columnas[0].text.strip(),
                        "Year": columnas[1].text.strip(),
                        "Wins": columnas[2].text.strip(),
                        "Losses": columnas[3].text.strip(),
                        "OT Losses": columnas[4].text.strip(),
                        "Win %": columnas[5].text.strip(),
                        "Goals For": columnas[6].text.strip(),
                        "Goals Against": columnas[7].text.strip(),
                        "+/-": columnas[8].text.strip()
                    })
        driver.quit()
        return datos


class Contexto:
    def __init__(self, estrategia: Estrategia):
        self.estrategia = estrategia

    def ejecutar_estrategia(self) -> list:
        return self.estrategia.ejecutar()


def guardar_csv(datos, nombre_archivo):
    with open(nombre_archivo, mode='w', newline='', encoding='utf-8') as archivo_csv:
        writer = csv.DictWriter(archivo_csv, fieldnames=CAMPOS)
        writer.writeheader()  # Escribir encabezados
        writer.writerows(datos)   # Escribir datos


if __name__ == "__main__":
    print("Selecciona una estrategia:")
    print("1. BeautifulSoup")
    print("2. Selenium")
    opcion = input("Ingrese el número de la estrategia que desea usar: ")

    if opcion == "1":
        estrategia = Estrategia_BeautifulSoup()
    elif opcion == "2":
        estrategia = Estrategia_Selenium()
    else:
        print("Opción no válida")
        exit()

    contexto = Contexto(estrategia)
    datos = contexto.ejecutar_estrategia()
    guardar_csv(datos, "datos_web.csv")
    print("Datos guardados en 'datos_web.csv'")