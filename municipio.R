library(clipr)
library(dplyr)
library(sidrar)

tabela = read_clip_tbl()
amostra = sample_n(tabela , 300 , replace = FALSE)
filtro = amostra$IBGE7


dados = NA

for (i in 1:300) {
  dados[i] = list(get_sidra(api = paste0("/t/5457/n6/",filtro[i],"/v/214/p/2020/c782/allxt")))
}

valores = matrix(nrow = 71 , ncol = 300)

for (i in 1:300) {
  valores[,i] = as.matrix(select(dados[[i]],Valor))
}

colnames(valores) = amostra$Município

valores[is.na(valores)] = 0 



