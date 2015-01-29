function [WO,coef,out_train_matlab,out_train_vhdl,error_train_matlab,error_train_vhdl]=results(pathname,tests)

%clear all

W=0; D=0; G=0;

X=0;Q=0;R=0;

RI=0;H=0;Xinv=0;

WO=0;

% jump
% 0 -- Lee todos los archivos
% 1 -- Lee solo archivo wo

jump = 1;

% Dato de configuracion
datoselm

problempath='problema';

%arc1=fopen(strcat(path,'\\','conf.dat'),'rt');
%	eval(fscanf(arc1,'%s',1));					%  L
%	eval(fscanf(arc1,'%s',1));					% NP	
%	eval(fscanf(arc1,'%s',1));					% NV
%	eval(fscanf(arc1,'%s',1));					% NH
%fclose(arc1)

% Directorio del problema
if (nargin>=1)
    problempath=pathname;
end

% Path total
path = strcat(rootpath,problempath);

d=dir(path);

n_sub = length(d);


if (nargin<2)
	num_tests=n_sub;
else
	num_tests=tests;
end

ite=0;


for sub=3:n_sub								%     REPETICIONES  %%%%%%%%%%%%%%%%%%%%%%%%%

	% Solo procesa subcarpetas
	if (d(sub).isdir==0)
        continue
    end
	
	% Nombre de la carpeta
	name=d(sub).name
	
	if(str2num(name)>num_tests)
		continue;
	end	
	
	ite = ite + 1;
		
	if (length(str2num(name))==1)	% El nombre de la carpeta es un numero ------------------
		ext=strcat(name,'.dat');
	else
		ext='.dat';					% El nombre de la carpeta es una string ------------------
	end
	
	% Ruta del subdirectorio
	filepath = strcat(path,'\\',name);
	
	% Carga datos del problema.................................................................................	W, D, T, V, T_V
	filename1 = strcat(filepath,'\\','datos');
	load(filename1);
	
	% Carga configuracion de bits
	filebits = strcat(filepath,'\\','bits');
	arc1 = fopen(strcat(filebits,ext),'rt');
	eval(fscanf(arc1,'%s',1));					%  N2
	eval(fscanf(arc1,'%s',1));					%  M2	
	fclose(arc1)
	
	bits_integer(ite)=N2;
	bits_decimal(ite)=M2;
	
	% Archivos originales
	ar1 = fopen(strcat(filepath,'\\','W',ext),'rt');
	ar2 = fopen(strcat(filepath,'\\','D',ext),'rt');
	ar3 = fopen(strcat(filepath,'\\','T',ext),'rt');
	
	% Archivos matrices VHDL
    if (jump==0)
	    arc1 = fopen(strcat(filepath,'\\','G',ext),'rt');
	    arc2 = fopen(strcat(filepath,'\\','X',ext),'rt');
	    arc3 = fopen(strcat(filepath,'\\','Q',ext),'rt');
	    arc4 = fopen(strcat(filepath,'\\','R',ext),'rt');
	    arc5 = fopen(strcat(filepath,'\\','RI',ext),'rt');
	    arc6 = fopen(strcat(filepath,'\\','XI',ext),'rt');
	    arc7 = fopen(strcat(filepath,'\\','H',ext),'rt');
    end
    
	arc8 = fopen(strcat(filepath,'\\','WO',ext),'rt');
    arc9 = fopen(strcat(filepath,'\\','out_train',ext),'rt');
	arc10 = fopen(strcat(filepath,'\\','out_test',ext),'rt');
	
    % LECTURA DE MATRICES //////////////////////////////////////////////////////////////////////
	
	k=1;
	j=1;
	
	% Pesos capa oculta ------------------------------------ bits reducidos
	if (ar1 ~= -1)
	
		fil=fscanf(ar1,'%d',1);	
		col=fscanf(ar1,'%d',1);
		
		NH=fil;									% NUMERO DE NEURONAS **************
		
		L=col-1;								% NUMERO DE CAMPOS*****************
		
		for i=1:fil*col
	
			Ai=fscanf(ar1,'%s',1);	
			Adec=fix2dec(Ai,N1,M1);
	
			W(k,j)=Adec;
	
			j=j+1;
			if j>col
				j=1;
				k=k+1;
			end
	
		end
		
		fclose(ar1);
		
	end
	
		k=1;
	j=1;

	% Datos de entrenamiento ------------------------------------ bits reducidos
	if (ar2 ~= -1)
	
		fil=fscanf(ar2,'%d',1);	
		col=fscanf(ar2,'%d',1);
		
		NP=col;									% NUMERO DE PATRONES ****************
	
		for i=1:fil*col
	
			Ai=fscanf(ar2,'%s',1);	
			Adec=fix2dec(Ai,N1,M1);
	
			D(k,j)=Adec;
	
			j=j+1;
			if j>col
				j=1;
				k=k+1;
			end
	
		end
		
		fclose(ar2);
		
	end
	
	k=1;
	j=1;

	% Salidas deseadas -------------------------------------------- bits reducidos
	if (ar3 ~= -1)
	
		fil=fscanf(ar3,'%d',1);	
		col=fscanf(ar3,'%d',1);
	
		for i=1:fil*col
	
			Ai=fscanf(ar3,'%s',1);	
			Adec=fix2dec(Ai,N1,M1);
	
			T(k,j)=Adec;
	
			j=j+1;
			if j>col
				j=1;
				k=k+1;
			end
	
		end
		
		fclose(ar3);
		
	end
	
	k=1;
	j=1;
	
	%jump=1;
	
	if (jump==0)    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lectura de todas las memorias %%%%%%%%%%%%%%%%%%%%%%%%																		
	
	% Read G ( Original Matrix )   --------  G = W*D
	if (arc1 ~= -1)
		
		fil=fscanf(arc1,'%d',1)	
		col=fscanf(arc1,'%d',1)

		for i=1:fil*col

			Ai=fscanf(arc1,'%s',1);
			Adec=fix2dec(Ai,N2,M2);
	
			G(k,j)=Adec;
	
			j=j+1;
			if j>col
				j=1;
				k=k+1;
			end
		end
		
		fclose(arc1);
		
	end
	
	k=1;
	j=1;

	% Read X ( Original Matrix )   --------  X = G * G'
	if (arc2 ~= -1)
	
		fil=fscanf(arc2,'%d',1);	
		col=fscanf(arc2,'%d',1);
	
		for i=1:fil*col
	
			Ai=fscanf(arc2,'%s',1);	
			Adec=fix2dec(Ai,N2,M2);
	
			X(k,j)=Adec;
	
			j=j+1;
			if j>col
				j=1;
				k=k+1;
			end
		end
		
		fclose(arc2);

	end
	
	k=1;
	j=1;

	% Read Q  --------------------------------  QRD(X)
	if (arc3 ~= -1)
	
		fil=fscanf(arc3,'%d',1);	
		col=fscanf(arc3,'%d',1);
	
		for i=1:fil*col

			Ai=fscanf(arc3,'%s',1);	
			Adec=fix2dec(Ai,N2,M2);
	
			Q(k,j)=Adec;
	
			j=j+1;
			if j>col
				j=1;
				k=k+1;
			end
		end
		
		fclose(arc3);
	
	end
	
	k=1;
	j=1;
	
	% Read R  --------------------------------  QRD(X)
	if (arc4 ~= -1)
	
		fil=fscanf(arc4,'%d',1);	
		col=fscanf(arc4,'%d',1);
	
		for i=1:fil*col

			Ai=fscanf(arc4,'%s',1);	
			Adec=fix2dec(Ai,N2,M2);
	
			R(k,j)=Adec;
	
			j=j+1;
			if j>col
				j=1;
				k=k+1;
			end
		end
	
		fclose(arc4);
		
	end
		
	k=1;
	j=1;

	% Read RI  --------------------------------  inv(R)
	
	if (arc5 ~= -1)
	
		fil=fscanf(arc5,'%d',1);	
		col=fscanf(arc5,'%d',1);
		
		for i=1:fil*col

			Ai=fscanf(arc5,'%s',1);	
			Adec=fix2dec(Ai,N2,M2);
	
			RI(k,j)=Adec;
	
			j=j+1;
			if j>col
				j=1;
				k=k+1;
			end
		end
		
		fclose(arc5);
		
	end
	
	k=1;
	j=1;   

	% Read XI  --------------------------------  inv(X)
	if (arc6 ~= -1)
	
		fil=fscanf(arc6,'%d',1);	
		col=fscanf(arc6,'%d',1);
		
		for i=1:fil*col

			Ai=fscanf(arc6,'%s',1);	
			Adec=fix2dec(Ai,N2,M2);
	
			Xinv(k,j)=Adec;
	
			j=j+1;
			if j>col
				j=1;
				k=k+1;
			end
		end
		
		fclose(arc6);
		
	end
	
	k=1;
	j=1;

	% Read H  --------------------------------  XI*G
	if (arc7 ~= -1)
	
		fil=fscanf(arc7,'%d',1);	
		col=fscanf(arc7,'%d',1);
		
		for i=1:fil*col

			Ai=fscanf(arc7,'%s',1);	
			Adec=fix2dec(Ai,N2,M2);
	
			H(k,j)=Adec;
	
			j=j+1;
			if j>col
				j=1;
				k=k+1;
			end
		end
		
		fclose(arc7);
	
	end
	
	k=1;
	j=1;
	
    end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lectura de todas las memorias %%%%%%%%%%%%%%%%%%%%%%%%


	% Read WO  --------------------------------  Pesos de capa de salida
	if (arc8 ~= -1)
	        
		metodo = fscanf(arc8,'%d',1);		% Metodo de calculo coeficientes WO
	
		fil=fscanf(arc8,'%d',1);	
		col=fscanf(arc8,'%d',1);
		
		for i=1:fil*col
	        
			Ai=fscanf(arc8,'%s',1);
			Adec=fix2dec(Ai,N2,M2);
	
			WO(k,j)=Adec;
	
			j=j+1;
			if j>col
				j=1;
				k=k+1;
			end
		end
		
		fclose(arc8);
		
	end
    
    % Read output training data  --------------------------------  salida
    if (arc9 ~= -1)
        
        fil=fscanf(arc9,'%d',1);	
		col=fscanf(arc9,'%d',1);
        
        for i=1:fil
            
            for j=1:col
            
                Ai=fscanf(arc9,'%s',1);
			    Adec=fix2dec(Ai,N2,M2);
                
                out_train_vhdl(i,j)=Adec;             
       
            end
        end
        
        fclose(arc9);
    end
    
    % Read output testing data  --------------------------------  salida
    if (arc10 ~= -1)
        
        fil=fscanf(arc10,'%d',1);	
		col=fscanf(arc10,'%d',1);
        
        NV = fil;
        
        for i=1:fil
            
            for j=1:col
            
                Ai=fscanf(arc10,'%s',1);
			    Adec=fix2dec(Ai,N2,M2);
                
                out_test_vhdl(i,j)=Adec;             
       
            end
        end
        
        fclose(arc10);
    end
	
	
	num_neuronas(ite) = NH;
	num_patrones(ite) = NP;
	
	
	%  Matlab ///////////////////////////////////////////////////////////////////////////////////////////////////
	%
	%			metodo = 1		Matriz X cuadrada calculando todos los pasos secuencialmente ( XI, H .... )
	%			metodo = 2		Matriz X cuadrada calculando los pasos en paralelo ( No calcula XI, H .....)
	%			metodo = 3		Matriz X=G rectangular ( No existe X,XI,H ....)
	%
	%  //////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    
    % --------------------------------------------------------
	% Calculo de matrices ------------------------------------
	% --------------------------------------------------------
    
	ncond(ite)=cond(W*D);
	
	if (metodo==3)		
		G2=fuzzyfunc(D'*W');
		[Q2 R2]=QRD(G2);
	else
		G2=fuzzyfunc(W*D);
        %G2=sigfunc(W*D);
		X2=G2*G2';
		[Q2 R2]=QRD(X2);	
	end
	
	RI2=inv(R2);
	
	if ( metodo == 1 )
		XI = RI2*Q2';
		H2=XI*G2;
		%coef = H2*T
        %pause
        %coef = pinv(G2')*T
        
        %[coef,coef2,out]=elm(W,D,T)
        [coef,out]=elm_round(W,D,T,16,16)

	end
	
	if ( metodo==2)
		coef = RI2*Q2'*G2*T;
	end
	
	if (metodo==3)
		coef = RI2*Q2'*T;
	end
	
    % --------------------------------------------------------
	% --------------------------------------------------------
	% --------------------------------------------------------
    
	% Salvamos coeficientes calculados
	
   		wo_all(1:NH,ite) = WO(:,1);
	
		coef_all(1:NH,ite) = coef(:,1);
	
	% Error medio de los coeficientes
	errores_WO(ite) = sum(sum(abs(coef-WO)))/length(WO);
	
	% Calculo de salidas y test de algoritmo
	
		% Matlab----------------------------------------------------------
		%out_train_matlab = coef'*sigfunc(W*D);
        out_train_matlab = coef'*fuzzyfunc(W*D,2);
		%out_test_matlab  = coef'*sigfunc(W*V);
        out_test_matlab  = coef'*fuzzyfunc(W*V);
		
		% Vhdl -------------------------------------------------------------
		%out_train_vhdl = WO'*fuzzyfunc(W*D);
		%out_test_vhdl  = WO'*fuzzyfunc(W*V);

	% Calculo de errores RMSE ( Root Mean Square Error )
	
		% Matlab----------------------------------------------------------
		%error_train_matlab(ite)=sqrt(mean((T-out_train_matlab').^2));
		%error_test_matlab(ite)=sqrt(mean((T_V-out_test_matlab').^2));
		
		% Vhdl -------------------------------------------------------------
		%error_train_vhdl(ite)=sqrt(mean((T-out_train_vhdl').^2));	
		%error_test_vhdl(ite)=sqrt(mean((T_V-out_test_vhdl').^2));
		
		% Vhdl vs Matlab -----------------------------------------------
		%error_train(ite) = sqrt(mean((out_train_matlab' - out_train_vhdl').^2));  
		%error_test(ite) = sqrt(mean((out_test_matlab' - out_test_vhdl').^2));

	% Calculo de errores MAE ( Mean Avergae Error )
	
    classification = 1;
    
    if (classification==0)
        
		% Matlab----------------------------------------------------------
		error_train_matlab(ite)=mean(abs(T-out_train_matlab'));
		error_test_matlab(ite)=mean(abs(T_V-out_test_matlab'));
	
		% Vhdl -------------------------------------------------------------
		error_train_vhdl(ite)=mean(abs(T-out_train_vhdl));	
		error_test_vhdl(ite)=mean(abs(T_V-out_test_vhdl));
		
		% Vhdl vs Matlab -----------------------------------------------
		error_train(ite) = mean(abs(out_train_matlab' - out_train_vhdl));  
		error_test(ite) = mean(abs(out_test_matlab' - out_test_vhdl));
	
    else
        
        % VERIFICAR :
        %               1 - Numero de datos de validacion NV
        %               2 - obtener numlabels
        %               3 - T y T_V con dimensiones NP x numlabels
        
        numlabels = NO;
           
        % Matlab----------------------------------------------------------
        error_train_matlab(ite) = (1-sum(sum(win(out_train_matlab') == T,2)==numlabels)/NP)*100;
		error_test_matlab(ite)  = (1-sum(sum(win(out_test_matlab') == T_V,2)==numlabels)/NV)*100;
	
		% Vhdl -------------------------------------------------------------
		error_train_vhdl(ite)=(1-sum(sum(win(out_train_vhdl) == T,2)==numlabels)/NP)*100;
		error_test_vhdl(ite)=(1-sum(sum(win(out_test_vhdl) == T_V,2)==numlabels)/NV)*100;
		
		% Vhdl vs Matlab -----------------------------------------------
		error_train(ite) = (1-sum(sum(win(out_train_matlab') == win(out_train_vhdl),2)==numlabels)/NP)*100;
		error_test(ite) =(1-sum(sum(win(out_test_matlab') == win(out_test_vhdl),2)==numlabels)/NV)*100; 
        
    end
end

file_results = strcat(path,'\\','results_vhdl.mat');
file_conf = strcat(path,'\\','conf.mat');

save(file_results,'wo_all','coef_all','errores_WO', 'error_train_matlab','error_test_matlab','error_train_vhdl','error_test_vhdl','error_train','error_test');
save('results_vhdl.mat','wo_all','coef_all','errores_WO', 'error_train_matlab','error_test_matlab','error_train_vhdl','error_test_vhdl','error_train','error_test');

save(file_conf,'num_neuronas','num_patrones','L','bits_integer','bits_decimal');
save('conf.mat','num_neuronas','num_patrones','L','bits_integer','bits_decimal');

	