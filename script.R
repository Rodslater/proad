library(tidyverse)

campus <- c('Campus Aracaju', 'Campus Estância', 'Campus Glória', 'Campus Itabaiana', 'Campus Lagarto', 'Campus Propriá', 'Campus São Cristóvão', 'Campus Socorro', 'Campus Tobias Barreto', 'Reitoria')

df <- list()  # Lista para armazenar os data frames
for (i in campus) {
  file_name <- paste0(i, ".xlsx")  # Nome do arquivo com a extensão .xlsx
  url <- URLencode(paste0("https://github.com/Rodslater/proad/raw/main/Crédito disponível - Centralização - ", file_name))  # Caminho para o arquivo
  file_path <- paste0("Crédito disponível - Centralização - ", file_name)  # Caminho para o arquivo
  curl::curl_download(url, file_path)
  
  # Leitura do arquivo Excel usando a função read_excel e armazenamento na lista
  df[[i]] <- read_excel(file_path , skip = 5)
  df[[i]] <- tail(df[[i]],-1)
  col_names <- c('cod_acao', 'acao', 'cod_ug', 'ug', 'cod_fonte', 'fonte', 
                 'cod_grupo_despesa', 'grupo_despesa', 'cod_natureza_despesa', 'natureza_despesa',
                 'credito_disponivel', 'credito_indisponivel', 'empenhado', 'liquidado', 'pago')
  colnames(df[[i]]) <- col_names
  df[[i]] <- fill(df[[i]], cod_acao:natureza_despesa, .direction = 'down')
  df[[i]]$campus <- i
  
}

df <- bind_rows(df)

df <- df |> 
  mutate_at(c(11:15), as.numeric) |> 
  mutate_all(replace_na, 0)

saveRDS(df, "tesouro.rds")
