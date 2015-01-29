function h=sigfun(w,x,b)
%
%   usage : h=sigfun(w,x)
%
%   input       w       - hidden layer weights
%               x       - training Data 
%
%   output      h       - output function

if nargin<3
    b=1.0;
end

% weights multiplication
temp = w(:,2:end)*x(2:end,:);
[n,m] = size(temp);

% extract bias
bias = w(:,1);
bias = bias(:,ones(1,m));

% w*x
h=(temp + bias)';

%logistic function
h=1./(1+exp(-h*b));