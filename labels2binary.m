function labels2binary(filename_in,filename_out,inpos,outpos)
%
%           usage :  labels2binary(filename_in,filename_out,inpos,outpos)
%
%                   read 'filename_in', convert labels to binary format 
%                   and write to the 'filename_out' file.   
%    
%           input       filename_in     - data input file.
%                       filename_out    - results file.
%                       inpos           - column to move.
%                       outpos          - final position.
%
%

if nargin<4
    outpos = 0;
end

if nargin>2
    
    tokens = changeFieldFile(filename_in,inpos,outpos);
    
    filename_in = tokens;
    
end

if nargin<2
    filename_out = 'out.data';
end

fid = fopen(filename_out,'w');

if (fid == -1)
    error('can not open file')
    return;
end
        
% change labels to numbers
[labels,data] = labels2num(filename_in);

% change numbers to binary outputs
[out,numlabels] = labelprocess(data);

% save results
for i=1:size(out,1)
    
    line=num2str(out(i,1));
    
    for j=2:size(out,2)
        line = strcat(line,',',num2str(out(i,j)));
    end
    
    fprintf(fid,'%s\n',line);
    
end
 
fclose(fid);