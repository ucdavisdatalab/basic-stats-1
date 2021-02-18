# Regression

Regression is a mathematical tool that allows you to estimate how some response variable is related to some predictor variable(s). There are methods that handle continuous or discrete responses of many different distributions, but we are going to focus on linear regression here.

Linear regression means that the relationship between the predictor variable(s) and the response is a linear one. To illustrate, we'll create a plot of the relationship between the waist measurement and bmi of 81 adults:


```r
# import the adipose body fat data file
adipose = read.csv( url("https://raw.githubusercontent.com/ucdavisdatalab/basic_stats_r_1/main/data/adipose.csv") )

# plot the relationship between the waist_cm and bmi variables
with(adipose, plot(waist_cm, bmi), bty='n' )
```

<img src="05_regression_files/figure-html/regression-example-1.png" width="672" />

The relationship between the two is apparently linear (you can imagine drawing a straight line through the data). The general mathematical form of a linear regression line is

$$ y = a + \beta x + \epsilon $$

Here, the response variable (e.g., BMI) is called $y$ and the predictor (e.g. waist measurement) is $x$. The coefficient $\beta$ indicates how much the response changes for a change in the predictors (e.g., the expected change in BMI with a 1cm change in waist measurement). Variable $a$ denotes the intercept, which is a constant offset that aligns the mean of $y$ with the mean of $x$. Finally, $\epsilon$ is the so-called residual error in the relationship. It represents the variation in the response that is not due to the predictor(s).


## Fitting a regression line
The R function to fit the model is called `lm()`. Let's take a look at an example:


```r
# fit the linear regression BMI vs waist_cm
fit = lm( bmi ~ waist_cm, data=adipose )

# plot the fitted regression: begin with the raw data
with( adipose, plot(waist_cm, bmi, bty='n') )

#now plot the fitted regression line (in red)
abline( coef(fit)[[1]], coef(fit)[[2]], col='red' )
```

<img src="05_regression_files/figure-html/bmi-vs-waist-regression-1.png" width="672" />

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
# linear model for BMI using waist size and height as predictors
fit2 = lm( bmi ~ waist_cm + stature_cm, data=adipose )

# plot the fitted versus the predicted values
plot( fit2$fitted.values, adipose$bmi, bty='n' )
```

<img src="05_regression_files/figure-html/bmi-waist-height-1.png" width="672" />

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

<img src="05_regression_files/figure-html/diagnostics-1.png" width="672" />

The "Residuals vs. Fitted" plot is checking whether the linear model is correct. There should be no obvious pattern if the data are linear (as is the casre here). The Scale-Location plot will have no obvios pattern if the variance of the residuals is constant, as is the case here (you might see a slight pattern in the smoothed red line but it isn't obvious). And the QQ plot will look like a straight line if the residuals are from a Normal distribution, as is the case here. So this model is good. The fourth diagnostic plot is the Residuals vs. Leverage plot, which is used to identify influential outliers. We won't get into that here.

## Functions for inspecting regression fits
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

Here you can see that the average marginal effect of one additional centimeter of waist measurement is to increase BMI by 0.3 and an additional centimeter of height is associated with a change to BMI of -0.08. You can get the coefficients from the fitted model object using the `coef()` function, and there are some other functions that allow you to generate the values shown in the summary table.


```r
# get the coefficients of the fitted regression
beta = coef( fit2 )
round( beta, 2 )
```

```
## (Intercept)    waist_cm  stature_cm 
##       14.38        0.30       -0.08
```


```r
# get the variance-covariance matrix
cat( "\nvariance-covariance matrix:\n" )
```

```
## 
## variance-covariance matrix:
```

```r
round( vcov( fit2 ), 4)
```

```
##             (Intercept) waist_cm stature_cm
## (Intercept)     14.6459  -0.0039    -0.0836
## waist_cm        -0.0039   0.0002    -0.0001
## stature_cm      -0.0836  -0.0001     0.0005
```


```r
# compare the square root of the diagonals of the variance-covariance matrix
# to the standard errors are reported in the summary table:
se = sqrt( diag( vcov(fit2) ))

cat( "\nstandard errors:\n")
```

```
## 
## standard errors:
```

```r
round( se, 3 )
```

```
## (Intercept)    waist_cm  stature_cm 
##       3.827       0.015       0.023
```


```r
# calculate the t-statistics for the regression coefficients
# (compare these to the t-statistics reorted in the summary table)
t_stats = beta / se

cat("\nt-statistics:\n")
```

```
## 
## t-statistics:
```

```r
round( t_stats, 2 )
```

```
## (Intercept)    waist_cm  stature_cm 
##        3.76       20.49       -3.54
```


```r
# calculate the p-values:
pval = 2 * pt( abs(t_stats), df=78, lower.tail=FALSE )
round(pval, 4)
```

```
## (Intercept)    waist_cm  stature_cm 
##       3e-04       0e+00       7e-04
```


```r
# this is the residual standard error:
sd( fit2$residuals ) * sqrt(80 / 78)
```

```
## [1] 1.72357
```

```r
# R-squared is the proportion of variance
# explained by the regression model
round( 1 - var(fit2$residuals) / var(adipose$bmi), 3 )
```

```
## [1] 0.844
```


## A model that fails diagnostics

We've seen a model that has good diagnostics. Now let's look at one that doesn't. This time, we'll use linear regression to make a model of the relationship between waist measurement and the visceral adipose tissue fat (measured in grams). The visceral adipose tissue fat is abbreviated `vat` in the data. First, since the model uses a single predictor variable, let's look at the relationship with a pair plot.


```r
# plot the relationship between waist_cm and vat
with( adipose, plot( waist_cm, vat, bty='n' ))
```

<img src="05_regression_files/figure-html/vat-plot-1.png" width="672" />

The plot is obviously not showing a linear relationship, which will violate one of the conditions for linear regression. Also, you can see that there is less variance of vat among the observations that have smaller waist measurements. So that will violate the assumption that the residual variance has no relationship to the fitted values. To see how these will show up in the diagnostic plots, we need to fit the linear regression model.


```r
# estimate the model for vat
fit_vat = lm( vat ~ waist_cm, data = adipose )

