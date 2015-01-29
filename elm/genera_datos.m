function D=genera_datos(filename,pathname,rep,prop,num_dat)
%
%	genera_datos(filename,pathname,rep,prop,num_dat)
%
%
%	filename	-	Nombre de Archivo de los datos ( Formato .mat ó .dat )
%	pathname	-	Carpeta del problema
%	rep			-	Repeticiones con distintas variaciones de los mismos datos			Opcional  ( por defecto, 50)
%	prop		-	Proporcion de datos de entrenamiento								Opcional ( por defecto, 0.5)
%	num_dat		-	Numero de datos seleccionados del archivo inicial 'filename'		Opcional ( por defecto, TODOS )
%
%	USO :
%		1. Si rep > 50 , crea rep carpetas numeradas y dentro crea archivo de datos aleatoriamente repartidos entre entrenamiento y validacion.
%		2. Si rep=1, genera el archivo de datos en la propia carpeta del problema.	
%

% Proporcion por defecto
if (nargin < 4 )
prop=0.5;
end

% Numero de repeticiones por defecto
if (nargin < 3)
rep=50;
end

% Configuracion
datoselm

% Directorio del problema
if (nargin>1)
    problempath=pathname;
end

% Path total
path = strcat(rootpath,problempath);

if not(isdir(path))
	mkdir(rootpath,problempath);
end

[name ext]=strtok(filename,'.');

if ( ( strcmp(ext,'.mat') ) || ( length(ext)==0 )  )

	% Carga datos
	s=load(filename);
	
	datos=s.datos;
end

if ( strcmp(ext,'.data') )
	datos=load(filename);
end

if (nargin==5)
	datos=datos(1:num_dat,:);
end

% Dimension
[N,L]=size(datos);


% Numero de patrones entrenamiento
NE = fix(N*prop);

% Numero de patrones validacion 
NV = N-NE;

% Numero de campos de vector de entrada
L = L-NO;

% Salva configuracion

arc1=fopen(strcat(path,'\\','conf.dat'),'wt');

fprintf(arc1,'L=%d\n',L);
fprintf(arc1,'NP=%d\n',NE);
fprintf(arc1,'NV=%d\n',NV);

fclose(arc1);

% Normaliza datos

a=0;
b=1;

kk=zeros(size(datos,2),1);
pp=zeros(size(datos,2),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CODE

%for i=1:size(datos,2)

%	if (i==size(datos,2))
%		a=-1;
%		b=1;
%	end
	
%	if (max(datos(:,i))~=min(datos(:,i)))
%		kk(i) = (b-a)/(max(datos(:,i))-min(datos(:,i)));
%	else
%		kk(i) = (b-a)/2;
%	end
	
%	pp(i) = a-kk(i)*min(datos(:,i));

%	datos(:,i)=kk(i)*datos(:,i)+pp(i)*ones(size(datos,1),1);
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CODE

% Calcula media y varianza
	m=mean(datos(:,1:end-NO));
	s=std(datos(:,1:end-NO));
	
	k=find(s==0);
	
	s(k)=1;
	m(k)=0;

% Normaliza datos
	datos(:,1:end-NO)=(datos(:,1:end-NO)-ones(N,1)*m)./(ones(N,1)*s);
    %save('datos_norm.mat','datos')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	
randn('state',sum(100*clock));

for k=1:rep

	% Orden aleatorio
	r=randperm(N);
	
	% Numero patrones para train y validacion
	indicest=r(1:NE);
    indicesv=r(NE+1:end);
	
	% Datos de entrenamiento ////////////////////
		
		% input -----------
		D=datos(indicest,1:end-NO);
        %D=D/10;
		%pause
        
		%D=D(1:end-1,:);
		
		% output ----------
		T=datos(indicest,end-NO+1:end);
		
		%T=T(1:end-1,:);
			
		D=[D ones(NE,1)];
		D=D'
        
        
		
	% Datos de validacion      ////////////////////
       
	    % input -----------
		V=datos(indicesv,1:end-NO);
        %V=V/10;
        %pause
        
        %output ----------
		T_V=datos(indicesv,end-NO+1:end);
		
		V=[V ones(NV,1)];
		V=V';
		
	% Ruta de archivos ( Si solo hay una iteracion, no crea subcarpetas)
	if (rep==1)
		filename = strcat(path,'\\','datos');
	else
		filename = strcat(path,'\\',num2str(k),'\\','datos');
		if not(isdir(strcat(path,num2str(k))))
			mkdir(path,num2str(k));
		end
	end
	
	save(filename,'D','T','V','T_V')
	
%	save(strcat(path,'\\','st'),'m','s');
	
end