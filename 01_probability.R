## ----normal-density-raw---------------------------------------------------------------------------------
# draw the standard normal distribution function, with some annotations
t = seq(-4, 4, length.out=1001)
plot( x=t, y=dnorm(t), bty='n', type='line', main="standard normal density")

abline(v=0, lty=3)


## ----normal-sample-example------------------------------------------------------------------------------
# sample 20 numbers from a standard normal distribution:
x = rnorm(20)

# observe your sample:
print( round(x, 2) )


## ----annotated-density-tails----------------------------------------------------------------------------
# plot the standard normal density function with some annotations
plot( x=t, y=dnorm(t), bty='n', type='l', main="standard normal density")

# annotate the density function with the 5% probability mass tails
polygon(x=c(t[t<=qnorm(0.025)], qnorm(0.025), min(t)), y=c(dnorm(t[t<=qnorm(0.025)]), 0, 0), col=grey(0.8))

polygon(x=c(t[t>=qnorm(0.975)], max(t), qnorm(0.975)), y=c(dnorm(t[t>=qnorm(0.975)]), 0, 0), col=grey(0.8))


## ----normal-histogram-----------------------------------------------------------------------------------
# show the histogram of x
hist(x)


## ----normal-histogram-more-data-------------------------------------------------------------------------
# sample 200 numbers from a standard normal
y = rnorm( 200 )

# show the histogram of y
hist( y )


## ----sample-function------------------------------------------------------------------------------------
# take a sample of 20 numbers from x (without replacement)


# take a sample of 20 numbers from x (with replacement)


# calculate the means of x, x2, and x3


## ----mean-median----------------------------------------------------------------------------------------
# calculate the mean and median of x. They aren't exactly zero in the sample.



## ----subsampe-expectation-------------------------------------------------------------------------------
# subsample x 50 times with replacement, and store the mean of each


# print the results and the mean of the means


# shoe the histogram of sample means, with an annotation at the expectation



## ----sd-example-----------------------------------------------------------------------------------------
# calculate the standard deviation of the barnacles per unit area


# calculate the variance of the body motion for mice who got the metium dose of THC:



## ----normal-densities-----------------------------------------------------------------------------------
# plot several Normal distributions with different means and sds:
yy = c(0, 1.5)
plot(x=t, y=dnorm(t, mean=0, sd=1), bty='n', type='l', main="some Normal distributions", ylab='density', ylim=yy)
par( new=TRUE )
plot(x=t, y=dnorm(t, mean=-1.5, sd=0.6), bty='n', type='l', xaxt='n', yaxt='n', xlab='', ylab='', lty=2, ylim=yy, col=2)
par( new=TRUE )
plot(x=t, y=dnorm(t, mean=02, sd=1.5), bty='n', type='l', xaxt='n', yaxt='n', xlab='', ylab='', lty=3, ylim=yy, col=3)
par( new=TRUE )
plot(x=t, y=dnorm(t, mean=0.5, sd=0.3), bty='n', type='l', xaxt='n', yaxt='n', xlab='', ylab='', lty=4, ylim=yy, col=4)


## -------------------------------------------------------------------------------------------------------
# demonstrate quantiles of the standard normal distribution


# if you want an interval that contains the random variable 95% of the time, you may divide the remaining 5% in half, so the interval is in the center:



## ----quantile-function----------------------------------------------------------------------------------
# calculate the 0.025 and 0.975 quantiles of y
# specify the vector first, then the quantiles:


# get both quantiles in one line:


# put the quantiles on the histogram



## -------------------------------------------------------------------------------------------------------
# Demonstrate the standard normal distribution function:


# draw the standard normal distribution function, with some annotations
t = seq(-4, 4, length.out=1001)
plot( x=t, y=pnorm(t), bty='n', type='line', main="standard normal distribution function")

# annotate the plot with lines indicating the quantiles for a 95% probability interval
lines(x=c(min(t), qnorm(0.025)), y=rep(0.025, 2), lty=2)
lines(x=c(min(t), qnorm(0.975)), y=rep(0.975, 2), lty=2)

lines(x=rep(qnorm(0.025), 2), y=c(0, 0.025), lty=3)
lines(x=rep(qnorm(0.975), 2), y=c(0, 0.975), lty=3)


## ----empirical-cdf--------------------------------------------------------------------------------------
# what proportion of the y sample is less than or equal to -2? What proportion is greater than 2?


