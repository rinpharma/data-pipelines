write_data <- function(
  processed_talks,
  processed_team
){


  if (!dir.exists("output")) dir.create("output")
  
  # function so no mismatch
  help_save_parquet <- function(data){
    # Capture the name of the argument
    name_of_input <- as.character(substitute(data))

    # write it
    output_loc <- glue::glue("output/{name_of_input}.parquet")
    message(glue::glue("writing {output_loc}"))
    nanoparquet::write_parquet(data, output_loc)
  }
  
  help_save_csv <- function(data){
    # Capture the name of the argument
    name_of_input <- as.character(substitute(data))

    # write it
    output_loc <- glue::glue("output/{name_of_input}.csv")
    message(glue::glue("writing CSV {output_loc}"))
    write.csv(data, output_loc, row.names = FALSE)
  }

  help_save_parquet(processed_talks)
  help_save_parquet(processed_team)

  help_save_csv(processed_talks)
  help_save_csv(processed_team)

}
