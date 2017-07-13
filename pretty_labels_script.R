# Description:
# Frequently when charting in R using ggplot2, we want to clean up the numeric labels on our axes.
# We want to convey the magnitude as concisely as possible.
# The simple (and inelegant) pretty_labels()
# function below hopes to neatly print these breaks for a continuous
# scale that has positive values between 0 and 1 quintillion. I designed this
# when I found myself creating (and recreating) custom functions such as
# plot_in_thousands(), plot_in_millions(), plot_in_billions() and manually toggling
# between them for producing charts. This was particularly annoying when I was
# trying to automate series charting, for example, if I wanted to write a loop
# that charts individually a larger series' individual components. Some of these components
# would be in the thousands, whereas others would be in the millions. Using a static
# labelling function above would produce undesirable results such as "4050K" or
# "0.05M".

# Examples:
# pretty_labels(man_breaks(c(100, 200, 300, 400, 500)))
# "100" "200" "300" "400" "500"

# pretty_labels(man_breaks(c(1000, 2000, 3000, 4000, 5000)))
# "1K" "2K" "3K" "4K" "5K"

# pretty_labels(man_breaks(c(1000, 1100, 1200, 1300, 1400)))
# "1.0K" "1.1K" "1.2K" "1.3K" "1.4K"

# pretty_labels(man_breaks(c(1000000, 2000000, 3000000, 4000000, 5000000)))
# "1M" "2M" "3M" "4M" "5M"

# pretty_labels(man_breaks(c(1000000, 2000000, 3000000, 4000000, 5000000,
#                            6000000, 7000000, 8000000, 9000000, 10000000)))
# "0M" "2.5M" "5M" "7.5M" "10M"

# Example in the ggplot2 wild:
# library(ggplot2)
# worldphones <- as.data.frame(WorldPhones)
# ggplot(worldphones, aes(x = Europe, y = Asia)) +
#   geom_point() +
#   scale_x_continuous(breaks = man_breaks(worldphones$Europe),
#                      labels = pretty_labels(man_breaks(worldphones$Europe))) +
#   scale_y_continuous(breaks = man_breaks(worldphones$Asia),
#                      labels = pretty_labels(man_breaks(worldphones$Asia)))

# Recreates breaks manually
man_breaks <- function(x, .m = 5) {
  labeling::extended(min(x),
                     max(x),
                     m = .m) # m = 5 is the default in ggplot2
}

# Note that x is a numeric array as passed in from man_breaks
pretty_labels <- function(x) {
  # Finds max value of x
  maxx <- max(x)
  
  # Finds difference between first two values of x
  # which should be the difference between any two breaks
  diff <- x[2] - x[1]
  
  log_diff <- floor(log10(diff))
  
  if (max(x) < 1000) {
    output <- as.character(x)
  } else if (maxx < 1000000) {
    if (log_diff > 3) {
      .nsmall <- 0
    } else {
      .nsmall <- 3 - log_diff
    }
    
    output <- paste0(prettyNum(x / 1000, nsmall = 3 - log_diff), "K")
  } else if (maxx < 1000000000) {
    if (log_diff > 6) {
      .nsmall <- 0
    } else {
      .nsmall <- 6 - log_diff
    }
    
    output <- paste0(prettyNum(x / 1000000, nsmall = .nsmall), "M")
  } else if (maxx < 1000000000000) {
    if (log_diff > 9) {
      .nsmall <- 0
    } else {
      .nsmall <- 9 - log_diff
    }
    
    output <- paste0(prettyNum(x / 1000000000, nsmall = 9 - log_diff), "B")
  } else if (maxx < 1000000000000000) {
    if (log_diff > 12) {
      .nsmall <- 0
    } else {
      .nsmall <- 12 - log_diff
    }
    
    output <- paste0(prettyNum(x / 1000000000000, nsmall = 12 - log_diff), "T")
  } else if (maxx < 1000000000000000000) {
    if (log_diff > 15) {
      .nsmall <- 0
    } else {
      .nsmall <- 15 - log_diff
    }
    
    output <- paste0(prettyNum(x / 1000000000000000, nsmall = 15 - log_diff), "Q")
  }
  
  output
}

# Suggested Improvements:
# -Ideally one would only have to call one function instead of pretty_labels()
# and then man_breaks(), and one would also not need to redefine the breaks
# in the ggpplot2 call, when I tried this, I would sometimes get an error
# that the number of breaks does not match the number of labels.
# -Handling of negative numbers (haven't tested this) and scientific notation
# for numbers smaller than 1.