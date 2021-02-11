## -------------------------------------------------------------------------------------------------------
# create a random variable X with mean -3 and standard deviation 3


# show the histogram of some samples of X as well as the 0.12 and 0.88 quantiles:


# generate 50 samples of X and calculate their means:


# plot the histogram of mean_x as well as the 0.12 and 0.88 quantiles



## -------------------------------------------------------------------------------------------------------
nn = c(1, 2, 4, 8, 12, 20, 33, 45, 66, 100)
means = sapply( nn, function(n) mean( rnorm(n) ) )
plot(nn, means, bty='n', ylab = "sample mean")
abline(h=0, lty=2)


## -------------------------------------------------------------------------------------------------------
# plot the densities of a standard normal distribution, and of a t-distribution with five degrees of freedom:
t = seq(-4, 4, length.out=1001)
  
plot( x=t, y=dnorm(t), ylim=c(0, 0.5), bty='n', lty=2, type='l', ylab="density" )
par( new=TRUE )
plot( x=t, y=dt(t, df=5), ylim=c(0, 0.5), xaxt='n', yaxt='n', xlab='', ylab='', bty='n', col='red', type='l' )


## -------------------------------------------------------------------------------------------------------
# generate 20 samples from a uniform distribution and plot their histogram


# generate 100 repeated samples of the same size, calculate the mean of each one, and plot the histogram of the means.



# what happens as B and N get larger and smaller? Do they play different roles?


## ----t-probability--------------------------------------------------------------------------------------



## ----t-quantile-----------------------------------------------------------------------------------------



## ----t-interval-----------------------------------------------------------------------------------------


