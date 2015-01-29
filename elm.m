function [beta,beta2,output]=elm(w,x,t)
%
%
%   usage : [beta]=elm(w,x,t)
%      
%   
%   input       w       - hidden layer weights
%               x       - training Data 
%               t       - desired output
%        
%   output      beta    - output layer weights
%
%

H = (w*x)';

%H = sigfunc(H);
%H = sigfun(w,x);
H = fuzzyfunc((w*x)');

%% qrd %%%%%%%%%%
%[Q,R]=QRD(H'*H);
%RI=TMI(R);
%beta2 = RI*Q'*H'*t

temp1 =H'*H

inv(H'*H)

beta2 = inv(H'*H)*H'*t

pause

beta = pinv(H)*t

pause

output = H*beta;


