build_proceedings <- function(
  data
){


  # Clean data -----------------------------------------------------------------

    d_all <- data |>
      dplyr::arrange(Date,Start) |>
        dplyr::mutate(
        # Modify col
        Title = gsub("'","",Title),
        # Add col
        Year = format(Date, format="%Y"),
        ID = paste0("rinpharma_",dplyr::row_number())
      ) |>
        dplyr::select(
        ID,Event,Abstract,Type, Year,Date, Speaker, Affiliation, Title, Slides, Video
      )

    d_proceedings <- d_all |>
      dplyr::filter(
        Type %in% c("Workshop","Keynote","Talk")
      )

  # Sanitise
    d_proceedings <- d_proceedings |>
      dplyr::mutate(

        # sanitize abstract
        Abstract_Sanitzed = gsub(":","",Abstract),
        Abstract_Sanitzed = gsub("[\r\n]"," ",Abstract_Sanitzed),
        Abstract_Sanitzed = trimws(Abstract_Sanitzed), 
        Abstract_Sanitzed = gsub("[{}]"," ",Abstract_Sanitzed),
        
        Missing_Content = dplyr::case_when(
          is.na(Abstract) & is.na(Slides) & is.na(Video) ~ "Unfortunately we do not currently have an abstract, copy of the slides or link to the video to this presentation",
          TRUE ~ NA_character_
        )
      )
  
  d_proceedings
}    
