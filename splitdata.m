function [data_train, data_test]=splitdata(source,prop,type,file_train,file_test)
%
%       usage :  data=splitdata(source,prop,type,file_train,file_test)
%
%            - split data for training and testing
%                   
%       input       source      - source of data to process ( array, data file or mat file ).
%                   prop        - Proportion of training data
%                   type        - type of file output
%                                       - 0 none
%                                       - 1 mat file
%                                       - 2 dat file
%
%       output      data_train  - training data
%                   data_test   - testing data
%

NONE = 0;
FILE_MAT = 1;
FILE_DAT = 2;

if nargin<3
    type = FILE_MAT;
end
    
if isstr(source)    % file
    
    [filename ext]=strtok(source,'.');
    
    if (strcmp(ext,'.mat'))
        
        data_struct = load(source);
        data = data_struct.datos;
        
    elseif ( strcmp(ext,'.data')|| strcmp(ext,'.dat') ) 
        data = load(source);
    else
        error('Not valid file')    
    end 
    
    
elseif not(isnumeric(source))
    
    error('Not numerical variable')
    
else
    
    data=source;
    
end

% split data

randn('state',sum(100*clock));

n = size(data,1)
index = randperm(n)
n_train = round(n*prop)

data_train = data(index(1:n_train),:);
data_test=data(index(n_train+1:end),:);


% save data
if (type ~= 0)
    
    if (type==FILE_MAT)
        
        if (nargin<4)
            file_train_out = strcat(filename,'_train','.mat');
            file_test_out = strcat(filename,'_test','.mat');
        else
            file_train_out = strcat(file_train,'.mat');
            file_test_out = strcat(file_test,'.mat');
        end
        
        file_train_out=sprintf(' %s',file_train_out);
        file_test_out=sprintf(' %s',file_test_out);
        
        eval(strcat('save',file_train_out,' data_train'))
        eval(strcat('save',file_test_out,' data_test'))
        
    elseif (type==FILE_DAT)
        
        if (nargin<4)
            file_train_out = strcat(filename,'_train','.dat');
            file_test_out = strcat(filename,'_test','.dat');
        else
            file_train_out = strcat(file_train,'.dat');
            file_test_out = strcat(file_test,'.dat');
        end
        
        file_train_out=sprintf(' %s',file_train_out);
        file_test_out=sprintf(' %s',file_test_out);
        
        eval(strcat('save',file_train_out,' data_train -ASCII'))
        eval(strcat('save',file_test_out,' data_test -ASCII '))
    else
        
        warning('not file generated')
        
    end
        
    
    
end