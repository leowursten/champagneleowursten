#' Smooth easing function S
#'
#' This function implements a cosine-based easing that smoothly goes
#' from 0 to 1 as t increases from 0 to 1.
#'
#' @param t Numeric scalar, typically between 0 and 1.
#' @return Numeric scalar between 0 and 1.
#' @export
S <- function(t) 0.5 - 0.5 * cos(pi * t)

#' Piecewise radius function for the champagne glass
#'
#' @param t Position along the horizontal axis.
#' @param x_1,x_2,x_3,x_4 Breakpoints.
#' @param r_foot,r_stem,r_bowl,r_rim Radii of the different parts (cm).
#' @return Radius at position t (cm).
#' @export
r <- function(t, x_1, x_2, x_3, x_4,
              r_foot, r_stem, r_bowl, r_rim) {

  # force t to be scalar
  t <- t[1]

  if (t < 0) {
    return(0)
  } else if (t < x_1) {
    return(r_foot)
  } else if (t < x_2) {
    return(r_stem)
  } else if (t < x_3) {
    # smooth transition stem -> bowl
    z <- (t - x_2) / (x_3 - x_2)
    s <- S(z)
    return(r_stem * (1 - s) + r_bowl * s)
  } else if (t <= x_4) {
    # smooth transition bowl -> rim, via S^2
    z <- (t - x_3) / (x_4 - x_3)
    s <- S(z)
    s2 <- s^2
    return(r_bowl * (1 - s2) + r_rim * s2)
  } else {
    return(0)
  }
}

#' Vectorised wrapper for integrate()
#'
#' @param t Numeric vector of positions.
#' @param x A Glass_Profile object.
#' @return Numeric vector of radii.
#' @export
r_vec_for_integrate <- function(t, x) {
  vapply(
    t,
    function(tt) {
      r(
        tt,
        x$x_1, x$x_2, x$x_3, x$x_4,
        x$r_foot, x$r_stem, x$r_bowl, x$r_rim
      )
    },
    numeric(1)
  )
}
