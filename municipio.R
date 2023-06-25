library(clipr)
library(dplyr)
library(sidrar)

# Tabela que contém todos os municípios do Brasil
tabela = municípios_do_brasil

# Retirando a amostra
amostra = sample_n(tabela , 300 , replace = FALSE)

# Filtro para selecionar a Amostra
filtro = amostra$IBGE7

# Armazenando os dados
dados = NA

# Utilizando a API do IBGE para obter os dados
  # Algo importante aqui é que os dados serão armazenados na forma de 
  # large list.
for (i in 1:300) {
  dados[i] = list(get_sidra(api = paste0("/t/5457/n6/",filtro[i],"/v/214/p/2020/c782/allxt")))
}

# Como são 71 produto das lavouras e uma amostra de tamanho 300:
valores = matrix(nrow = 71 , ncol = 300)

# armazenando como matriz, extraindo o necessário de cada lista
for (i in 1:300) {
  valores[,i] = as.matrix(select(dados[[i]],Valor))
}

# Renomenando e tratando 
exemplo = get_sidra(api = paste0("/t/5457/n6/",filtro[1],"/v/214/p/2020/c782/allxt"))
colnames(valores) = amostra$Município
row.names(valores) = exemplo$`Produto das lavouras temporárias e permanentes`
valores[is.na(valores)] = 0 

# Quantidade produzida das lavouras - Totais

qdt_total = tibble("Qdt. Total das lavouras" = numeric(300)) %>% as.data.frame()
  for (i in 1:300) {
    qdt_total[i,] = (sum(valores[,i]))
  }
# Finalizando a tabela

qdt_total$`NOME DO MUNICÍPIO` = amostra$Município
qdt_total$UF = amostra$UF
qdt_total$CÓDIGO = amostra$IBGE7
qdt_total = qdt_total %>% relocate(`Qdt. Total das lavouras` , .after = "CÓDIGO")
  
# Populacao de cada município

populacao = filter(POP2020_20220905 ,`CÓDIGO` %in% filtro)


