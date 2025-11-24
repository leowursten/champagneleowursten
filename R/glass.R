#' @title Create a Glass Profile object
#' @description Minimal S3 class storing geometry of the champagne glass.
#'
#' @param a,b Numeric, lower and upper integration bounds (cm).
#' @param x_1,x_2,x_3,x_4 Breakpoints of the radius profile.
#' @param r_foot,r_stem,r_bowl,r_rim Radii of the different parts of the glass.
#'
#' @return An object of class Glass_Profile.
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

#' @export
radius_cone <- function(x, ...) UseMethod("radius_cone")

#' @export
volume_between <- function(x, ...) UseMethod("volume_between")


#' @title Radius at height t
#' @description S3 method for Glass_Profile class.
#' @param x A Glass_Profile object.
#' @param t Numeric height value.
#' @return The radius (cm) at height t.
#' @method radius_cone Glass_Profile
#' @export
radius_cone.Glass_Profile <- function(x, t, ...) {
  r(
    t,
    x$x_1, x$x_2, x$x_3, x$x_4,
    x$r_foot, x$r_stem, x$r_bowl, x$r_rim
  )
}


#' @title Volume of champagne between two heights
#' @description Computes volume using the disk method.
#' @param x A Glass_Profile object.
#' @param a,b Heights (cm).
#' @return Volume in cm³.
#' @method volume_between Glass_Profile
#' @export
volume_between.Glass_Profile <- function(x, a = x$a, b = x$b, ...) {

  integrand <- function(t) {
    (r_vec_for_integrate(
      t,
      x_1 = x$x_1, x_2 = x$x_2, x_3 = x$x_3, x_4 = x$x_4,
      r_foot = x$r_foot, r_stem = x$r_stem,
      r_bowl = x$r_bowl, r_rim = x$r_rim
    ))^2
  }

  res <- integrate(integrand, lower = a, upper = b)
  pi * res$value
}
