build_proceedings <- function(
  file_name = "rinpharma-4ac2ad6eba3b.json",
  secret_name = "googlesheets4",
  sheet_url = "https://docs.google.com/spreadsheets/d/1NaDnMRh2nOBCzBUxbIyJBVWd_InaEMLTW0rEJtD2ywE/edit#gid=0"  
){

  path <- paste0("inst/secret/", file_name)
  raw <- readBin(path, "raw", file.size(path))
  json <- sodium::data_decrypt(
    bin = raw, key = gargle:::secret_pw_get(secret_name),
    nonce = gargle:::secret_nonce()
  )
  pass <- rawToChar(json)

  googlesheets4::gs4_auth(
    scopes = 'https://www.googleapis.com/auth/spreadsheets',
    path = pass
    )

  # Get data -------------------------------------------------------------------

    d_raw_proceedings <- googlesheets4::read_sheet(sheet_url, sheet = "all_conferences")

  # Clean data -----------------------------------------------------------------

    d_all <- d_raw_proceedings |>
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
