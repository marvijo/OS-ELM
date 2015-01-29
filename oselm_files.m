function oselm_files(data,file_train,file_test,mode,inpos,outpos,prop)
%
%
%       usage :  oselm_files(data,file_train,file_test,mode,inpos,outpos,prop)
%               
%                   split data in two file datas file_train y file_test.
%                   
%                           oselm_files(data,file_train,file_test,1,1,5,0.5)
%                           
%                               -> move column 5 to 1 with 0.5 proportion.
%                           
%                           oselm_files(data,file_train,file_test)
%                               
%                               -> assume column 1 is the output column and don't move
%
%       input   data        - Matrix data or filedata
%               file_train  - filename of training data
%               file_test   - filename of testing data
%               inpos       - column to move
%               outpos      - new position
%               prop        - relation of training data
%
%

% job mode
NO_CHANGE = 0;
CHANGE = 1;

if nargin<7
    prop = 0.5;
end

if nargin<6
    inpos = 1;  % first column
end

if nargin<5
    outpos = 0; % final column
end

if nargin<4
    mode = NO_CHANGE;
else
    mode = CHANGE;
end

if isstr(data)
    TYPE = 1;
else
    TYPE = 2;
end

if mode == CHANGE

    if TYPE==1  % is a file
        data=changeFieldFile(data,inpos,outpos); % read data changing output column.
    else
        error('CHANGE : data not a file . not implemented');
    end
    
    % Change label to number    
    [labels,data] = labels2num2(data,outpos);
    
else         
    
    if TYPE==1 % is a file
        data=readTokens(data);                   % read data.
    else
        error('CHANGE : data not a file');
    end
    
    % Change label to number    
    [labels,data] = labels2num2(data,1);

end

n = size(data,1);

index = randperm(n);

n_train = round(n*prop);

data_train = data(index(1:n_train),:);
data_test=data(index(n_train+1):end,:);

file_train=sprintf(' %s',file_train);
file_test=sprintf(' %s',file_test);

eval(strcat('save',file_train,' data_train -ASCII'))
eval(strcat('save',file_test,' data_test -ASCII'))