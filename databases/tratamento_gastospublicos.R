# TRATAMENTO DOS DADOS DE GASTO PÚBLICO EM PERNAMBUCO

if(!require("pacman")) {
  install.packages("pacman")
}

pacman::p_load(tidyverse, 
               readxl, 
               psych,
               janitor)

df<- read_csv("C:/Users/ryall/Downloads/GastosPublicos - municipios.csv",
  locale = locale(encoding = "UTF-8"),
  show_col_types = FALSE
)


df_long <- df %>%
  pivot_longer(
    cols = starts_with("Ano_"),
    names_to = "ano",
    values_to = "valor"
  ) %>%
  mutate(
    ano = gsub("Ano_", "", ano),
    ano = as.integer(ano)
  )

df_long <- df_long %>%
  mutate(
    valor = gsub("\\.", "", valor),   # remove ponto de milhar
    valor = gsub(",", ".", valor),    # troca vírgula por ponto
    valor = as.numeric(valor)
  )

glimpse(df_long)


readr::write_csv(
  df_long,
  "C:/Users/ryall/Desktop/R/quantitatividade/quantitatividade/databases/df_gastospublicos.csv"
  ,
  na = "",
  quote = "needed"
)


codigos <- readxl::read_excel("C:/Users/ryall/Downloads/RELATORIO_DTB_BRASIL_2024_MUNICIPIOS.xls")

# head(codigos, 10)

# 1. Extrair os nomes da linha 6
novos_nomes <- codigos %>% 
  slice(6) %>% 
  unlist() %>% 
  as.character()

# 2. Aplicar como nomes das colunas
codigos_limpo <- codigos %>% 
  slice(-(1:6)) %>%     # remove linhas 1 a 6
  setNames(novos_nomes) %>% 
  clean_names()         # padroniza nomes (opcional)

# 3. Resetar rownames (boa prática)
codigos_limpo <- codigos_limpo %>% 
  mutate(across(everything(), ~ .))  # força tibble limpa

readr::write_csv(
  codigos,
  "C:/Users/ryall/Desktop/R/quantitatividade/quantitatividade/databases/codigos_ibge.csv"
  ,
  na = "",
  quote = "needed"
)

