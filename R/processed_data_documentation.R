#' Weather data for several capital cities
#'
#' @description
#' A small processed dataset extracted from the raw OpenWeather JSON file
#' `weather_full.json`. It contains basic weather variables for a set of cities:
#' temperature (°C), humidity (%) and pressure (hPa).
#'
#' The data were obtained by calling the OpenWeather API, then stored in
#' `data-raw/weather_full.json` and transformed via
#' `data-raw/data_transformation.R` into a clean data frame.
#'
#' @format A data frame with one row per city and the following columns:
#' \describe{
#'   \item{city}{Character. Name of the city (e.g. "Paris").}
#'   \item{temperature}{Numeric. Temperature in degrees Celsius.}
#'   \item{humidity}{Numeric. Relative humidity in percent (0–100).}
#'   \item{pressure}{Numeric. Atmospheric pressure in hPa.}
#' }
#'
#' @examples
#' data("processed_data")
#' head(processed_data)
#' summary(processed_data$temperature)
#'
#' @source OpenWeather API, pre-processed from \code{weather_full.json}.
"processed_data"
