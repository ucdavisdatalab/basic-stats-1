# Inference

Inference means making statements about the population based on a sample. In one simple case, inference can mean using a sample to estimate the mean of the population from which it arose. Since the law of large numbers says that the sample mean tends to the population mean, we'll use the sample mean to approximate the population mean. You've already seen this in the plots where I showed the sample mean getting closer to the population mean as the sample size increased.

## Revisiting the standard normal distribution:
The distribution, density, and quantile functions are all about the population. When you're working with data, the graphs won't be as clean. When you're using methods that depend upon the data being approximately normal, you'll have to check some diagnostics. One simple but effective approach is to look at the histogram and QQ plot, and judge whether there is obvious non-normality. Here's an example from the standard normal distribution:


```r
# sample 50 numbers from the standard normal distribution
y = rnorm(50)

# look at the histogram - it's like the density function
hist(y)
```

<img src="03_inference_files/figure-html/unnamed-chunk-1-1.png" width="672" />

```r
# look at the empirical distribution function - it's like the distribution function
plot( ecdf(y) )
```

<img src="03_inference_files/figure-html/unnamed-chunk-1-2.png" width="672" />

```r
# look at the QQ plot - it demonstrates how closely the distribution matches the quantiles of a Normal distribution.
qqnorm(y)
```

<img src="03_inference_files/figure-html/unnamed-chunk-1-3.png" width="672" />

```r
# plot a couple of non-normal QQ plots:
qqnorm( rexp(50) )
```

<img src="03_inference_files/figure-html/unnamed-chunk-1-4.png" width="672" />

```r
qqnorm( rt(50, df=2) )
```

<img src="03_inference_files/figure-html/unnamed-chunk-1-5.png" width="672" />


## Looking at real data

### Normal data: using the t-distribution

In the `fosdata` package there is a dataset called `mice_pot`, which contains data from an experiment where mice were dosed with THC and then measured for motor activity as a percentage of their baseline activity. We are going to look at the group that got a medium dose of THC.


```r
# import the fosdata package and the mice_pot data
library( 'fosdata' )
```

```
## 
## Attaching package: 'fosdata'
```

```
## The following objects are masked _by_ '.GlobalEnv':
## 
##     barnacles, mice_pot
```

```r
data( mice_pot )

# extract just the mice that got the medium dose of THC
mice_med = mice_pot[ mice_pot$group == 1, ]

# look at the histogram and QQ plot to assess whether the data are approximately normal
hist( mice_med$percent_of_act )
```

<img src="03_inference_files/figure-html/unnamed-chunk-2-1.png" width="672" />

```r
qqnorm( mice_med$percent_of_act )
```

<img src="03_inference_files/figure-html/unnamed-chunk-2-2.png" width="672" />

#### Find the 80% confidence interval for the population mean

Now we are using our sample to make some determination about the population, so this is statistical inference. Our best guess of the population mean is the sample mean, `mean( mice_med$percent_of_act )`, which is 99.1%. But to get a confidence interval, we need to use the formula
$$ \bar{x} \pm t_{n-1, 0.1} * S / \sqrt{n} $$
Going piece-by-piece in this formula:


```r
# calculate the sample mean, sample standard deviation, and sample size:
x_bar = mean( mice_med$percent_of_act )
s = sd( mice_med$percent_of_act )
n = nrow( mice_med )

# calculate the relevant quantiles of the t-distribution.
# use the 0.1 and 0.9 quantiles because we want the 80% confidence interval
# and (1-0.8) / 2 = 0.1 and 1 - 0.1 = 0.9.
t_low = qt(0.1, df=n-1)
t_high = qt(0.9, df=n-1)

# calculate the confidence interval:
cat( "The 80% CI is (", x_bar + t_low * s / sqrt(n), ", ", x_bar + t_high * s / sqrt(n), ").")
```

```
## The 80% CI is ( 88.71757 ,  109.3871 ).
```

```r
# check your calculation with the t.test function:
t.test( mice_med$percent_of_act, conf.level=0.8 )
```

```
## 
## 	One Sample t-test
## 
## data:  mice_med$percent_of_act
## t = 13.068, df = 11, p-value = 4.822e-08
## alternative hypothesis: true mean is not equal to 0
## 80 percent confidence interval:
##   88.71757 109.38712
## sample estimates:
## mean of x 
##  99.05235
```

### Non-normal data: resampling

In the `fosdata` package, there is a dataset called `barnacles` that is from a study where scientists counted the number of barnacles on rocks in the intertidal zone. We'll import the data and look at its distribution:


```r
# import the fosdata package and the barnacles data
library( 'fosdata' )
data( barnacles )

# calculate the number of barnacles per unit area for each sample:
barnacles$per_m = barnacles$count / barnacles$area_m

# examine the histogram and QQ plot of the barnacles per unit area:
hist( barnacles$per_m, main="barnacles per square meter" )
```

<img src="03_inference_files/figure-html/unnamed-chunk-4-1.png" width="672" />

```r
qqnorm( barnacles$per_m )
```

<img src="03_inference_files/figure-html/unnamed-chunk-4-2.png" width="672" />

```r
# does it look to you like the barnacles per unit area are distributed like a normal distribution?
```

We should conclude that the data are obviously non-normal.

#### Bootstrap-t distribution:
In this case, the observations themselves are not normally distributed so the t-distribution derived from the CLT will be only an approximation. But there is another option: resampling. This means shuffling our original data to generate new values of the t-statistic, and then working directly from this "bootstrap-t" distribution for inferences. Here is the procedure for generating your bootstrap-t distribution:

 1. Compute the sample mean $\bar{x}$.
 2. Repeat the following many times:
  - Resample from the barnacle data with replacement, calling the resample `z`.
  - Calculate the t-statistic (centered at $\bar{x}$) for this resample and call it `t_boot[[i]]`. The formula is `( mean(z) - mean(barnacles$per_m) ) / ( sd(z) / sqrt(n) )`.
 3. Get the quantiles from the bootstrap-t distribution.
 4. Calculate the confidence interval as 
 $$ (\bar{x} - t_{boot, lower} \times s / \sqrt{n}, \bar{x} + t_{boot, upper} \times s / \sqrt{n} $$


```r
# define the sample size and a 
B = 200
t_boot = numeric( B )

# generate the bootstrap-t distribution for this data
for (i in 1:B) {
  z = sample( barnacles$per_m, replace=TRUE )
  t_boot[[i]] = ( mean(z) - mean(barnacles$per_m) ) / ( sd(z) / sqrt(length(z)) )
}

# plot the histogram of the bootstrap-t distribution
hist(t_boot)

# extract the 0.025 and 0.975 wuantiles, and annotate the histogram with them
t_lower = quantile( t_boot, 0.025 )
t_upper = quantile( t_boot, 0.975 )
abline( v = c(t_lower, t_upper), lty=3)
```

<img src="03_inference_files/figure-html/unnamed-chunk-5-1.png" width="672" />

```r
# calculate the confidence interval
print( round( mean(barnacles$per_m) + c(t_lower, t_upper) * sd(barnacles$per_m) / sqrt(length(barnacles$per_m)), 2 ))
```

```
##   2.5%  97.5% 
## 269.88 389.06
```

```r
# compare to the result we'd see with a t confidence interval
t.test( barnacles$per_m )
```

```
## 
## 	One Sample t-test
## 
## data:  barnacles$per_m
## t = 11.397, df = 87, p-value < 2.2e-16
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  274.1155 389.9216
## sample estimates:
## mean of x 
##  332.0186
```
