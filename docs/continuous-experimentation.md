# Experimentation Documentation: A4

## New Feature: accuracy score keeper
The proposed new feature is an accuracy score: compared to the base design that features no such statistic, 
this proposed accuracy score shows the number of correct and incorrect classifications made, 
as well as a percentage to show how many of the predictions were correct at the bottom of the SMS checker webpage. 

In the base design, the app-service simply displayed prediction results without tracking user interaction.
In the experimental version (app-service v2), we introduced a new accuracy score component that counts correct and incorrect predictions and displays a running accuracy percentage.
The corresponding model-service v2 includes a modified response format that returns additional metadata enabling the app-service to update the accuracy tracker.

To test the impact of this feature, we will use a new "time_on_webpage" metric that records how long a user spends on said webpage. 
It is our hypothesis that, with this feature, a user is likely to spend longer on the webpage as it makes more sense for them to
check a number of their predictions at the same time and have our app calculate the percentage that was correct for them.
The "time_on_webpage" metric will be a gauge metric to show the average duration, in milliseconds, that a user spends on a webpage - this is the data that will 
be available in Grafana. 

Our decision on whether to implement this feature or not will be based on the results of A/B testing, with:

- A: no accuracy score feature
- B: accuracy score feature

If we observe that group B spends noticably longer on our application than group A, this likely means that they are making use of the accuracy score feature,
as this is the only change on the webpage and thus the only reason for a user to stay longer. Thus, if group B spends noticably longer on the webapge, then we
will accept that the hypothesis is true - the feature is being used by the app's users, and implement the feature. 

The continuous experimentation setup allows us to evaluate the impact of the accuracy score feature in a controlled and observable way. With consistent routing, clear metrics, and a decision rule based on Grafana visualizations, we can make an evidence-based decision about whether to roll out the feature system-wide.