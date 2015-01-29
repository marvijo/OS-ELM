function data=shufflefile(filein,fileout)
%
%       usage :  shufflefile(filein,fileout)
%
%            - Shuffle file lines ( ASCII format ).
%                   
%
NOT_OUTPUT_FILE=0;
OUTPUT_FILE=1;


if nargin<2
    mode = NOT_OUTPUT_FILE
else
    mode = OUTPUT_FILE
end


fid=fopen(filein,'r');

if mode ==OUTPUT_FILE
    fid2=fopen(fileout,'w');
end

% read all lines
i=0;
while 1
    line = fgetl(fid);
    if ~ischar(line)
        break;
    end
    i = i+1;
    
    lines{i}=line;
    
end

% shuffle index
index = randperm(i);

if mode==NOT_OUTPUT_FILE
    %data = lines{index};   %%%%%%%%%%%%%%% arreglar
end

if mode==OUTPUT_FILE
    
    % write all lines
    for j=1:i
        fprintf(fid2,'%s\n',lines{index(j)});
    end
    
    fclose(fid2);
    
    data=true;
end

fclose(fid);


