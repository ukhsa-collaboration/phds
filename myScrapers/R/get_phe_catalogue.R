## creates a data frame of PHE stats and publications on GOV.UK

#' Get data.frame of PHE resources on GOV.UK
#'
#' @param url 
#' @param pages 
#' @param n 
#'
#' @return Returns a datatable of PHE resources
#' 
#'
#' @examples
#' df <- get_phe_catalogue(n = 100)
get_phe_catalogue <- function(url = "https://www.gov.uk/search/all?organisations%5B%5D=public-health-england", n= 298) {
  
  library(rvest)
  library(stringr)
  require(dplyr)
  
  first_page <- url
  sub_pages <- paste0(first_page,"&page=", 2:n)
  urls <- c(first_page, sub_pages)
  
  pubs <- purrr::map(urls, get_page_links)
  
  pubs <- pubs %>%
    purrr::flatten()
  
  pubs <-purrr::map_df(pubs, data.frame) 
  
  
  colnames(pubs) <- c("Links")
  
  phe_pubs <- pubs %>%
    distinct()
  
  
  
  phe_national_pubs <- phe_pubs %>%
    mutate(group = case_when(str_detect(Links, "collections/")~ "collections", 
                             str_detect(Links, "statistics/") ~ "statistics",
                             str_detect(Links, "publications/") ~ "publication", 
                             str_detect(Links, "guidance/") ~ "guidance"),
           link = paste0("https://www.gov.uk", Links), 
           link = paste0("<a href =",  link,  ">Link</a>")) %>%
    dplyr::filter(!is.na(group))
  
  
}


