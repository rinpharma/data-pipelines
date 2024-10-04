get_data <- function(
  file_name = "rinpharma-4ac2ad6eba3b.json",
  secret_name = "googlesheets4",
  sheet_url = "https://docs.google.com/spreadsheets/d/1NaDnMRh2nOBCzBUxbIyJBVWd_InaEMLTW0rEJtD2ywE/edit#gid=0"
){
  # enrich params
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

    # check the value of the option, if you like
    #options(gargle_oauth_email = "james.black.jb2@roche.com")
    #gs4_auth(email = "james.black.jb2@roche.com", cache = ".secrets")
    
  
    gsheet_data <- list(
      team = googlesheets4::read_sheet(sheet_url, sheet = "team"),
      all_conferences =googlesheets4::read_sheet(sheet_url, sheet = "all_conferences"),
      redirects =googlesheets4::read_sheet(sheet_url, sheet = "redirects"),
      workshops =googlesheets4::read_sheet(sheet_url, sheet = "workshops")
    )
    

  gsheet_data
}
