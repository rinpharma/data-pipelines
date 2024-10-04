build_team <- function(
  data
){
    
  # Clean data -------------------------------------------------------------------
    
    d_team <- data |>
      dplyr::filter(!is.na(linkedin)) 
    
    d_team[is.na(d_team)] <- ""
    

    d_team
}
