function [r]=dec2real(dec,n,m)

N=20;
M=20;

if (nargin<2)
	n=N;
	m=M;
end

if (dec<0)
    r = dec/(2^m);
    
else

    bin = dec2bin(dec,n+m);
    sign=bin(1);

    if (sign =='1')
	    bin = cmp2(bin);
    end
    
    x=bin2dec(bin);

    if (sign=='1')
	    r = -x/(2^m);
    else
	    r = x/(2^m);
    end
    
end

