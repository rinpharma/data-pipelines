write_data <- function(
  processed_team,
  processed_proceedings,
  processed_workshops
){


  if (!dir.exists("output")) dir.create("output")
  
  # function so no mismatch
  help_save_file <- function(data){
    # Capture the name of the argument
    name_of_input <- as.character(substitute(data))

    # write it
    output_loc <- glue::glue("output/{name_of_input}.parquet")
    message(glue::glue("writing {output_loc}"))
    nanoparquet::write_parquet(data,output_loc)
  }

  help_save_file(processed_team)
  help_save_file(processed_proceedings)
  help_save_file(processed_workshops)
}
