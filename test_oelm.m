function [beta, error_train,error_test,output] = test_oelm(filename,classification,prop,n_neurons,n_block)
%
%
%   usage : [beta,error_train,error_test,ouput] = test_oelm(filename,classification,prop,n_neurons,n_block)
%      
%   
%   input       filename        - data file ( training and testing )
%               classification  - type of problem 
%                                 1 - classification
%                                 2 - regression
%               prop            - Proportion of data for training
%               n_neurons       - neurons number
%               n_block         - number of inputs on each oselm step
%
%   output      beta            - output weights
%               error_train     - training error
%               error_test      - testing error
%               output          - output values
%

close all

randn('state',sum(100*clock));

% if classification, extract labels
if classification==1
    
    [labels,data] = labels2num(filename);
    [data, numlabels] = labelprocess(data);
    
    n_data = size(data,1);
    n_fields = size(data,2)-numlabels;
       
else
    
    data = load(filename);
    [n_data, n_fields] = size(data);
    
    n_fields = n_fields-1;
    
end

% get trainning and test data
n_train = round(n_data*prop);
n_test = n_data-n_train;

index = randperm(n_data);
%index=1:n_data;                

data_train =data(index(1:n_train),:);
data_test = data(index(n_train+1:end),:);

% Normalize training data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (classification == 1)
    
    %mu = mean(data_train(:,1:n_fields));
    %var = std(data_train(:,1:n_fields),0,1)

    % training data
    %for k=1:n_fields      
    %    data_train(:,k)=(data_train(:,k)-mu(k))/var(k)^2;
    %end
    
    % test data
    %for k=1:n_fields      
    %    data_test(:,k)=(data_test(:,k)-mu(k))/var(k)^2;
    %end

else
    
    mu = mean(data_train);
    var = std(data_train,0,1);

    % training data
    for k=1:size(data_train,2)      
        data_train(:,k)=(data_train(:,k)-mu(k))/var(k)^2;
    end
    
     % test data
    for k=1:size(data_test,2)      
        data_test(:,k)=(data_test(:,k)-mu(k))/var(k)^2;
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% random weights
w = 2*rand(n_neurons,n_fields+1)-1;
%pesos = load('pesos.mat');
%w= pesos.pesos;

% input data
x = [ones(n_train,1) data_train(:,1:n_fields)]';

% target
t = data_train(:,n_fields+1:end);

start = cputime;

% -------------------------------------------------------
% offline ELM -------------------------------------------
% -------------------------------------------------------

H = (w*x)';
H = sigfunc(H);

beta = inv(H'*H)*H'*t;  % OUTPUT WEIGHTS -- ELM offline

t_elm= cputime-start;

out = H*beta;       % output

% -------------------------------------------------------

% -------------------------------------------------------
% online ELM --------------------------------------------
% -------------------------------------------------------

beta_o = oelm(w,x,t,2*n_neurons,n_block);   %  n_initial = 2*n_neurons

out_o = H*beta_o;   % output

% --------------------------------------------------------

% -------------------------------------------------------
% test data ---------------------------------------------
% -------------------------------------------------------


% input data
x = [ones(n_test,1) data_test(:,1:n_fields)]';

% ideal target
t_test = data_test(:,n_fields+1:end);

H = sigfunc((w*x)');

out_test = H*beta;      % output offline

out_test_o = H*beta_o;  % output online


% -------------------------------------------------------
% Error -------------------------------------------------
% -------------------------------------------------------


if classification == 1
    
    % OFFLINE
    error_train = (1-sum(sum(sign(out) == t,2)==numlabels)/n_train)*100;
    error_test = (1-sum(sum(sign(out_test) == t_test,2)==numlabels)/n_test)*100;
    
    % ONLINE
    error_train_o = (1-sum(sum(sign(out_o) == t,2)==numlabels)/n_train)*100;
    error_test_o = (1-sum(sum(sign(out_test_o) == t_test,2)==numlabels)/n_test)*100;
    
else
    % OFFLINE
    error_train = sum((out-t).^2)/n_train;
    error_test = sum((out_test-t_test).^2)/n_test;
    
    % ONLINE
    error_train_o = sum((out_o-t).^2)/n_train;
    error_test_o = sum((out_test_o-t_test).^2)/n_test;
    
    % Error graphics
    
    plot(t)
    hold on
    plot(out,'r--')
    hold on
    plot(out_o,'g+')
    legend('Ideal output','ELM','Online ELM')
    title('Output ( training data ) - ELM methods')

end

beta = [beta beta_o];

error_train  = [error_train error_train_o];
error_test = [error_test error_test_o];

output = [out sign(out) sign(out_o) t];
    
    
    
    