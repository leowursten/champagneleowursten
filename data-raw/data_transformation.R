# data-raw/data_transformation.R
#
# Ce script lit le JSON brut venant d'OpenWeather,
# extrait quelques variables simples (city, temperature, humidity, pressure)
# et les enregistre dans data/processed_data.rda pour le package.

library(jsonlite)

# chemin vers le JSON brut
weather_path <- "data-raw/weather_full.json"

if (!file.exists(weather_path)) {
  stop("File ", weather_path, " not found. Put weather_full.json into data-raw/.")
}

# on lit le JSON SANS simplifier pour éviter les problèmes de colonnes
weather_raw <- fromJSON(weather_path, simplifyVector = FALSE)

# on s'attend à une liste nommée par ville
city_names <- names(weather_raw)

rows <- lapply(city_names, function(city) {
  entry <- weather_raw[[city]]

  main <- entry$main

  # si un des champs manque, on ignore cette ville
  if (is.null(main$temp) || is.null(main$humidity) || is.null(main$pressure)) {
    return(NULL)
  }

  list(
    city        = city,
    temperature = as.numeric(main$temp),
    humidity    = as.numeric(main$humidity),
    pressure    = as.numeric(main$pressure)
  )
})

# on enlève les NULL (villes incomplètes)
rows <- Filter(Negate(is.null), rows)

# si tout est vide → message clair
if (length(rows) == 0) {
  stop("No complete city records found in weather_full.json.")
}

# on combine en data.frame
processed_data <- do.call(
  rbind,
  lapply(rows, as.data.frame, stringsAsFactors = FALSE)
)

# petit tri par nom de ville pour être propre
processed_data <- processed_data[order(processed_data$city), ]

# vérification rapide
str(processed_data)

# on enregistre dans data/processed_data.rda
# usethis::use_data() crée le .rda au bon endroit
if (!requireNamespace("usethis", quietly = TRUE)) {
  stop("Package 'usethis' is required. Install with install.packages('usethis').")
}

usethis::use_data(processed_data, overwrite = TRUE)
