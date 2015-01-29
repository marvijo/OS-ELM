function procesa(problempath,NH,subproblem)
%
%	procesa(problempath,NH,subproblem)
%
%		problempath	-	Carpeta del problema
%		NH			-	Numero de neuronas de la capa oculta
%		Subproblem	-	Subcarpeta para los coeficientes que se van a crear		Opcional
%
%
%	USO :
%		1. Si no se proporciona Subproblem, lee los archivos de datos de todas las subcarpetas con nombre de numero y crea los correspondientes archivos de coeficientes.
%
%		2. Si se proporciona subproblem, crea una carpeta con nombre subproblem y dentro crea los coeficientes correspondientes.
%

path = problempath;

% Root Path
%rootpath = 'D:\\Datos PFC\\';		
%rootpath = 'D:\\'
datoselm

% revover problempath
problempath = path;

% Path total
path = strcat(rootpath,problempath);

%a=-1;
%b=1;

arc1=fopen(strcat(path,'\\','conf.dat'),'rt');

eval(fscanf(arc1,'%s',1));
eval(fscanf(arc1,'%s',1));	
eval(fscanf(arc1,'%s',1));	

fclose(arc1)

arc1=fopen(strcat(path,'\\','conf.dat'),'wt');

fprintf(arc1,'L=%d\n',L);
fprintf(arc1,'NP=%d\n',NP);
fprintf(arc1,'NV=%d\n',NV);
fprintf(arc1,'NH=%d\n',NH);

fclose(arc1)

d=dir(path);

n_sub = length(d);

if (nargin<3)

	arc1=fopen(strcat(path,'\\','conf.dat'),'wt');

	fprintf(arc1,'L=%d\n',L);
	fprintf(arc1,'NP=%d\n',NP);
	fprintf(arc1,'NV=%d\n',NV);
	fprintf(arc1,'NH=%d\n',NH);

	fclose(arc1)

	for k=3:n_sub

		if ( (d(k).isdir == 1) & (isempty(num2str(d(k).name))==0) )
	
			subpath=strcat(path,'\\',d(k).name);
		
			for j=1:length(NH)
		
				if length(NH)==1
					filename = strcat(subpath,'\\','W');
				else
					filename = strcat(subpath,'\\','W',num2str(NH(j)));
				end
			
				%  Pesos Capa oculta ------------------------------------------------------------
				for i=1:NH(j)
					W(i,:) = (a + (b-a).*rand(1,L+1))*c
                    
				end
		
                pause
				save(filename,'W');
		
			end	
		
		end
        		
	end

elseif (nargin==3)

	% Checkea  carpeta
	if not(isdir(strcat(rootpath,'\\',subproblem)))
		mkdir(rootpath,subproblem);
	end
	
	subpath1=strcat(rootpath,'\\',problempath);
	subpath2=strcat(rootpath,'\\',subproblem);
			
	arc1=fopen(strcat(subpath2,'\\','conf.dat'),'wt');

	fprintf(arc1,'L=%d\n',L);
	fprintf(arc1,'NP=%d\n',NP);
	fprintf(arc1,'NV=%d\n',NV);
	fprintf(arc1,'NH=%d\n',NH);

	fclose(arc1)
	
	randn('state',sum(100*clock));

	for k=3:n_sub
	
		if ( (d(k).isdir == 1) & (isempty(num2str(d(k).name))==0) )
				

		
			% Genera coeficientes
			for i=1:NH
				W(i,:) = a + (b-a).*rand(1,L+1);
			end
			
			if not(isdir(strcat(subpath2,'\\',d(k).name)))
				mkdir(subpath2,d(k).name);
			end
		
			% Salva coeficientes
			filename=strcat(subpath2,'\\',d(k).name,'\\','W');		
			save(filename,'W');
        
			% Salva datos
			load(strcat(subpath1,'\\',d(k).name,'\\','datos'));
        
			filename=strcat(subpath2,'\\',d(k).name,'\\','datos');
			
			save(filename,'D','T','V','T_V');
			
		else
		
						
			
		end
		
	end
		
end
	
