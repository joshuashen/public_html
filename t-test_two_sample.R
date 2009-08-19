## two-sample t-test, assuming different variationa and sample size

# reference: http://en.wikipedia.org/wiki/Student's_t-test#Unequal_sample_sizes.2C_unequal_variance

# t = (x1_bar - x2_bar) / S_x1-x2

# S_x1-x2 is not a pooled variance. It is defined as:
# S_x1-x2 = (S1**2/n1 + S2**2/n2) **0.5

# DF = (s1**2/n1 + s2**2/n2)**2 / [(s1**2/n1)**2 / (n1-1) + (s2**2/n2)**2/(n2-1)]


ttest <- function(a,b)
{
 # a, b should be a vector of three elements: mean, stdev, sample_size
  sab = (a[2]**2 /a[3] + b[2]**2 / b[3])**0.5;
  t = abs(a[1] - b[1]) / sab
  degreef = (a[2]**2 /a[3] + b[2]**2 / b[3])**2 / ((a[2]**2 /a[3])**2 / (a[3]-1) + (b[2]**2 / b[3])**2 / (b[3]-1))

  p = 1 - pt(t, df = degreef)
  return (p,t, degreef)
}
