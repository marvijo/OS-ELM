function [y,x2] = fuzzyfunc(x,L)

    if (nargin<2)
        L=2;
    end
    
    x2=x;

    a=find(x>=L);
    x2(a)=1;
    a=find(x<=-L);
    x2(a)=-1;
    a=find((x>-L)&(x<L));
    
    % valores intermedios
		
	x2(a)=(-x(a).*abs(x(a)))/(L^2) + (2*x(a))/L;
   	
	y=0.5*(x2+1);
	
	%y=x2;
    