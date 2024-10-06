#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# To test
# 
# targets::tar_manifest(fields = all_of("command"))
# targets::tar_visnetwork()

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("tibble","qs"), # Packages that your targets need for their tasks.
  format = "qs", # Optionally set the default storage format. qs is fast.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Replace the target list below with your own:
list(
  tar_target(
    name = get_gsheet_data,
    command = get_data()
  ),
  tar_target(
    name = data_processed_team,
    command = build_team(get_gsheet_data[["team"]])
  ),
  tar_target(
    name = data_processed_proceedings,
    command = build_proceedings(get_gsheet_data[["all_conferences"]])
  ),
  tar_target(
    name = data_processed_workshops,
    command = build_workshops(get_gsheet_data[["workshops"]])
  ),
  tar_target(
    name = write_data_to_files,
    command = write_data(
      processed_team = data_processed_team,
      processed_proceedings = data_processed_proceedings,
      processed_workshops = data_processed_workshops
    )
  )
)
