## -------------------------------------------------------------------------------------------------------
# sample 50 numbers from the standard normal distribution
y = rnorm(50)

# look at the histogram - it's like the density function
hist(y)

# look at the QQ plot - it demonstrates how closely the distribution matches the quantiles of a Normal distribution.
qqnorm( rnorm( 50) )

# plot a couple of non-normal QQ plots:
qqnorm( rexp(50) )
qqnorm( rt(50, df=2) )


## -------------------------------------------------------------------------------------------------------
# extract just the mice that got the medium dose of THC


# look at the histogram and QQ plot to assess whether the data are approximately normal



## -------------------------------------------------------------------------------------------------------
# calculate the sample mean, sample standard deviation, and sample size:


# calculate the relevant quantiles of the t-distribution.
# use the 0.1 and 0.9 quantiles because we want the 80% confidence interval
# and (1-0.8) / 2 = 0.1 and 1 - 0.1 = 0.9.


# calculate the confidence interval:
cat( "The 80% CI is (", x_bar + t_low * s / sqrt(n), ", ", x_bar + t_high * s / sqrt(n), ").")

# check your calculation with the t.test function:




## -------------------------------------------------------------------------------------------------------
# calculate the number of barnacles per unit area for each sample:


# examine the histogram and QQ plot of the barnacles per unit area:


# does it look to you like the barnacles per unit area are distributed like a normal distribution?


## -------------------------------------------------------------------------------------------------------
# define the sample size and a 


# generate the bootstrap-t distribution for this data


# plot the histogram of the bootstrap-t distribution


# extract the 0.025 and 0.975 quantiles, and annotate the histogram with them


# calculate the confidence interval


# compare to the result we'd see with a t confidence interval

