function data = normalizedata(datos,no)

    [N,L]=size(datos);
    
    
% Calcula media y varianza
	m=mean(datos(:,1:end-no));
	s=std(datos(:,1:end-no));
	
	k=find(s==0);
	
	s(k)=1;
	m(k)=0;

% Normaliza datos
	datos(:,1:end-no)=(datos(:,1:end-no)-ones(N,1)*m)./(ones(N,1)*s);
    
    data = datos;
    
    %save('datos_norm.mat','datos')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%