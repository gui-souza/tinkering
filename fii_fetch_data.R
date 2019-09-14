library(httr)
library(XML)

###########
#Crawling 'clubefii.com.br'
baseUrl <- 'https://www.clubefii.com.br/'
clubeFiiList <- function(username, password) {
    #Specs. do meu browser
    userAgent <- 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0'
    #A primeira request é um POST. Adicionei headers simulando o comportamento do browser
    POST(
        url = paste0(baseUrl, 'login'),
        add_headers(
            `User-Agent` = userAgent,
            Referer	= baseUrl,
            `X-Requested-With` = 'XMLHttpRequest'
        ),
        #Parâmetros exigidos pelo site para login
        body = list(
            email = username,
            senha = password
        ),
        encode = 'form'
    ) -> result
    #user_login_info <- content(result, as = "parsed")
    #Uma request GET até um perfil de filtros de tabela que fiz préviamente no site
    GET(
        url = paste0(baseUrl, 'radar_profile_visualizacao_ajx?cod_pro=24956&preview=undefined'),
        add_headers(
            'Referer' = paste0(baseUrl),
            `User-Agent` = userAgent,
            `X-Requested-With` = 'XMLHttpRequest',
            Referer = paste0(baseUrl, 'radar_profile_visualizacao?cod_pro=24956')
        )
    ) -> res
    c <- content(res)
    #Juice =)
    html_node(c, '#tabela_profile') %>% html_table()
    #parsedHtml <- htmlParse(res, asText = TRUE)
}

data <- clubeFiiList('username', 'password')

clube_fii_list <- data %>% 
    mutate(last_price = stringr::str_extract(`Cotação`, '\\d{1,3}(,\\d{2}|.\\d{3},\\d{2})')) %>% 
    mutate(last_price = as.numeric(gsub(",", ".", gsub("\\.", "", last_price))))






