#' Simulate Champagne Consumption for Multiple Parties
#'
#' @description
#' Simulates N parties by generating the number of guests, the number of glasses
#' consumed, and the poured champagne volume based on weather conditions
#' for a given city.
#'
#' @param city_name Character. Name of the city to use for weather-based lambda.
#' @param data Data frame containing at least: city, temperature, humidity, pressure.
#' @param glass A `Glass_Profile` object created with `GlassProfile()`.
#' @param N Integer. Number of simulated parties (default: 1000).
#' @param seed Integer. Random seed (default: 123).
#' @param bottle_L Numeric. Volume of one bottle in liters (default: 0.75).
#'
#' @return A data frame with one row per party and columns:
#' `party_id`, `guests`, `total_glasses`, `liters`, `bottles`.
#'
#' @examples
#' \dontrun{
#' simulate_party("Paris", weather_df, glass)
#' }
#'
#' @export
simulate_party <- function(city_name,
                           data,
                           glass,
                           N = 1000L,
                           seed = 123L,
                           bottle_L = 0.75) {

  stopifnot(inherits(glass, "Glass_Profile"))
  stopifnot("city" %in% names(data))

  set.seed(seed)

  if (!(city_name %in% data$city)) {
    stop("City ", city_name, " not found in weather data.")
  }

  row <- subset(data, city == city_name)[1, ]
  city_weather <- CityWeather(
    city        = row$city,
    temperature = row$temperature,
    humidity    = row$humidity,
    pressure    = row$pressure
  )

  lambda <- expected_lambda(city_weather)

  if (is.na(lambda)) {
    stop("Cannot simulate parties: lambda is NA (incomplete weather data).")
  }

  a_level <- 12.6
  mean_b <- 20
  sd_b   <- 0.5

  draw_b <- function(a) {
    b <- rnorm(1, mean = mean_b, sd = sd_b)
    while (b <= a || b > glass$b) {
      b <- rnorm(1, mean = mean_b, sd = sd_b)
    }
    b
  }

  out <- vector("list", N)

  for (p in seq_len(N)) {
    G <- rpois(1, lambda)

    if (G == 0) {
      total_glasses <- 0
      total_L <- 0
    } else {
      D <- rpois(G, 1.4)
      total_glasses <- sum(D)

      if (total_glasses == 0) {
        total_L <- 0
      } else {
        vols_cm3 <- numeric(total_glasses)
        for (k in seq_len(total_glasses)) {
          b_level <- draw_b(a_level)
          vols_cm3[k] <- volume_between(glass, a = a_level, b = b_level)
        }
        total_L <- sum(vols_cm3) / 1000
      }
    }

    bottles <- ceiling(total_L / bottle_L)

    out[[p]] <- data.frame(
      party_id      = p,
      guests        = G,
      total_glasses = total_glasses,
      liters        = total_L,
      bottles       = bottles
    )
  }

  do.call(rbind, out)
}
