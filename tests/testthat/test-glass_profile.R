test_that("GlassProfile volumes are positive", {
  glass <- GlassProfile(
    a = 12.6, b = 22.5,
    x_1 = 1.1, x_2 = 12.6, x_3 = 18.8, x_4 =22.5,
    r_foot = 5.8, r_stem = 0.25, r_bowl = 7.5, r_rim = 7
  )

  V <- volume_between(glass)

  expect_true(is.numeric(V))
  expect_gt(V, 0)
})
