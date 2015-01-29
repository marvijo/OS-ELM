function vhdl(problem_path)
%
%	vhdl(problem_path)
%
%		problem_path	-	Nombre de la carpeta del problema
%
%	USO : Examina todas las subcarpetas , lee los archivos de datos y coeficientes , y genera los archivos de datos std_logic para el codigo vhdl.
%
%

% Configuracion
datoselm

if (nargin >= 1)
	problempath=problem_path;
end

% Path total
path = strcat(rootpath,problempath);

arc1=fopen(strcat(path,'\\','conf.dat'),'rt');
	eval(fscanf(arc1,'%s',1));
	eval(fscanf(arc1,'%s',1));	
	eval(fscanf(arc1,'%s',1));
	eval(fscanf(arc1,'%s',1));
fclose(arc1)

d=dir(path);

n_sub = length(d);

for k=3:n_sub

    if (d(k).isdir==0)
        continue
    end
    
	name=d(k).name;
		
	if (length(str2num(name))==1)	% El nombre de la carpeta es un numero ------------------
		ext=strcat(name,'.dat');
	else
		ext='.dat';					% El nombre de la carpeta es una string ------------------
	end
   
	% Carga datos del problema
	filename1 = strcat(path,'\\',name,'\\','datos');
	load(filename1);
	
	% Carga pesos capa oculta
	filename2 = strcat(path,'\\',name,'\\','W');
	load(filename2);

	% Write files
	% /////////////////////////////////////////////////////////////////////////
	
	fileW   = strcat(path,'\\',name,'\\','W',ext);
	fileD   = strcat(path,'\\',name,'\\','D',ext);
	fileT   = strcat(path,'\\',name,'\\','T',ext);
	fileV   = strcat(path,'\\',name,'\\','V',ext);
	fileT_V = strcat(path,'\\',name,'\\','T_V',ext);
    
    file_train = strcat(path,'\\',name,'\\','train_in',ext);
	file_test = strcat(path,'\\',name,'\\','test_in',ext);
    
	arc1=fopen(fileW,'wt');
	arc2=fopen(fileD,'wt');
	arc3=fopen(fileT,'wt');
	
	arc4=fopen(fileV,'wt');
	arc5=fopen(fileT_V,'wt');
    
    arc6=fopen(file_train,'wt');
    arc7=fopen(file_test,'wt');
	
	%load datos
	
	fprintf(arc1,'%d\n',NH);
	fprintf(arc1,'%d\n',L+1);
	
	for i=1:NH
		for j=1:L+1
			fprintf(arc1,'%s\n',dec2fix(W(i,j),N1,M1));		% W
		end
	end
	
	fprintf(arc2,'%d\n',L+1);
	fprintf(arc2,'%d\n',NP);

	for i=1:(L+1)
		for j=1:NP
			fprintf(arc2,'%s\n',dec2fix(D(i,j),N1,M1));		% D
		end
	end
	
	fprintf(arc3,'%d\n',NP);
	fprintf(arc3,'%d\n',NO);

	for i=1:NP
        for j=1:NO
            fprintf(arc3,'%s\n',dec2fix(T(i,j),N1,M1));     % T
        end
	end
	
	fprintf(arc4,'%d\n',L+1);
	fprintf(arc4,'%d\n',NP);
	
	for i=1:(L+1)
		for j=1:NV
			fprintf(arc4,'%s\n',dec2fix(V(i,j),N1,M1));		% V
		end
	end
	
	fprintf(arc5,'%d\n',NV);
	fprintf(arc5,'%d\n',NO);
	
	for i=1:NV
        for j=1:NO
		    fprintf(arc5,'%s\n',dec2fix(T_V(i,j),N1,M1));	% T_V
        end        
    end
    
    fprintf(arc6,'%d\n',NP);
	fprintf(arc6,'%d\n',(L+1));
    
    for i=1:NP
        for j=1:(L+1)
            fprintf(arc6,'%s\n',dec2fix(D(j,i),N1,M1));     % train_in
        end    
    end
   
   fprintf(arc7,'%d\n',NV);
   fprintf(arc7,'%d\n',(L+1));
   
   for i=1:NV
        for j=1:(L+1)
            fprintf(arc7,'%s\n',dec2fix(V(j,i),N1,M1));     % test_in
        end    
    end
    
	
	fclose(arc1); fclose(arc2);fclose(arc3);fclose(arc4);fclose(arc5);fclose(arc6);fclose(arc7);
	
	% /////////////////////////////////////////////////////////////////////////
	
end