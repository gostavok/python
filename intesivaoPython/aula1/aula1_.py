import pyautogui
import pyperclip
import time
import pandas as pd

pyautogui.PAUSE = 1

pyautogui.press("win")
pyautogui.write("chrome")
pyautogui.press("enter")

pyperclip.copy("https://drive.google.com/drive/folders/149xknr9JvrlEnhNWO49zPcw0PW5icxga?usp=sharing")

pyautogui.hotkey("ctrl", "t")
pyautogui.hotkey("ctrl", "v")
pyautogui.press("enter")

time.sleep(2.5)

pyautogui.click(x=373, y=303, clicks=2)

time.sleep(1.5)
pyautogui.click(x=373, y=303)
time.sleep(0.5)
pyautogui.click(x=1705, y=195)
time.sleep(0.5)
pyautogui.click(x=1442, y=594)
time.sleep(5)

tabela = pd.read_excel("Vendas - Dez.xlsx")


faturamento = tabela["Valor Final"].sum()
quantidade = tabela["Quantidade"].sum()



pyperclip.copy("https://mail.google.com/mail/u/0/?tab=rm&ogbl#inbox")

pyautogui.hotkey("ctrl", "t")
pyautogui.hotkey("ctrl", "v")
pyautogui.press("enter")

time.sleep(2)

print(pyautogui.position())

pyautogui.click(x=100, y=200)

pyautogui.write("email@gmail.com")
pyautogui.press("tab")
pyautogui.press("tab")
pyperclip.copy("Relatório Mensal")

pyautogui.hotkey("ctrl", "v")
pyautogui.press("tab")


texto = f"""
        Mensagem R$:{faturamento:,.2f} Mensagem: {quantidade:,} mensagem

        Atenciosamente.
        """
pyperclip.copy(texto)
pyautogui.hotkey("ctrl", "v")

pyautogui.hotkey("ctrl", "enter")