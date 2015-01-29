function  tokens = changeFieldFile(file_in,inpos,outpos,file_out)
%
%   usage :  tokens = changeFieldFile(file_in,file_out,inpos,outpos)
%
%           read lines of 'file_in' and all move column at position 'inpos' 
%           to position 'outpos' and save on 'file_out'. 
%
%   input   file_in : data input file name.
%           file_out: data output file name.
%           inpos   : initial position of column is going to move.
%           outpos  : final position of the column.
%
%   output  tokens : return all lines as cell variables, each one contains
%           all fields of each line.
%
% 

NOT_OUTPUT_FILE=0;
OUTPUT_FILE=1;

if nargin<4
    mode = NOT_OUTPUT_FILE;
else
    mode = OUTPUT_FILE;
end

if nargin<3
    outpos = 0; % final column
end

if nargin<2
    inpos = 1;  % first column
end


fid1 = fopen(file_in,'r');
if (fid1 == -1)
    error('can not open file')
    return;
end

if mode == OUTPUT_FILE
    fid2 = fopen(file_out,'w+');
    if (fid1 == -1)
        error('can not open file')
        return; 
    end
end

% first line
line = fgetl(fid1);

% tokens number
n_fields = numFields(line,2);

if outpos==0
    outpos=n_fields;
end

[tokens{1},newline]=changeLinePos(line,inpos,outpos);

if mode == OUTPUT_FILE
    fprintf(fid2,'%s\n',newline);
end

index = 1;

while 1
    
    line = fgetl(fid1);
    
    if ~ischar(line)
        break; 
    end
    
    index = index + 1;
        
    [tokens{index},newline]=changeLinePos(line,inpos,outpos);
    
    if mode==OUTPUT_FILE
        fprintf(fid2,'%s\n',newline);
    end
    
end


fclose(fid1)

if mode == OUTPUT_FILE
    fclose(fid2)
end
        
    
    
    
    



