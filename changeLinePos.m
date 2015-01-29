function  [tokens,newline] = changeLinePos(line,inpos,outpos,token)
%
%   usage [tokens,newline] = changeLinePos(line,inpos,outpos,token)
%
%         Move column in position inpos to position outpos and return the
%         new line.
%
%   input       line        - Line to process.            
%               inpos       - column to move.
%               outpos      - final position.
%               token       - characters used to split tokens.
%
%   output      tokens      - lines splitted as tokens.
%               newline     - new line generated.
%
%

if nargin<4
    token = ' ,';
end

n_fields = numFields(line,2,token);

if nargin<3
    outpos = n_fields;
end

if nargin<2
    inpos = 1;
end

if (length(line)==0 || ~isstr(line))
    error('Not a line or 0-length')
    return;
end

if inpos==outpos
    error('initial pos equal final position')
    return;
end

for i=1:n_fields
    if i~=inpos
        [tok{i},line] =strtok(line,token);
    else
        break;
    end    
end

[finalToken,line] =strtok(line,token);

for i=inpos+1:n_fields    
    [tok{i-1},line] =strtok(line,token);
end

if outpos == 1
    tokens{1} = finalToken;
    tokens(2:n_fields) = tok;
    
elseif outpos==n_fields
    
    tokens = tok;
    tokens{n_fields}=finalToken;
    
else
    tokens(1:outpos-1)=tok(1:outpos-1);
    tokens{outpos} = finalToken;
    tokens(outpos+1:n_fields)=tok(outpos:n_fields-1)
end

newline = tokens{1};

for i=2:n_fields
    temp = strcat(',',tokens{i});
    newline =strcat(newline,temp); 
end


    
    
    







    
    
    
    