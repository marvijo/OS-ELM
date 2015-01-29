function [out,numlabels] = labelprocess(data)
%
%       usage :  [out,numlabels] = labelprocess(data)
%           
%               - Transform real number output in binary output.
%                   ex :    1  ->  1 -1 -1
%                           2  ->  -1 1 -1
%                           3  ->  -1 -1 1
%
%       input   data        - data of inputs and output as numbers.
%
%       output  numlabels   - number of different labels (classes).
%               out         - data output as numeric matrix
%

if iscell(data)
    
    n = length(data);   
    m = length(data{1});
    
    %temp = data{1};
    
    for i =1:n
        for j=1:m
            temp(i,j)=str2num(data{i}{j});
        end
    end
    
    data=temp;
end

%
    
numlabels = max(data(:,end));

labels = 1:numlabels;

for i=1:size(data,1)
    outlabels(i,:)=(labels==data(i,end));
end

outlabels=outlabels*2-1;

out=[data(:,1:end-1) outlabels];


    