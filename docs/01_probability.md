# Probability distributions, quantiles, and densities
Probability distributions are functions that divvy up probability among the possible outcomes of a random variable. Each distribution has some important features, like its density and quantile functions.

## The Normal distribution
The Normal distribution plays a very special role in statistics, which we will come to. For now, let's introduce the distribution. I've pictured here the density of a standard normal distribution.  


```r
# draw the standard normal distribution function, with some annotations
t = seq(-4, 4, length.out=1001)
plot( x=t, y=dnorm(t), bty='n', type='line', main="standard normal density")
```

```
## Warning in plot.xy(xy, type, ...): plot type 'line' will be truncated to first
## character
```

```r
abline(v=0, lty=3)
```

<img src="01_probability_files/figure-html/normal-density-raw-1.png" width="672" />

The probability density is called that because if you select a sample from the distribution, most of the numbers in your sample will be from the part of the curve with the greatest density. The Normal distribution, like any named distribution, represents a population from which samples can be taken. Let's try it:


```r
# sample 20 numbers from a standard normal distribution:
x = rnorm(20)

# observe your sample:
print( round(x, 2) )
```

```
##  [1] -0.34 -0.58  0.10  2.02 -0.84  0.53  1.08 -0.57 -1.24 -0.39  1.94 -1.02
## [13] -1.45 -0.17  0.18 -0.12 -0.34 -0.17 -0.36 -0.33
```

Do the numbers seem to come from the high-density part of the Normal density curve? Are there any that don't? Most of the samples you've just taken should be It isn't surprising if some of your `x` samples are not particularly close to zero. One out of twenty (that's five percent) samples from a standard Normal population are greater than two or less than negative two, on average. That's "on average" over the population. Your sample may be different.


```r
# plot the standard normal density function with some annotations
plot( x=t, y=dnorm(t), bty='n', type='l', main="standard normal density")

# annotate the density function with the 5% probability mass tails
polygon(x=c(t[t<=qnorm(0.025)], qnorm(0.025), min(t)), y=c(dnorm(t[t<=qnorm(0.025)]), 0, 0), col=grey(0.8))

polygon(x=c(t[t>=qnorm(0.975)], max(t), qnorm(0.975)), y=c(dnorm(t[t>=qnorm(0.975)]), 0, 0), col=grey(0.8))
```

<img src="01_probability_files/figure-html/annotated-density-tails-1.png" width="672" />


### Histograms and subsamples
While the density curve represents the standard Normal population, your data's histogram represents your sample:


```r
# show the histogram of x
hist(x)
```

<img src="01_probability_files/figure-html/normal-histogram-1.png" width="672" />

It might not look particularly like the Normal density, but that's because it's representing a particular sample, not the population. The curve might be more recognizable if the number of samples was greater.


```r
# sample 200 numbers from a standard normal
y = rnorm( 200 )

# show the histogram of y
hist( y )
```

<img src="01_probability_files/figure-html/normal-histogram-more-data-1.png" width="672" />

Now, while I've said that the histogram represents a sample rather than a population, that line can be blurred. You can **subsample** from your sample, using the `sample` function. There are some situations when you're not working with a named distribution, but need to take samples from a list. This is how to do that.


```r
# take a sample of 20 numbers from x (without replacement)
x2 = sample( x, 20 )

# take a sample of 20 numbers from x (with replacement)
x3 = sample( x, 20, replace=TRUE )

# calculate the means of x, x2, and x3
mean( x )
```

```
## [1] -0.1043431
```

```r
mean( x2 )
```

```
## [1] -0.1043431
```

```r
mean( x3 )
```

```
## [1] 0.09970288
```

Because `x2` was sampled without replacement, it is exactly the same as `x`, but `x3` was sampled with replacement and has a different mean.

## Random variables and calculations:
A random variable is our name for an abstract observation from a population.

### Mean and median
There are a few kinds of average that are commonly used in practical settings and we will use two of them extensively. The mean is the average you're probably used to, calculated by summing up the values and then dividing by the number of values. The median is the midpoint of the data - it's the number you arrive at if you write down all the values in order and then find the halfway point. There are special R functions for both of these.


