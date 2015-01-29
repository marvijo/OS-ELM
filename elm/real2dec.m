function [d]=real2dec(real,n,m)

N=20;
M=20;

if (nargin<2)
	n=N;
	m=M;
end

[fil col] = size(real);

if (fil>1 || col>1)
	for i=1:fil
		for j=1:col
			bin = dec2fix(real(i,j),n,m);
			d(i,j) = bin2dec(bin);
		end
	end	
return
end

bin = dec2fix(real,n,m);
d = bin2dec(bin);
