# Continuous Experimentation Documentation: A4

## New Feature: accuracy score
The proposed new feature is an accuracy score: compared to the base design that features no such statistic, this proposed accuracy score shows the number of correct and incorrect classifications made, as well as a percentage to show how many of the predictions were correct at the bottom of the SMS checker webpage. 

Our decision on whether to implement this feature or not will be based on the results of A/B testing, with:

| Version | Name  | Goup | Description |
|---------|-------|------|-------------|
| v1 | Stable | A | Accuracy score feature not displayed |
| v2 | Canary | B | Accuracy score feature displayed |

## Metric used

To test the impact of this feature, we will use the "num_predictions" metric with an applied rate interval function. This value, plotted as a line chart with the rate on the y-axis and time on the x-axis, will show whether requests are made back-to-back on the website or there are larger intervals between the requests being made.

## Hypothesis

It is our hypothesis that, with this feature, a user is likely to make more requests within a shorter timeframe on the webpage as it makes more sense for them to check a number of their predictions at the same time and have our app calculate the percentage that was correct for them.

## Decision Process

### Thought Process
This feature's goal is to provide the user with a convenient statistic. Thus, if we observe that group B (Canary version) makes more back-to-back requests on our application than group A (Stable version), this likely means that they are making use of the accuracy score feature, as this is the only change on the webpage and thus the only reason for a user to stay longer. Thus, if group B spends noticably longer on the webapge, then we will accept that the hypothesis is true - the feature is being used by the app's users, and implement the feature. 

### Decision Criteria
We will observe how many "peaks" our graph has, as each peak in our graph shows an instance of a user sending a request via the website. If we count 1.5x as many peaks on the Canary version with the average of those peaks being higher, we will assume there is sufficient grounds to assume the feature is being utilised and is therefore worth implementing.

### Steps
1. Observe user behaviour: this experiment will run 24 hours.
2. Evaluate data: evaluate teh graphs present on Grafana
3. Make decision: the decision will be based solely on the previously specified criteria (see Decision Criteria)
