function out = weight_cost(in)
  coeff = 500;
  out = 1-1./((coeff).^in); 
end