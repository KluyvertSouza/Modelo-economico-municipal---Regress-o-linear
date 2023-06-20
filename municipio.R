library(clipr)
library(dplyr)
library(sidrar)

tabela = read_clip_tbl()
amostra = sample_n(tabela , 300 , replace = FALSE)
filtro = amostra$IBGE7

"https://sidra.ibge.gov.br/tabela/5457#/n3/15/n6/1100379,1100502/v/214/p/2020/c782/0/l/,c782,t+p+v
https://sidra.ibge.gov.br/tabela/5457#/n3/15/n6/1100379/v/214/p/2020/c782/0/l/,c782,t+p+v
https://sidra.ibge.gov.br/tabela/5457#/n3/15/n6/1100379/v/214/p/2020/c782/allxt/l/,c782,t+p+v"

info = get_sidra(x = 5457 , variable = 214, classific = "c782" , geo = "City" , geo.filter = 1100379) 

dados = NA

for (i in 1:300) {
  dados[i] = list(get_sidra(api = paste0("/t/5457/n6/",filtro[i],"/v/214/p/2020/c782/allxt")))
}

valores = NA

for (i in 1:300) {
  valores[,i] = (select(dados[[i]],Valor))
}

colnames(valores) = amostra$Município

as.vector(select(dados[[1]],Valor)) %>% mode()
