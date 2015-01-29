function [x,t]=extractdata(datasource,numclass,numdata)
%
%   usage : [x,t]=extractdata(file,numclass,numdata)
%
%   input       datasource      - source of data to process ( array, data file or mat file ).
%               numclass        - classes number
%               numdata         - data number to extract
%
%   output      x               - data input
%               t               - desired response to data input
%
%
%

if (nargin<3)
    numdata=0;
end

% mat file
if isstr(datasource)
    struct_data = load(file);   
    fieldnames = fields(struct_data);
    alldata = getfield(struct_data,fieldnames{1});
else
    alldata = datasource;
end

if (numdata==0)
    data = alldata;
else
    data = alldata(1:numdata,:)
end
    
x=data(:,1:end-numclass);
x = [ones(size(x,1),1) x];

t = data(:,end-numclass+1:end);

