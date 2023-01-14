import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from  sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import r2_score

tabela = pd.read_csv('advertising.csv')

print(tabela.corr())
sns.heatmap(tabela.corr(), cmap="Blues", annot=True)

plt.show()


y = tabela["Vendas"]
x = tabela[["TV","Radio","Jornal"]]

x_treino, x_teste, y_treino, y_teste = train_test_split(x,y, test_size=0.3)

modelo_regressaolinear = LinearRegression()
modelo_arvoredecisao = RandomForestRegressor()

modelo_regressaolinear.fit(x_treino, y_treino)
modelo_arvoredecisao.fit(x_treino, y_treino)

previsao_regressaolinear = modelo_regressaolinear.predict(x_teste)
previsao_arvoredecisao = modelo_arvoredecisao.predict(x_teste)

print(r2_score(y_teste,previsao_regressaolinear))
print(r2_score(y_teste,previsao_arvoredecisao))

tabela_auxiliar = pd.DataFrame()
tabela_auxiliar["y_teste"] = y_teste
tabela_auxiliar["Previsao Arvore Decisao"] = previsao_arvoredecisao
tabela_auxiliar["Previsao Regressao Linear"] = previsao_arvoredecisao

sns.lineplot(data=tabela_auxiliar)
plt.show()

nova_tabela = pd.read_csv('novos.csv')
previsao_arvore = modelo_arvoredecisao.predict(nova_tabela)
previsao_regressao = modelo_regressaolinear.predict(nova_tabela)

tabela_previsao = pd.DataFrame()
tabela_previsao["Previsao Arvore"] = previsao_arvore
tabela_previsao["Previsao Regressao"] = previsao_regressao


print(previsao_arvore)
print(previsao_regressao)
sns.lineplot(data=tabela_previsao)
plt.show()