function fields = numFields(source,type,token)
%
%   usage :  [fields] = numFields(filename,type,token)
%
%               Return number total of fields in each line.
%
%   input       filename    - name of the source of data.
%               type        - type of source
%                                               1 - file
%                                               2 - string line
%
%               tok         - characters used to split tokens. 
%                             (default ' ,' - white space and comma-)
%           
%   output      fields      - number of fields
%         
%

if nargin<3
    token = ' ,';
end

if nargin<2
    type = 1;
end

if type == 1
    fid = fopen(source,'r');
    if (fid == -1)
        error('can not open file')
        return;
    end
    % first line
    line = fgetl(fid);

elseif type==2    
    line = source;
else
    error('type mismatch')
end
    
if ~ischar(line)
    disp('error : input line wrong')
    return;
end
    
fields=0;
    
while 1
        
    if length(line)==0
        break;
    end
        
    [tok,line] =strtok(line,token);
              
    fields = fields + 1;

end


