function [mean,M2,var] = onlineVariance(data,n,mean,M2)

  n  = n + 1;
  delta = data - mean;
  mean = mean + delta / n;
  M2 = M2 + delta*(data-mean);
  
  if(n < 2)
    var = 0;
  else
    var = M2 / (n-1);
  end