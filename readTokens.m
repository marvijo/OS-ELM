function tokens = readTokens(filename,token)
%
%
%   usage :     tokens = readTokens(filename,token)
%
%               Read all tokens of filename, returning them as cell data.
%
%   input           filename    - name of the file to process.
%                   token       - characters used to split tokens.
%
%   output          tokens      - cell of tokens.
%

if nargin<2
    token = ' ,';
end

fid= fopen(filename,'r');

if (fid == -1)
    error('can not open file')
    return;
end

line = fgetl(fid);
 
index = 0;

while 1
    
    index = index + 1;
    
    [tok{index},line] =strtok(line,token);
    
    if length(line)==0
        break;
    end
    
end

tokens{1}=tok;

n_fields = index;

index=1;

while not(feof(fid))
    
    line = fgetl(fid);
    
    if (length(line)==0 || ~isstr(line))
        error('Not a line or 0-length')
    end
    
    index = index + 1;
    
    for i=1:n_fields
    
        [tok{i},line] =strtok(line,token);
  
    end
    
    tokens{index}=tok;
    
end

fclose(fid)