# there is no problem creating the summary table:
summary( fit_vat )
```

```
## 
## Call:
## lm(formula = vat ~ waist_cm, data = adipose)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -996.25 -265.96  -61.87  191.24 1903.46 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -3604.196    334.241  -10.78   <2e-16 ***
## waist_cm       51.353      3.937   13.04   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 479 on 79 degrees of freedom
## Multiple R-squared:  0.6829,	Adjusted R-squared:  0.6789 
## F-statistic: 170.2 on 1 and 79 DF,  p-value: < 2.2e-16
```

```r
# show the diagnostic plots
layout( matrix(1:4, 2, 2) )
plot( fit_vat )
```

<img src="05_regression_files/figure-html/vat-regression-diagnostics-1.png" width="672" />

There is obviously a curved pattern in the Residuals vs. Fitted plot, and in the Scale vs. Location plot. Residuals vs. Fitted shows a fan-shaped pattern, too, which reflects the increasing variance among the greater fitted values. The QQ plot is not a straight line, although the difference is not as obvious. In particular, the upper tail of residuals is heavier than expected. Together, all of these are indications that we may need to do a log transformation of the response. A log transformation helps to exaggerate the differences between smaller numbers (make the lower tail heavier) and collapse some difference among larger numbers (make the upper tail less heavy).


```r
# fit a regression model where the response is log-transformed
fit_log = lm( log(vat) ~ waist_cm, data=adipose )

# plot the diagnostics for the log-transformed model
plot( fit_log )
```

<img src="05_regression_files/figure-html/log-vat-1.png" width="672" /><img src="05_regression_files/figure-html/log-vat-2.png" width="672" /><img src="05_regression_files/figure-html/log-vat-3.png" width="672" /><img src="05_regression_files/figure-html/log-vat-4.png" width="672" />

The diagnostics do not look good after the log transformation, but now the problem is the opposite: a too-heavy lower tail and residual variance decreases as the fitted value increases. Perhaps a better transformation is something in between the raw data and the log transform. Try a square-root transformation.


```r
# fit a model where the vat is square root transformed
fit_sqrt = lm( sqrt(vat) ~ waist_cm, data=adipose )

# plot the diagnostics for the log-transformed model
plot( fit_sqrt )
```

<img src="05_regression_files/figure-html/vat-sqrt-1.png" width="672" /><img src="05_regression_files/figure-html/vat-sqrt-2.png" width="672" /><img src="05_regression_files/figure-html/vat-sqrt-3.png" width="672" /><img src="05_regression_files/figure-html/vat-sqrt-4.png" width="672" />
These look acceptable for real-world data.

## Predictions and variability

There are two scales of uncertainty for a regression model: uncertainty in the fitted relationship, and the uncertainty of a predicted outcome. The uncertainty of a prediction is always greater because it is calculated by adding the uncertainty of the fitted line to the uncertainty of a single data point around that fitted line. We can illustrate using the example of the model we just created to relate the waist measurement to the square root of vat. For this block of code, we'll need the `mvtnorm` library to be loaded.


```r
# import mvtnorm. install it if necessary.
library( mvtnorm )

# draw the data on the transformed scale
with( adipose, plot(waist_cm, sqrt(vat), bty='n') )

# plot the fitted regression line
abline( coef(fit_sqrt)[[1]], coef(fit_sqrt)[[2]], col='red' )

# plot 100 samples from the distributon of the regression line.
for (i in 1:100) {
  cc = rmvnorm( n=1, mean=coef(fit_sqrt), sigma=vcov(fit_sqrt) )
  abline( cc[[1]], cc[[2]], col=grey(0.8))
}
```

<img src="05_regression_files/figure-html/predictions-1.png" width="672" />

Clearly, the variability of the data points is greater than the variability of the fitted line (that's why they lie outside the envelope of the fitted lines). We can extract a confidence interval for fitted values or predictions with the `predict()` function.


```r
# draw the data on the transformed scale
with( adipose, plot(waist_cm, sqrt(vat), bty='n') )

# plot the fitted regression line
abline( coef(fit_sqrt)[[1]], coef(fit_sqrt)[[2]], col='red' )

pred_pts = data.frame( waist_cm = c(70, 85, 110) )

ff = predict(fit_sqrt, pred_pts, interval="confidence", level=0.9)
pp = predict(fit_sqrt, pred_pts, interval="prediction", level=0.9)

ff = as.data.frame(ff)
pp = as.data.frame(pp)

for (i in 1:3) {
  lines( x=rep( pred_pts$waist_cm[[i]] - 0.5, 2),
        y=c( ff$lwr[[i]], ff$upr[[i]] ), col='blue', lwd=2 )

  lines( x=rep( pred_pts$waist_cm[[i]] + 0.5, 2),
        y=c( pp$lwr[[i]], pp$upr[[i]] ), col='orange', lwd=2 )
}

legend(c("90% CI (fitted values)", "90% CI (predicted values)"),
       x="topleft", lwd=2, col=c("blue", "orange"), bty='n')
```

<img src="05_regression_files/figure-html/prediction-intervals-1.png" width="672" />

One thing to notice about the confidence intervals is that the interval is smallest (so the precision of the estimation is greatest) at the mean of the predictor variable. This is a general rule of fitting regression.
