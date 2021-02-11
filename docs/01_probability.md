# Probability
One might reasonably think of statistics as applied probability. So we need to be familiar with a bit f probability theory. 

## Random variables and calculations:
A random variable is our name for some quantity that follows a random distribution. Examples:


```r
# X is a random variable, it follows the sandard normal distribution
X = rnorm(1)

# Once we have "realized" a value of X, it is data and no longer random.
X
```

```
## [1] 0.9765284
```


### Mean and median
There are a few kinds of average that are commonly used in practical settings and we will use two of them extensively. The mean is the average you're probably used to, calculated by summing up the values and then dividing by the number of values. The median is the midpoint of the data - it's the number you arrive at if you write down all the values in order and then find the halfway point. There are special R functions for both of these.


```r
x = rnorm(10)
mean(x)
```

```
## [1] 0.05122366
```

```r
median(x)
```

```
## [1] 0.1650272
```

### Expectation
Expectation is the mean of a population. So, a random variable has an expectation but data has a mean. There's no R function to calculate an expectation because R expects to be working on data rather than on a population. If you think of R as a calculator, you can calculate the mean of any numbers that you can type into the calculator, but when the object is this abstract thing we call a distribution, the calculator can't proceed.

Denote the expectation of the random variable $X$ by $E(X)$. Typically, statisticians use the Greek letter $\mu$ to mean the expectation of a Normal random variable.

### Variance
Our concept of variance comes about because of the need for a calculation that measures the typical difference between data points. In fact, we call that typical distance the *standard deviation*, and it is the square root of the variance. The formulas are 

$$\text{var}(x) = \frac{\sum_{i=1}^n (x_i - \bar{x})^2}{n-1}$$

$$ \text{sd}(x) = \sqrt{ \text{var}(x) } $$

For a Normal distribution, statisticians typically denote the population variance by the Greek letter $\sigma^2$. 

## Some distributions

### Normal distribution
The Normal distribution is very commonly encountered in statistics, and plays a very special role. It's the famous "bell-curve", and is characterized by a mean $\mu$ and standard deviation $\sigma$ (variance is therefore $\sigma^2$). We statisticians tend to abbreviate this Normal distribution by $N(\mu, \sigma^2)$. There is a special distribution where the mean is zero and the standard deviation is one, which we call the **standard Normal** distribution or $N(0, 1)$.

#### Distribution function
I have referred to a distribution without defining what that is. A distribution is a measure of how probability is distributed among events. We also use the term to mean a particular function, called the "distribution function", which calculates the probability that a random variable is less than or equal to some number. Or, $F_X(t) = Pr(X \le t)$. In more concrete terms, we can do the calculation in R:


```r
# Demonstrate the standard normal distribution function:
pnorm(0)
```

```
## [1] 0.5
```

```r
pnorm(-1)
```

```
## [1] 0.1586553
```

```r
pnorm(1)
```

```
## [1] 0.8413447
```

```r
# draw the standard normal distribution function, with some annotations
t = seq(-4, 4, length.out=1001)
plot( x=t, y=pnorm(t), bty='n', type='line', main="standard normal distribution function")
```

```
## Warning in plot.xy(xy, type, ...): plot type 'line' will be truncated to first
## character
```

```r
# annotate the plot with lines indicating the quantiles for a 95% probability interval
lines(x=c(min(t), qnorm(0.025)), y=rep(0.025, 2), lty=2)
lines(x=c(min(t), qnorm(0.975)), y=rep(0.975, 2), lty=2)

lines(x=rep(qnorm(0.025), 2), y=c(0, 0.025), lty=3)
lines(x=rep(qnorm(0.975), 2), y=c(0, 0.975), lty=3)
```

<img src="01_probability_files/figure-html/unnamed-chunk-3-1.png" width="672" />

You can also see some non-normal distribution functions, in order to see the differences:

```r
plot( x=t, y=ppois(t, lambda=1), bty='n', type='line', main="Poisson(1) distribution function")
```

```
## Warning in plot.xy(xy, type, ...): plot type 'line' will be truncated to first
## character
```

<img src="01_probability_files/figure-html/unnamed-chunk-4-1.png" width="672" />

```r
plot( x=t, y=pchisq(t, df=2), bty='n', type='line', main="Chi-squared (df=7) distribution function")
```

```
## Warning in plot.xy(xy, type, ...): plot type 'line' will be truncated to first
## character
```

<img src="01_probability_files/figure-html/unnamed-chunk-4-2.png" width="672" />

#### Density function
You might be surprised that the distribution function isn't the famous "bell curve", but that is the **probability density function**. Density here may be thought of as being like densiy of mass. And because it is probability density, it must add up to one in the end. Density of a standard normal distribution is calculated by the `dnorm` function, and is the rate of change of the distribution function. Here I've shaded area under the standard normal density that adds up to 0.05, or 5%. Thus, the unshaded area under the curve is 0.95. In other words, a standard normal random variable has its value 95% of the time between -1.96 and 1.96.


```r
# Demonstrate the standard normal density function:
dnorm(0)
```

```
## [1] 0.3989423
```

```r
dnorm(-1)
```

```
## [1] 0.2419707
```

```r
dnorm(1)
```

```
## [1] 0.2419707
```

```r
# plot the standard normal density function with some annotations
t = seq(-3, 3, length.out=1001)
plot( x=t, y=dnorm(t), bty='n', type='l', main="standard normal density")

# annotate the density function with the 5% probability mass tails
polygon(x=c(t[t<=qnorm(0.025)], qnorm(0.025), min(t)), y=c(dnorm(t[t<=qnorm(0.025)]), 0, 0), col=grey(0.8))

polygon(x=c(t[t>=qnorm(0.975)], max(t), qnorm(0.975)), y=c(dnorm(t[t>=qnorm(0.975)]), 0, 0), col=grey(0.8))
```

<img src="01_probability_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Again, the density function exists for other distributions than the normal.

```r
# plot the poisson and chi-squared probability densities
plot( x=t, y=dunif(t), bty='n', type='l', main="Uniform(0, 1) distribution function")
```

<img src="01_probability_files/figure-html/unnamed-chunk-6-1.png" width="672" />

```r
plot( x=t, y=dchisq(t, df=2), bty='n', type='l', main="Chi-squared (df=7) distribution function")
```

<img src="01_probability_files/figure-html/unnamed-chunk-6-2.png" width="672" />

#### Quantile function
There is one more commonly used function of a distribution: its quantile function. This is an inverse of the distribution function: it maps from the 0-1 range back to the possible values of the distribution. This becomes useful for answering questions like, "what is the cutoff that a standard normal random variable falls below 95% of the time?"


```r
# demonstrate quantiles of the standard normal distribution
qnorm(0.95)
```

```
## [1] 1.644854
```

```r
qnorm(0.5)
```

```
## [1] 0
```

```r
# if you want an interval that contains the random variable 95% of the time, you may divide the remaining 5% in half, so the interval is in the center:
(1 - 0.95) / 2
```

```
## [1] 0.025
```

```r
qnorm(0.025)
```

```
## [1] -1.959964
```

```r
qnorm(0.975)
```

```
## [1] 1.959964
```

