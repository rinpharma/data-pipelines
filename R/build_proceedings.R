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

  # Remove NA
    d_proceedings[is.na(d_proceedings)] <- ""

  # Sanitise
    d_proceedings <- d_proceedings |>
      dplyr::mutate(
        type = dplyr::case_when(
          Type == "Talk" ~ 1,
          Type == "Keynote" ~ 2,
          Type == "Workshop" ~ 3
        ),

        # sanitize abstract
        abstract = gsub(":","",Abstract),
        abstract = gsub("[\r\n]"," ",abstract),
        abstract = trimws(abstract), 
        abstract = gsub("[{}]"," ",abstract),
        

        # split speaker and author
        author = paste("-",Speaker),
        author = gsub(" and ","\n- ",author),
        author = gsub(", ","\n- ",author),

        affaliations = paste("-",Affiliation),
        affaliations = gsub(" \\| ","\n- ",affaliations),
        
        missing_content = dplyr::case_when(
          abstract == "" & Slides == "" & Video == "" ~ "Unfortunately we do not currently have an abstract, copy of the slides or link to the video to this presentation",
          TRUE ~ ""
        )
      )
  
  d_proceedings
}    
