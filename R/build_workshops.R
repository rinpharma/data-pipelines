build_workshops <- function(
  data
){
    
  # Clean data -------------------------------------------------------------------
  data |>
    dplyr::mutate(
      date = as.Date(date)
    ) 
}
