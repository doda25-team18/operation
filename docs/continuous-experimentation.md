# Continuous Experimentation Documentation: A4

## New Feature: accuracy score keeper
The proposed new feature is an accuracy score: compared to the base design that features no such statistic, 
this proposed accuracy score shows the number of correct and incorrect classifications made, 
as well as a percentage to show how many of the predictions were correct at the bottom of the SMS checker webpage. 

Our decision on whether to implement this feature or not will be based on the results of A/B testing, with:

- A: no accuracy score feature
- B: accuracy score feature

| Version | Name  | Goup | Description |
|---------|-------|------|-------------|
| v1 | Original | A | Accuracy score feature not displayed |
| v2 | Test | B | Accuracy score feature displayed |

## New metric

To test the impact of this feature, we will use a new "time_on_webpage" metric that records how long a user spends on said webpage. The "time_on_webpage" metric will be a gauge metric to show the average duration, in milliseconds, that a user spends on a webpage - this is the data that will be available in Grafana. 

## Hypothesis

It is our hypothesis that, with this feature, a user is likely to spend longer on the webpage as it makes more sense for them to
check a number of their predictions at the same time and have our app calculate the percentage that was correct for them.

## Decision Process

### Thought Process
This feature's goal is to provide the user with a convenient statistic. Thus, if we observe that group B spends noticably longer on our application than group A, this likely means that they are making use of the accuracy score feature, as this is the only change on the webpage and thus the only reason for a user to stay longer. Thus, if group B spends noticably longer on the webapge, then we will accept that the hypothesis is true - the feature is being used by the app's users, and implement the feature. 

### Decision Criteria
If we observe that the Test app's users spend 30% or more time on the application, we will assume there is sufficient grounds to assume the feature is being utilised and is therefore worth implementing.

### Steps
1. Observe user behaviour: this experiment will run for a total of 100 page loads - statistically, this should make for 90 Original app loads and 10 Test app loads.
2. Evaluate data: evaluate how long the users spent on average on the Original and Test webpages via the metric on Grafana
3. Make decision: the decision will be based solely on the previously specified criteria (see Decision Criteria)
