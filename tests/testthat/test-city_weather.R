test_that("CityWeather prints correct message with missing data", {
  cw <- CityWeather("TestCity", temperature = NA, humidity = 50, pressure = 1000)

  expect_output(print(cw), "No complete weather data available")
})
