function [labels,out] = labels2num(source,col,tok)
%
%
%   usage :  [labels, out] = labels2num(source, col, tok)
%
%             Get a file data or cell data, indentifies label of each class
%             and subtitutes it by a number, returning data as matrix.
%
%   input           source  - source of data (cell of tokens or file data ).             
%                   col     - column to process ( default : end column ).
%                   tok     - characters used to split tokens.                           
%    
%   output          labels  - labels of classes.
%                   out     - matrix data.
%

if nargin<3
    tok=' ,';
end

if nargin<2
    col = 0; % end column
end

if isstr(source) % is file
    data = readTokens(source);
else
    data = source;
end

% now data is cell

n_fields = length(data{1});

if col == 0
    col = n_fields;
end

labels{1} = data{1}{col};

index=0;

for i=1:length(data)
    
    index = find(strcmp(data{i}{col},labels)==1);
        
    if length(index)>0;    
        class(i)=index;
    else      
        labels{length(labels)+1}=data{i}{col};
        class(i)=length(labels);   
    end
    
        data{i}{col} = '0'; % to convert properly
    
    for j=1:n_fields
        out(i,j)=str2num(data{i}{j});     
    end
    
    % substitutes number class
    out(i,col)=class(i);  
        
end



            
            
            
            
            
        
        

