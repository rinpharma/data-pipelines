build_team <- function(
  data
){
    
  # Clean data -------------------------------------------------------------------
    
    d_team <- data |>
      dplyr::select(-email) |> # don't print emails to public site
      dplyr::filter(!is.na(linkedin)) 
    
    d_team[is.na(d_team)] <- ""
    

    d_team
}