```r
# calculate the mean and median of x. They aren't exactly zero in the sample.
mean(x)
```

```
## [1] -0.1043431
```

```r
median(x)
```

```
## [1] -0.3333029
```

### Expectation
Expectation is the mean of a population. So, a random variable has an expectation but data has a mean. There's no R function to calculate an expectation because R expects to be working on data rather than on a population. If you think of R as a calculator, you can calculate the mean of any numbers that you can type into the calculator, but when the object is this abstract thing we call a distribution, the calculator can't proceed.

Remember earlier, when we decided to treat a sample as a population and then take samples from it? Then the mean of the original sample becomes the expectation of all the subsamples:


```r
# subsample x 50 times with replacement, and store the mean of each
subx_mean = numeric( 50 )
for (i in 1:50) {
  subx_mean[[ i ]] = mean( sample(x, replace=TRUE) )
}

# print the results and the mean of the means
print( round( subx_mean, 2 ) )
```

```
##  [1] -0.30 -0.19 -0.12 -0.23  0.32 -0.07 -0.08 -0.38  0.09  0.23 -0.26 -0.17
## [13]  0.02 -0.11  0.01 -0.02 -0.45  0.24  0.06  0.01 -0.34 -0.29  0.15  0.26
## [25] -0.28 -0.18 -0.14 -0.13 -0.02 -0.41 -0.19  0.09  0.03  0.18  0.12  0.10
## [37] -0.03 -0.23 -0.15  0.06 -0.30  0.07 -0.32  0.01 -0.22 -0.26 -0.43  0.07
## [49] -0.17 -0.36
```

```r
mean( subx_mean )
```

```
## [1] -0.09522708
```

```r
# shoe the histogram of sample means, with an annotation at the expectation
hist( subx_mean )
abline( v=mean(x), lty=3 )
```

<img src="01_probability_files/figure-html/subsampe-expectation-1.png" width="672" />

You might have noticed that I didn't specify the `size` argument for the `sample()` function that time. By default, `sample()` will take a subsample of equal size to the input data. You can see from the above histogram that sample means are clustering around the population expectation, even though they don't match exactly.

Denote the expectation of the random variable $X$ by $E(X)$. Typically, statisticians use the Greek letter $\mu$ to mean the expectation of a Normal random variable.

### Standard deviation and variance
The standard deviation comes about because of the need for a calculation that measures how far a typical sample is from the mean. The direct approach would be to calculate the average distance from the mean, but it turns out that this is always exactly zero. So instead, we've settled on the standard of calculating the average squared distance from the mean (almost). Here is the formula for the sample standard deviation, which we write as $s$ for a particular sample or $S$ for a random variable:

$$ s = \text{sd}(x) = \sqrt{ \frac{\sum_{i=1}^n (x_i - \bar{x})^2}{n-1} }$$

The `n-1` in the denominator is used in calculating the standard deviation of a sample. For the population standard deviation the denomipnator would be `n`, but you will rarely calculate a population standard deviation. In either case, the square of the standard deviation is called **variance**:

$$ \text{sd}(x) = \sqrt{ \text{var}(x) } $$

In R, you calculate the standard deviation with the `sd()` function. Let's calculate some standard deviations and variances:


```r
# calculate the standard deviation of the barnacles per unit area
sd( barnacles$per_m )
```

```
## [1] 273.2828
```

```r
# calculate the variance of the body motion for mice who got the metium dose of THC:
var( mice_pot$percent_of_act[ mice_pot$group==1 ] )
```

```
## [1] 689.4729
```

For a Normal distribution, statisticians typically denote the population variance by the Greek letter $\sigma^2$. In sum, then, a Normal distribution is characterized by its mean and variance parameters, and statisticians usually abbreviate the Normal distribution that has mean $\mu$ and variance $\sigma^2$ by N($\mu$, $\sigma^2$). The **standard Normal** distribution that I've referred to is the N(0, 1) distribution, and you will typically use Z to denote a random variable with that distribution. Lets observe a few Normal distributions by changing the `mean` and `sd` arguments to `dnorm()`:


