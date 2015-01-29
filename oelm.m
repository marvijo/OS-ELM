function [beta]=oelm(w,x,t,n_initial,n_block)
%
%   usage : [beta]=oelm(w,x,t,n_initial,n_block) 
%       
%           get output weights using Online Sequential ELM.
%
%   input       w           - random weights matrix [n_neurons , n_fields+1] 
%               x           - data matrix [n_fields + 1 , n_data]
%               t           - output labels matrix [n_data , n_labels]
%               n_initial   - initial number of input patterns to get first approximation to weights   
%               n_block     - number of input patterns on each step
%
%   output      beta        - output weights

n_data = size(x,2);

n_neurons = size(w,1);

Ho = sigfunc((w*x(:,1:n_initial))');

%Ho = sigfun(w,x(:,1:n_initial));        % version que suma el bias

xo = x(2:end,1:n_initial)';
iw=w(:,2:end);
bias = w(:,1)';



%Ho=SigActFun(xo,iw,bias);

%eval('save debug2.mat xo iw bias Ho');

Mo = pinv(Ho'*Ho);
%Mo = (2*rand(n_neurons)-1)*100;



beta_o = pinv(Ho)*t(1:n_initial,:); 

% initial weights 
%beta_o = Mo*Ho'*t(1:n_initial,:); 

BETA2(1)=sum(sum(Mo));

k = 1;

for j=1:1
    
    for i=n_initial:n_block:n_data-1
    %for i=1:n_block:n_data-1
         if (i+n_block>n_data)
             n_block = n_data-i;
         end
         
         
         %h=SigActFun(x(2:end,i+1:i+n_block)',iw,bias);
         %h=h';

         
         h = sigfunc(w*x(:,i+1:i+n_block)); 
         %h = sigfun(w,x(:,i+1:i+n_block));
         
         temp = (eye(n_block)+h'*Mo*h)^(-1);
         
         %temp = (eye(n_block)+h*Mo*h')^(-1);
         
         M = Mo - (Mo*h*temp*h'*Mo);
         %M = Mo - (Mo*h'*temp*h*Mo);
         
         k = k+1;
         BETA2(k)=sum(sum(M));
         
         
         % output weights update
         beta_o = beta_o + M*h*(t(i+1:i+n_block,:)-h'*beta_o);
         %beta_o = beta_o + M*h'*(t(i+1:i+n_block,:)-h*beta_o);
         
         M2=M;
         
         Mo = M;
         
    end
    
end  

eval('save debug2.mat BETA2 M2')
         
beta = beta_o;
    