build_team <- function(
  data
){

  ## Template -------------------------------------------------------------------
  template <- "
  ---
  # Display name
  title: {title}

  # Is this the primary user of the site?
  superuser: {site_superuser} # true or false

  # Role/position
  role: {role}

  social:
  - icon: linkedin
    icon_pack: fab
    link: https://www.linkedin.com/in/{linkedin}
  {github}
  {custom_link}


  # Enter email to display Gravatar (if Gravatar enabled in Config)
  email: '{email}'

  # Highlight the author in author lists? (true/false)
  highlight_name: false

  # Organizational groups that you belong to (for People widget)
  #   Set this to `[]` or comment out if you are not using People widget.
  user_groups:
  - Organising Committee
  ---
  "

    
  # Clean data -------------------------------------------------------------------
    
    d_team <- data |>
      dplyr::filter(!is.na(linkedin)) 
    
    d_team[is.na(d_team)] <- ""
    
  # Fill template ----------------------------------------------------------------
  team_output <- NULL
  for (i in d_team$linkedin) {
    
    i_team <- d_team |>
      dplyr::filter(linkedin == i) 
    
    if(i_team$custom_link != ""){
      custom_link <- glue::glue(
        "- icon: link
          icon_pack: fas
          link: {i_team$custom_link}
        "
      )
    } else {
      custom_link <- ""
    }
    
    if(i_team$github != ""){
      github <- glue::glue(
        "- icon: github
          icon_pack: fab
          link: https://github.com/{i_team$github}
        "
      )
    } else {
      github <- ""
    }

    team_output[i_team$linkedin] <- glue::glue(
        template,
        title = i_team$name,
        site_superuser = i_team$site_superuser,
        role = i_team$role,
        linkedin = i_team$linkedin,
        custom_link = custom_link,
        github = github,
        email = i_team$email
      )
    
    
  }

  team_output
}
