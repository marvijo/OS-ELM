function [beta,output]=elm_round(w,x,t,n,m)
%
%   usage : [beta,output]=elm_round(w,x,t,n,m)
%      
%   
%   input       w       - hidden layer weights
%               x       - training Data 
%               t       - desired output
%               n       - integer bits
%               m       - fraccional bits
%
%   output      beta        - output layer weights
%               error_train - training error
%               error_test  - testing error
%


% quantizer object
q = quantizer('fixed', 'round', 'saturate', [n+m m]);
q2 = quantizer('fixed', 'round', 'saturate', [n+2*m 2*m]);
%q2 = quantizer('fixed', 'round', 'saturate', [48 16]);

g = quantize(q,w*x);

if (q.NOverflows>0)
    disp(strcat('Overflows number (w*x) = ',num2str(q.NOverflows)));
end

G=fuzzyfunc(g);
G = quantize(q,G);

if (q.NOverflows>0)
    disp(strcat('Overflows number - fuzzyfunc  = ',num2str(q.NOverflows)));
end

X=quantize(q,G*G');

if (q.NOverflows>0)
    disp(strcat('Overflows number - G*G''  = ',num2str(q.NOverflows)));
end

% QRD descomposition %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Q R]=QRD_round(X,q,q2);
%[Q R]=QRD(X)

Q = quantize(q,Q);
R = quantize(q,R);

if (q.NOverflows>0)
    disp(strcat('Overflows number - QR  = ',num2str(q.NOverflows)));
end


% TMI Triangular matrix inversion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RI=TMI_round(R);

RI = quantize(q,RI);

if (q.NOverflows>0)
    disp(strcat('Overflows number - RI  = ',num2str(q.NOverflows)));
end

% MM Matrix multiplication %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XI = quantize(q,RI*Q');

if (q.NOverflows>0)
    disp(strcat('Overflows number - XI  = ',num2str(q.NOverflows)));
end

% MM Matrix multiplication %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H=quantize(q,XI*G);

if (q.NOverflows>0)
    disp(strcat('Overflows number - H  = ',num2str(q.NOverflows)));
end

% MM Matrix multiplication %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta = quantize(q,H*t);

if (q.NOverflows>0)
    disp(strcat('Overflows number - beta  = ',num2str(q.NOverflows)));
end


q.NOverflows


output=0;
        
        