```r
# plot several Normal distributions with different means and sds:
yy = c(0, 1.5)
plot(x=t, y=dnorm(t, mean=0, sd=1), bty='n', type='l', main="some Normal distributions", ylab='density', ylim=yy)
par( new=TRUE )
plot(x=t, y=dnorm(t, mean=-1.5, sd=0.6), bty='n', type='l', xaxt='n', yaxt='n', xlab='', ylab='', lty=2, ylim=yy, col=2)
par( new=TRUE )
plot(x=t, y=dnorm(t, mean=02, sd=1.5), bty='n', type='l', xaxt='n', yaxt='n', xlab='', ylab='', lty=3, ylim=yy, col=3)
par( new=TRUE )
plot(x=t, y=dnorm(t, mean=0.5, sd=0.3), bty='n', type='l', xaxt='n', yaxt='n', xlab='', ylab='', lty=4, ylim=yy, col=4)
```

<img src="01_probability_files/figure-html/normal-densities-1.png" width="672" />

The basic shape persists, but the location and width change.

## Density, sampling, quantile, and distribution functions
All of R's built-in distributions are characterized by four functions, with a consistent pattern in their naming:

 - Density function begins with d (`dnorm()`)
 - Sampling function begins with r (`rnorm()`)
 - Quantile function begins with q (`qnorm()`)
 - Distribution function begins with p (`pnorm()`)
 
Of these, I've already demonstrated `dnorm()` and `rnorm()`.

### Quantile function
The quantile function maps from the 0-1 range back to the possible values of the distribution. This becomes useful for answering questions like, "what is the critical value that a standard normal random variable falls below 95% of the time?" If you denote that critical value by $z_{0.95}$, then the quantile function solves for $z_{0.95}$ in 
$$ Pr( Z \le z_{0.95} ) = 0.95 $$
Remember when I said that 5% of standard Normal samples are less than negative two, or greater than two? Let's prove it:

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

Thus, we can construct an **interval** from -1.96 to 1.96 that contains 95% of samples from N(0, 1).

If you're working with a vector of numbers instead of a named distribution, then the quantiles are calculated by the `quantile()` function:


```r
# calculate the 0.025 and 0.975 quantiles of y
# specify the vector first, then the quantiles:
quantile(y, 0.025)
```

```
##      2.5% 
## -1.889701
```

```r
quantile(y, 0.975)
```

```
##    97.5% 
## 1.778322
```

```r
# get both quantiles in one line:
quantile(y, c(0.025, 0.975))
```

```
##      2.5%     97.5% 
## -1.889701  1.778322
```

```r
# put the quantiles on the histogram
hist(y)
abline( v=quantile(y, c(0.025, 0.975)), lty=3 )
```

<img src="01_probability_files/figure-html/quantile-function-1.png" width="672" />

### Distribution function
The distribution function is the inverse of the quantile function. It calculates the probability that a random variable is less than or equal to some number. That is, $F_Z(t) = Pr(Z \le t)$. In an introductory statistics class, you'd typically spend a lot of time using paper tables to get comfortable going between the quantile and distribution functions. We can just do the calculations in R:


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

<img src="01_probability_files/figure-html/unnamed-chunk-2-1.png" width="672" />

If you're working on a vector of numbers rather than a named distribution, then you can use the `mean()` function to calculate what proportion are less than some value:


```r
# what proportion of the y sample is less than or equal to -2? What proportion is greater than 2?
mean( y <= -2 )
```

```
## [1] 0.015
```

```r
1 - mean( y<= 2 )
```

```
## [1] 0.015
```

### Other distributions
I have focused on the Normal distribution, but there are many others! You can take a little time to generate samples or quantiles or probabilities from some other distributions, like Poisson (`rpois()`, `qpois()`, etc.), binomial (`rbinom()`, `qbinom()`, etc), or t (`pt()`, `rt()`, etc). Alternatively, try answering some questions:

1. What is the probability that a sample from the N($1$, $3^2$) distribution is less than 0?
2. For the sample `y`, what is an interval that contains 80% of the values?
