# Regression

Regression is a mathematical tool that allows you to estimate how some response variable is related to some predictor variable(s). There are methods that handle continuous or discrete responses of many different distributions, but we are going to focus on linear regression here.

Linear regression means that the relationship between the predictor variable(s) and the response is a linear one. To illustrate, we'll create a plot of the relationship between the waist measurement and bmi of 81 adults:


```r
# import the adipose body fat data file
adipose = read.csv( url("https://raw.githubusercontent.com/ucdavisdatalab/basic_stats_r_1/main/data/adipose.csv") )

# plot the relationship between the waist_cm and bmi variables
with(adipose, plot(waist_cm, bmi), bty='n' )
```

<img src="04_regression_files/figure-html/regression-example-1.png" width="672" />

The relationship between the two is apparently linear (you can imagine drawing a straight line through the data). The general mathematical form of a linear regression line is

$$ y = a + \beta x + \epsilon $$

Here, the response variable (e.g., BMI) is called $y$ and the predictor (e.g. waist measurement) is $x$. The coefficient $\beta$ indicates how much the response changes for a change in the predictors (e.g., the expected change in BMI with a 1cm change in waist measurement). Variable $a$ denotes the intercept, which is a constant offset that aligns the mean of $y$ with the mean of $x$. Finally, $\epsilon$ is the so-called residual error in the relationship. It represents the variation in the response that is not due to the predictor(s).

The R function to fit the model is called `lm()`. Let's take a look at an example:


```r
# fit the linear regression BMI vs waist_cm
fit = lm( bmi ~ waist_cm, data=adipose )

# plot the fitted regression: begin with the raw data
with( adipose, plot(waist_cm, bmi, bty='n') )

#now plot the fitted regression line (in red)
abline( coef(fit)[[1]], coef(fit)[[2]], col='red' )
```

<img src="04_regression_files/figure-html/bmi-vs-waist-regression-1.png" width="672" />

## Assumptions and diagnostics
"Fitting" a linear regression model involves estimating $a$ and $\beta$ in the regression equation. You can can do this fitting procedure using any data, but the results won't be reliable unless some conditions are met. The conditions are:

1. Observations are independent.
2. The linear model is correct.
3. The residual error is Normally distributed.
4. The variance of the residual error is constant for all observations.

The first of these conditions can't be checked - it has to do with the design of the experiment. The rest can be checked, though, and I'll take them in order.

### Checking that the linear model is correct
In the cast of a simple linear regression model (one predictor variable), you can check this by plotting the predictor against the response and looking for a linear trend. If you have more than one predictor variable, then you need to plot the predictions against the response to look for a linear trend. We'll see an example by adding height as a predictor for BMI (in addition to waist measurement).


```r
# create a linear model for BMI that uses waist size and height as predictors
fit2 = lm( bmi ~ waist_cm + stature_cm, data=adipose )

# plot the fitted versus the predicted values
plot( fit2$fitted.values, adipose$bmi, bty='n' )
```

<img src="04_regression_files/figure-html/bmi-waist-height-1.png" width="672" />

### Checking that the residuals are normally distributed
We have already learned about the QQ plot, which shows visually whether some values are Normally distributed. In order to depend upon the fit from a linear regression model, we need to see that the residuals are Normally distributed, and we use the QQ plot to check.


### Checking that the vaiance is constant
In an earlier part, we saw that the variance is the average of the squared error. But that would just be a single number, when we want to see if there is a trend. So like the QQ plot, you'l plot the residuals and use your eyeball to discern whether there is a trend in the residuals or if they are approximately constant - this is called the scale-location plot. The QQ plot and scale-location plot are both created by plotting the fitted model object


```r
# set up the pattern of the panels
layout( matrix(1:4, 2, 2) )

# make the diagnostic plots
plot( fit )
```

<img src="04_regression_files/figure-html/diagnostics-1.png" width="672" />

The "Residuals vs. Fitted" plot is checking whether the linear model is correct. There should be no obvious pattern if the data are linear (as is the casre here). The Scale-Location plot will have no obvios pattern if the variance of the residuals is constant, as is the case here (you might see a slight pattern in the smoothed red line but it isn't obvious). And the QQ plot will look like a straight line if the residuals are from a Normal distribution, as is the case here. So this model is good. The fourth diagnostic plot is the Residuals vs. Leverage plot, which is used to identify influential outliers. We won't get into that here.

## The `summary()` function
When you fit a linear regression model, you are estimating the parameters of the regression equation. In order to see those estimates, use the `summary()` function on the fitted model object.


```r
# get the model summary
summary( fit2 )
```

```
## 
## Call:
## lm(formula = bmi ~ waist_cm + stature_cm, data = adipose)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -4.1290 -1.0484 -0.2603  1.2661  5.2572 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 14.38196    3.82700   3.758 0.000329 ***
## waist_cm     0.29928    0.01461  20.491  < 2e-16 ***
## stature_cm  -0.08140    0.02300  -3.539 0.000680 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.724 on 78 degrees of freedom
## Multiple R-squared:  0.844,	Adjusted R-squared:   0.84 
## F-statistic:   211 on 2 and 78 DF,  p-value: < 2.2e-16
```

Here you can see that the average marginal effect of one additional centimeter of waist is to increase BMI by 0.3 and an additional centimeter of height is associated with a change to BMI of -0.08.

## A model that fails diagnostics

We've seen a model that 



