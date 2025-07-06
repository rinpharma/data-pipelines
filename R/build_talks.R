build_talks <- function(
  data
){


  # Clean data -----------------------------------------------------------------

    d_talks <- data |>
      dplyr::arrange(Date,Start) |>
        dplyr::mutate(
        # Modify col
        Title = gsub("'","",Title),
        # Add col
        Year = format(Date, format="%Y"),
        ID = paste0("rinpharma_",dplyr::row_number()),
        Start = format(Start, "%H:%M:%S"),
        End = format(End, "%H:%M:%S")
        ) |>
        dplyr::select(
        ID,Event,Abstract,Type, Year, Date, Start, End, Speaker, Affiliation, Title, Slides, Video
      )
    
  # Sanitise
    d_talks <- d_talks |>
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
  
    d_talks
}    
