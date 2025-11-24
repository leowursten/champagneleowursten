test_that("expected_lambda returns a finite positive number", {
  cw <- CityWeather(city = "Paris",
                    temperature = 15,
                    humidity = 60,
                    pressure = 1013)

  λ <- expected_lambda(cw)

  expect_true(is.finite(λ))
  expect_gt(λ, 0)
})
