function [Ainv]=TMI_round(A,q)

[n m] = size(A);

Ainv=zeros(n,m);

for i=1:n

	if i > 1
	
	%-Select Rinv(j,:) and R(:,i)  
	
		for j=1:i-1	
			Ainv(j,i) = -Ainv(j,j:i)*A(j:i,i)/A(i,i);
		end
		
		%for j=1:i-1		
			%Ainv(j,i)=-Ainv(j,i)/A(i,i);			
		%end
		
	end
	
	Ainv(i,i) = 1/A(i,i);
	
end