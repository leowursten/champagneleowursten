champagneleowursten

A small R package for modeling champagne glasses, weather conditions, and party simulations

This package provides reusable tools for Homework 3 of the Data Management course. It implements: • A geometric model of a champagne glass (radius function + volume calculation) • A weather class with access to temperature, humidity, and pressure • A model linking weather to expected attendance • A full party simulation engine (guests, drinks, poured volume, bottles needed)

The goal is to make the analysis reproducible, modular, and packaged like a real analytics tool.

Installation

You can install the package directly from GitHub:

``` r
install.packages("devtools")
devtools::install_github("leowursten/champagneleowursten")
```

Load the package:

``` r
library(champagneleowursten)
```

Main features

1.  Glass geometry

The package defines: • The easing function S(t) • The piecewise radius function r(t) • A Glass_Profile class with: • radius_cone() • volume_between() (via numerical integration)

Weather model

The package contains a lightweight City_Weather class with: • temperature (°C) • humidity (%) • pressure (hPa)

Plus a link function:

``` r
expected_lambda(city_weather)
```

which converts weather conditions into an expected number of guests.

Party simulation engine

Simulate complete parties using:

``` r
simulate_party(city_name, data, glass)
```

This generates: • number of guests • number of glasses • total liters poured • number of bottles needed

for multiple Monte-Carlo simulations.

Processed dataset

Processed weather data is included as processed_data, located in:

``` r
data/processed_data.rda
```

and documented in:

``` r
R/processed_data_documentation.R
```

Vignette

A full tutorial demonstrating the package is available:

``` r
vignette("champagneleowursten")
```

Tests

The package includes automated tests using testthat:

``` r
devtools::test()
```

CI / Deployment

GitHub Actions automatically run: • R CMD check • build • tests

on macOS, Windows, and Ubuntu.

A green ✓ indicates the package is valid and buildable.

## Documentation website (pkgdown)

A pkgdown site is configured and can be built locally with:

``` R
## Documentation website (pkgdown)

A pkgdown site is configured and can be built locally with:

```r
pkgdown::build_site()
```

Because the repository is private, the website is not published via GitHub Pages,

but the HTML documentation is available locally in the docs/ folder after building.
