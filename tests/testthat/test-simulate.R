test_that("simulate_party returns a data frame with expected columns", {
  # fake single-row weather data
  data <- data.frame(
    city = "Paris",
    temperature = 15,
    humidity = 50,
    pressure = 1000
  )

  glass <- GlassProfile(
    a = 12.6, b = 22.5,
    x_1 = 1.1, x_2 = 12.6, x_3 = 18.8, x_4 = 22.5,
    r_foot = 5.8, r_stem = 0.25, r_bowl = 7.5, r_rim = 7
  )

  res <- simulate_party("Paris", data, glass, N = 10)

  expect_s3_class(res, "data.frame")
  expect_true(all(c("party_id", "guests", "liters", "bottles") %in% names(res)))
  expect_equal(nrow(res), 10)
})
