#' @title Create a champagne glass profile
#' @description Constructor for objects of class \code{Glass_Profile},
#'   storing geometry parameters of the champagne glass.
#' @param a,b Numeric lower and upper levels where champagne is considered.
#' @param x_1,x_2,x_3,x_4 Breakpoints along the glass axis.
#' @param r_foot,r_stem,r_bowl,r_rim Radii (in cm) for foot, stem, bowl and rim.
#' @return An object of class \code{"Glass_Profile"}.
#' @examples
#' glass <- GlassProfile(
#'   a = 12.6, b = 22.5,
#'   x_1 = 1.1, x_2 = 12.6, x_3 = 18.8, x_4 = 22.5,
#'   r_foot = 5.8, r_stem = 0.25, r_bowl = 7.5, r_rim = 7
#' )
#' @export
GlassProfile <- function(a, b,
                         x_1, x_2, x_3, x_4,
                         r_foot, r_stem, r_bowl, r_rim) {
  structure(
    list(
      a      = a,
      b      = b,
      x_1    = x_1,
      x_2    = x_2,
      x_3    = x_3,
      x_4    = x_4,
      r_foot = r_foot,
      r_stem = r_stem,
      r_bowl = r_bowl,
      r_rim  = r_rim
    ),
    class = "Glass_Profile"
  )
}

#' @title Radius at a given level
#' @description Generic and method for champagne glass profiles.
#' @param x A Glass_Profile object.
#' @param t Numeric level along the glass axis.
#' @param ... Further arguments (currently unused).
#' @return Numeric radius at level \code{t}.
#' @examples
#' glass <- GlassProfile(
#'   a = 12.6, b = 22.5,
#'   x_1 = 1.1, x_2 = 12.6, x_3 = 18.8, x_4 = 22.5,
#'   r_foot = 5.8, r_stem = 0.25, r_bowl = 7.5, r_rim = 7
#' )
#' radius_cone(glass, t = 14)
#' @export
radius_cone <- function(x, ...) UseMethod("radius_cone")

#' @rdname radius_cone
#' @export
radius_cone.Glass_Profile <- function(x, t, ...) {
  r(
    t,
    x$x_1, x$x_2, x$x_3, x$x_4,
    x$r_foot, x$r_stem, x$r_bowl, x$r_rim
  )
}

#' @title Volume between two levels
#' @description Compute champagne volume between fill levels \code{a} and \code{b}.
#' @param x A Glass_Profile object.
#' @param a,b Lower and upper fill levels.
#' @param ... Further arguments (currently unused).
#' @return Numeric volume in cubic centimetres.
#' @examples
#' glass <- GlassProfile(
#'   a = 12.6, b = 22.5,
#'   x_1 = 1.1, x_2 = 12.6, x_3 = 18.8, x_4 = 22.5,
#'   r_foot = 5.8, r_stem = 0.25, r_bowl = 7.5, r_rim = 7
#' )
#' volume_between(glass)
#' @export
volume_between <- function(x, ...) UseMethod("volume_between")

#' @rdname volume_between
#' @export
volume_between.Glass_Profile <- function(x, a = x$a, b = x$b, ...) {
  integrand <- function(t) {
    (r_vec_for_integrate(t, x))^2
  }
  res <- integrate(integrand, lower = a, upper = b)
  pi * res$value
}
