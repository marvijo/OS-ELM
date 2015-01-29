function [fixbin]=dec2fix(dec,n,m) %fix bin contiene el numero binario resultante
%n es el numero de bits despues del punto
aux=double(abs(dec));
% n=5;
% m=3;

for i=n-1:-1:-m,
    v=aux/2.^i;
    if (v>=1),
        c='1';
%         fprintf('1');
        aux=aux-2.^i;
    else
        c='0';
%         fprintf('0');
    end

    if i==0,
%         fprintf('.');
    end
    
    if i==n-1,
        fixbin=c;
    else
        fixbin=char(fixbin,c);
    end
end
%fprintf('\t');
fixbin=fixbin';

if fix2dec(fixbin,n,m)==0
    fixbin(end)='1';
end

if dec<0,
    fixbin=cmp2(fixbin);
end
    
