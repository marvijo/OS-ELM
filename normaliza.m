function y=normaliza(x,a,b)

k = (b-a)/(max(x)-min(x));
p = a-k*min(x);

y=k*x+p;


