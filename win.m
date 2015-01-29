function y = win(x)
%
%    usage : y = win(x)
%   
%    gives '1' to winner output, '-1' otherwise
%
%

[n,m] = size(x);

y(1:n,1:m)=-1;

for i=1:n
    
    [val,indx] = max(x(i,:));

    y(i,indx)=1;
    
end
    
    