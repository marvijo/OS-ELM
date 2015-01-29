function  [data, data2] = readdata(problem,file,subproblem,ext)
%
%       usage : data = readdata(problem,file,subproblem,ext)
%
%       input :     problem         - Problem directory
%                   file            - file want to be readed
%                   subproblem      - num of instance of te problem
%                   ext             - file extension
%
%       output :    data
%
%

if nargin<4
    ext = '.dat';
end

if nargin<3
    subproblem = 1;
end

% Configuracion
datoselm

% Path total
path = strcat(rootpath,problempath,problem,'\\',num2str(subproblem),'\\');

% filename
filename = strcat(file,num2str(subproblem),ext);

% file path
filepath = strcat(path,filename)

% open file
ar = fopen(filepath,'rt');

if (ar ~= -1)
        
    fil=fscanf(ar,'%d',1);	
	col=fscanf(ar,'%d',1);
    
    data = zeros(fil,col);
    
    for i=1:fil
        
        for j=1:col
            
            Ai=fscanf(ar,'%s',1);	
			data(i,j)=fix2dec(Ai,N1,M1);

        end
        
    end
    
end


data2=0;

if file == 'W'
 
    temp = load(strcat(path,file,'.mat'));
    
    data2 = temp.W;        
end


fclose(ar)