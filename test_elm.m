function [beta, beta2, error_train, error_test, t_t, out_t]=test_elm(data,n_labels,prop,n_neurons,n_rep1,n_rep2)
%
%
%   usage : [beta, beta2, error_train, error_test, t_t, out_t]=test_elm(data,n_labels,prop,n_neurons,n_rep1,n_rep2)
%      
%               [beta, beta2, error_train, error_test, t_t, out_t]=test_elm(dbs,3,0.5,10:10:100,50,1)
%
%   input       data        - data source
%               n_classes   - number of classes 
%               n_neurons   - number of neurons
%               prop        - training data proportion
%
%   output      beta        - output layer weights
%               error_train - training error
%               error_test  - testing error
%

randn('state',sum(100*clock));

[n_data,n_fields] = size(data);

n_fields = n_fields - n_labels;

% get trainning and test data
n_train = round(n_data*prop);
n_test = n_data-n_train;

ite=0
    
for i=n_neurons % number of neurons
   
    e1=0;e_t1=0;
    
    for j=1:n_rep1 % number of data tries
    
        randn('state',sum(100*clock));
        
        index = randperm(n_data);
        
        data_train =data(index(1:n_train),:);        
        %data_train = normalizedata(data_train,n_labels);
        
        
        data_test = data(index(n_train+1:end),:);
        
        % training input data
        x = [ones(n_train,1) data_train(:,1:n_fields)]';
        
        % training target
        t = data_train(:,n_fields+1:end);
        
        % testing input data
        x_t = [ones(n_test,1) data_test(:,1:n_fields)]';
        
        % testing  target
        t_t = data_test(:,n_fields+1:end);

        e2 = 0;e_t2=0;
        for k=1:n_rep2 % number of weight's initializations
            
            randn('state',sum(100*clock));
            
            % random weights
            w = 2*rand(i,n_fields+1)-1;
            w  = w*0.001;

            % training - output weights 
            [beta,beta2,out]=elm(w,x,t);

            % iteration error
            e2 = e2 + (1-sum(sum(win(out) == t,2)==n_labels)/n_train)*100;
            
            % testing error %%%%%%%%%%%%%%%%%%%%%%
            %out_t = sigfun(w,x_t)*beta;
            %out_t = sigfunc((w*x_t)')*beta;
            out_t = fuzzyfunc((w*x_t)')*beta;
            
            e_t2 = e_t2 + (1-sum(sum(win(out_t) == t_t,2)==n_labels)/n_test)*100;

        end
        
        e1 = e1 + e2/n_rep2;
        e_t1 = e_t1 + e_t2/n_rep2;
        
    end
    
    ite = ite + 1;
    error_train(ite) = e1/n_rep1;
    error_test(ite) = e_t1/n_rep1;
          
end


plot(n_neurons,error_train,'b')
hold on
plot(n_neurons,error_test,'r--')
title(strcat('training data number = ',num2str(prop*100),' % (',num2str(n_train),')'))
legend('training error','testing error')
xlabel('Number of hidden neurons')
ylabel('Classification error(%)')
