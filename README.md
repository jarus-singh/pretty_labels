# pretty_labels

## Description
Frequently when charting in R using ggplot2, we want to clean up the numeric labels on our axes. We want to convey the magnitude as concisely as possible. The simple (and inelegant) pretty_labels() function below hopes to neatly print these breaks for a continuous scale that has positive values between 0 and 1 quintillion. I designed this when I found myself creating (and recreating) custom functions such as plot_in_thousands(), plot_in_millions(), plot_in_billions() and manually toggling between them for producing charts. This was particularly annoying when I was trying to automate series charting, for example, if I wanted to write a loop that charts individually a larger series' individual components. Some of these components would be in the thousands, whereas others would be in the millions. Using a static labelling function above would produce undesirable results such as "4050K" or "0.05M".

## Suggested Improvements
1. Ideally one would only have to call one function instead of pretty_labels() and then man_breaks(), and one would also not need to redefine the breaks in the ggpplot2 call, when I tried this, I would sometimes get an error that the number of breaks does not match the number of labels.
2. Handling of negative numbers (haven't tested this) and scientific notation for numbers smaller than 1.