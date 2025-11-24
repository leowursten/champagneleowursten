#' @title CityWeather object
#' @description
#' Small S3 class that stores basic weather information for one city:
#' temperature (°C), humidity (%) and pressure (hPa).
#'
#' @param city Character, name of the city.
#' @param temperature Numeric, temperature in degrees Celsius.
#' @param humidity Numeric, relative humidity in percent (0–100).
#' @param pressure Numeric, atmospheric pressure in hPa.
#'
#' @return An object of class \code{"City_Weather"}.
#'
#' @examples
#' cw <- CityWeather("Paris", temperature = 12, humidity = 85, pressure = 1015)
#' cw
#'
#' @export
CityWeather <- function(city,
                        temperature = NA_real_,
                        humidity = NA_real_,
                        pressure = NA_real_) {
  structure(
    list(
      city        = city,
      temperature = temperature,
      humidity    = humidity,
      pressure    = pressure
    ),
    class = "City_Weather"
  )
}

#' @title Print method for City_Weather
#' @description Nicely prints basic weather information for a city.
#'
#' @param x A \code{City_Weather} object.
#' @param ... Not used.
#'
#' @return Invisibly returns \code{x}.
#' @export
print.City_Weather <- function(x, ...) {
  if (any(is.na(c(x$temperature, x$humidity, x$pressure)))) {
    cat("No complete weather data available for", x$city, "\n")
  } else {
    cat("Weather in", x$city, "\n")
    cat("  Temperature:", x$temperature, "°C\n")
    cat("  Humidity   :", x$humidity, "%\n")
    cat("  Pressure   :", x$pressure, "hPa\n")
  }
  invisible(x)
}

#' @title Expected number of guests from weather
#' @description
#' Computes the expected number of guests based on a simple log-link model:
#' \deqn{\lambda = exp(0.5 + 0.5 T - 3 H + 0.001 P),}
#' where \eqn{T} is temperature (°C), \eqn{H} humidity (in percent, 0–100),
#' and \eqn{P} pressure (hPa).
#'
#' @param city_weather A \code{City_Weather} object.
#'
#' @return Numeric scalar, expected number of guests.
#'
#' @examples
#' cw <- CityWeather("Paris", temperature = 20, humidity = 50, pressure = 1010)
#' expected_lambda(cw)
#'
#' @export
expected_lambda <- function(city_weather) {
  stopifnot(inherits(city_weather, "City_Weather"))

  T <- city_weather$temperature
  H <- city_weather$humidity / 100  # passer de % à proportion
  P <- city_weather$pressure

  if (any(is.na(c(T, H, P)))) {
    stop("Temperature, humidity and pressure must all be available.")
  }

  lambda <- exp(0.5 + 0.5 * T - 3 * H + 0.001 * P)
  lambda
}
