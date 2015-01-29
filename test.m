function [b1,b2,b3,error1,error2,error3]=test(train,test,N,NO,block)


randn('state',sum(100*clock));

% training data ////////////////////////////////////////////

% move column 1 to end
data1 = changeFieldFile(train);

% process end column
[data1, numlabels1] = labelprocess(data1);

n_fields = size(data1,2)-numlabels1;

% test data ////////////////////////////////////////////////

% move column 1 to end
data2 = changeFieldFile(test);

% process end column
[data2, numlabels2] = labelprocess(data2);

%random weights
w = 2*rand(N,n_fields+1)-1;
%eval('save debug2.mat w')

% OSELM
% *************************************************************************
% *************************************************************************

[beta,TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy]=OSELM(train,test,1,w,N,'sig',NO,block);

b1=beta;
error1 =(1-TrainingAccuracy)*100;

% *************************************************************************
% 


%JM
% *************************************************************************
% *************************************************************************

% input data
x = [ones(size(data1,1),1) data1(:,1:n_fields)]';

% target
t = data1(:,n_fields+1:end);

%eval('save debug2.mat x t')

H = (w*x)';
H = sigfunc(H);

%eval('save debug2.mat H')

beta_o = oelm(w,x,t,NO,block);
out_o = H*beta_o;

b2=beta_o;
error2 = (1-sum(sum(sign(out_o) == t,2)==numlabels1)/size(data1,1))*100;

%b3 = inv(H'*H)*H'*t;
b3 = pinv(H)*t;
out_3 = H*b3;

error3 = (1-sum(sum(sign(out_3) == t,2)==numlabels1)/size(data1,1))*100;


