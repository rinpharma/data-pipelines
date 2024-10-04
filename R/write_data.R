write_data <- function(
  raw_data,
  processed_team,
  processed_proceedings
){
  readr::write_rds(
    all_data <- list(
      raw_data = raw_data,
      processed_team = processed_team,
      processed_proceedings = processed_proceedings
    ),
    "output/all_data.rds"
  )

  readr::write_csv2(
    processed_team, "output/processed_team.csv"
  )

  readr::write_csv2(
    processed_team, "output/processed_proceedings.csv"
  )
}
