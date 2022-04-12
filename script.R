#package da attivare

library(tidyverse)
library(rvest)


## ESEMPIO DI URL BASE

URL = "inserire l'URL base del SINGOLO PRODOTTO"

# Esempio di URL base
URL = "https://www.amazon.it/product-reviews/B00XUGZRL8/ref=cm_cr_getr_d_paging_btm_next_2?ie=UTF8&filterByStar=all_stars&reviewerType=all_reviews&pageNumber="

# Alternativa per più di un prodotto

Product_list = c("lista di URL base")

###

#Da ogni URL base si scrappa il numero massimo di pagine di recensioni
# Su amazon non è escplicito, ma è esplicito il numero di recensioni

read_html (URL) %>%
  html_node("#filter-info-section span") %>% html_text %>%
  word(28) %>% as.integer() -> n_rev


# Il numero di pagine è

as.integer(n_rev / 10) +1 -> lastpage

### Lista degli URL
URL_list = str_c(URL,1:lastpage)

#in caso di molteplici prodotti, bisogna mappare/vettorializzre la funzione
# di str_c sulla lista degli URL base dei prodotti

### SCRAPING VERO E PROPRIO

tibble(Product = as.character(),
       Day = as.character(),
       User = as.character(),
       Score = as.character(),
       Text = as.character()
) -> db

add_row(db,Product = rep(NA,length(URL_list)*10)) -> db

for (i in c(1:lastpage)) {
  
  URL_list[i] -> db$Product[(1+((i-1)*10)):(i*10)] 
  
  read_html((URL_list[i])) -> x
  
  x %>% html_nodes("#cm_cr-review_list .review-date") %>%
    html_text() -> Day
  Day[1:10] -> db$Day[(1+((i-1)*10)):(i*10)]
  
  x %>% html_nodes("#cm_cr-review_list .a-profile-name") %>%
    html_text() %>% unique() -> User
  User[1:10] -> db$User[(1+((i-1)*10)):(i*10)]
  
  x %>% html_nodes("#cm_cr-review_list .review-rating") %>%
    html_text() -> Score
  Score[1:10] -> db$Score[(1+((i-1)*10)):(i*10)]
  
  x %>% html_nodes(".review-text-content span") %>%
    html_text() -> Text
  Text[1:10] -> db$Text[(1+((i-1)*10)):(i*10)]
  
}



x %>% html_nodes("#cm_cr-review_list .review-date") %>%
  html_text() -> reviews$Time[[(1+(i-1)*10):(i*10)]]

reviews$Time

x %>% html_nodes("#cm_cr-review_list .a-profile-name") %>%
  html_text() %>% ifelse(
    length(. %>% as.vector()) > 10) 

x %>% html_nodes("#cm_cr-review_list .a-profile-name") %>%
  html_text() %>% length() > 10

length()

v = c(1,2,2,3,4,5,4,1,1,2,2)

v %>% ifelse(. > 10,
             1,
             2)

v[v != dplyr::lag(v, default = Inf)]
