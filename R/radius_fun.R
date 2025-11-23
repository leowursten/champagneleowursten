#' @title Smooth easing function for glass profile
#' @description Helper function S(z) used to smooth transitions in the radius profile.
#' @param t Numeric value between 0 and 1.
#' @return A numeric value between 0 and 1.
#' @examples
#' S(0)
#' S(0.5)
#' S(1)
#' @export
S <- function(t) 0.5 - 0.5 * cos(pi * t)

#' @title Radius profile of the champagne glass
#' @description Piecewise radius function r(t) defining the shape of the glass.
#' @param t Position along the vertical axis (cm).
#' @param x_1,x_2,x_3,x_4 Breakpoints (cm) that define foot, stem, bowl and rim transitions.
#' @param r_foot,r_stem,r_bowl,r_rim Radii (cm) at foot, stem, bowl and rim.
#' @return Radius at height t (cm).
#' @examples
#' r(10, x_1 = 1, x_2 = 5, x_3 = 10, x_4 = 15,
#'   r_foot = 5, r_stem = 1, r_bowl = 6, r_rim = 5)
#' @export
r <- function(t, x_1, x_2, x_3, x_4,
              r_foot, r_stem, r_bowl, r_rim) {
  # scalar-only: take first value if vector is passed by mistake
  t <- t[1]

  if (t < 0) {
    return(0)
  } else if (t < x_1) {
    return(r_foot)
  } else if (t < x_2) {
    return(r_stem)
  } else if (t < x_3) {
    # smooth transition stem -> bowl
    z <- (t - x_2) / (x_3 - x_2)   # rescale to [0,1]
    s <- S(z)
    return(r_stem * (1 - s) + r_bowl * s)
  } else if (t <= x_4) {
    # smooth transition bowl -> rim, using S^2
    z <- (t - x_3) / (x_4 - x_3)   # rescale to [0,1]
    s <- S(z)
    s2 <- s^2
    return(r_bowl * (1 - s2) + r_rim * s2)
  } else {
    return(0)
  }
}

#' @title Vectorized wrapper of r() for integration
#' @description Adapts r() to work with integrate(), which passes vector t.
#' @param t Numeric vector of heights.
#' @param ... Passed to r().
#' @return Numeric vector of radii.
#' @examples
#' r_vec_for_integrate(c(10, 11),
#'   x_1 = 1, x_2 = 5, x_3 = 10, x_4 = 15,
#'   r_foot = 5, r_stem = 1, r_bowl = 6, r_rim = 5)
#' @export
r_vec_for_integrate <- function(t, ...) {
  vapply(t, r, numeric(1), ...)
}
