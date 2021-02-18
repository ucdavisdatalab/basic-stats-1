# Analysis of variance
Finally, we will introduce the analysis of variance, called ANOVA. For our examples, we return to data that we first worked with in chapter 1 - it is the amount of motor activity for mice that were dosed with different amounts of THC. ANOVA is specifically for testing hypotheses where there are several groups in the experiment and you want to show whether there is any difference between them. In our hypothesis testing framework, the null hypothesis here is that there is no difference between the groups. For example, the null hypothesis of our example is that there is no difference in the amount of motor activity among the mice that got the low, medium, high, or control doses of THC.

## Eyeball test
Before doing any formal testing, it is best to plot the data and see what results would make sense.


```r
# boxplot of activity by mice that got different THC doses
with( mice_pot, boxplot(percent_of_act ~ group) )
```

<img src="04_anova_files/figure-html/thc-boxplot-1.png" width="672" />

The eyeball test says that there is no clear difference between the VEH, 0.3, and 1 groups, but the 3 group (which got the high dose of THC) has a different amount of motor activity. This consititutes a rejection of the null hypothesis, because that hypothesis said that there is no difference among any of the groups.

## ANOVA
Now, let's do a formal ANOVA:


```r
# create the linear model
fit_mice = lm( percent_of_act ~ group, data=mice_pot )

# process the model through the anova function
anova( fit_mice )
```

```
## Analysis of Variance Table
## 
## Response: percent_of_act
##           Df Sum Sq Mean Sq F value Pr(>F)  
## group      3   6329 2109.65  3.1261 0.0357 *
## Residuals 42  28344  674.85                 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The ANOVA table is telling us that we should reject the null hypothesis of no difference between the different THC doses (p=0.036), which accords with our intuitive sense from the eyeball test. Here is a brief explanation of the columns of the ANOVA table.

1. `Df` is the number of degrees of freedom for each treatment. This example has only one treatment (group) and it uses three degrees of freedom because that is one fewer than the number of categories in the group treatment. Residual degrees of freedom are then whatever is left of the total $n-1$ degrees of freedom. Here, that's 42 because there are 46 rows in the data and 42 = 46-3-1.
2. `Sum Sq` is the explained sum of squares for each treatment. This is beyond what we'll get into today, but think of how there is some total variation in the height of humans, but because men are typically a bit taller than women, there is somewhat less variability left after accounting for each person's sex. The amount of variability in height that is explained by sex is the difference between the variability of all human heights and the variability that remains after accounting for sex.
3. `Mean Sq` is the mean sum of squares for each row. It is calculated by dividing the `Sum Sq` column by the `Df` column.
4. `F value` is the row's F-statistic, which is calculated by dividing the `Mean Sq` column for a treatment by the `Mean Sq` column for the `Residuals`. There is only one treatment in this example.
5. `Pr(>F)` is the p-value for each treatment in the ANOVA.

An important note is that since the residual mean squares are in the denominator for calculating the F-statistic, smaller residual mean squares means a larger F-statistic, and therefore greater power to detect differences between groups. You can make the residual mean squares smaller by increasing the residual degrees of freedom - i.e., by increasing `n` (sample size).


## Kruskal-Wallis test
The F-test in ANOVA depends on the normality of the group means, which could come because the raw data follows a normal distribution or because the sample size in each group is large enough to rely on the Central Limit Theorem. If neither is the case, then you can't use an ANOVA F-test to test for differences between groups. The Kruskal-Wallis test is based on ranking the data, and can be applied when ANOVA cannot. When the ANOVA assumptions are valid, the Kruskal-Wallis test can be used too, but in that situation it brings less power than the ANOVA F-test. What happens if we use the Kruskal-Wallis test on the mice THC example?


```r
# use the Kruskal-Wallis test on the mice_pot data
kruskal.test( percent_of_act ~ group, data=mice_pot )
```

```
## 
## 	Kruskal-Wallis rank sum test
## 
## data:  percent_of_act by group
## Kruskal-Wallis chi-squared = 7.2035, df = 3, p-value = 0.06569
```

The p-value for this test is 0.066, which would cause you not to reject the null at the 0.05 level of significance.

