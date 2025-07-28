
library(tidyverse)
library(rvest)


url <- "https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population" 



remove_end_brackets <- function(string){
  first_bracket <- str_locate(string, "\\[")[1]
  if (is.na(first_bracket)){
    out <- string 
  } else {
    out <- str_sub(string, 1, first_bracket-1)
  }
  return(out)
}

wikiTable <- url |> 
  read_html() |>
  html_nodes("table") |> 
  html_table(fill = T)

pop_data <- wikiTable[[1]][-1,] |> 
  select(name = 1, pop_change_perc = 4, pop_change_n = 5) |> 
  mutate(
    perc_label = str_replace(pop_change_perc, "−", "-"), 
    n_label    = str_replace(pop_change_n    , "−", "-"), 
    perc = parse_number(perc_label), 
    n = parse_number(n_label) 
  ) |> 
  rowwise() |> 
  mutate(name = remove_end_brackets(name)) |> 
  ungroup() |> 

  select(name, perc, perc_label, n, n_label) |> 
  filter(!name %in% c("Contiguous United States", 
                      "The 50 states", 
                      "The 50 states and D.C.", 
                      "Total US and territories")) |> 
  arrange(name)


write.csv(pop_data, "us_population_change_2010_to_2020.csv")
  