% Scmp=cmp2(s1), realiza el complemento a 2 de la cadena binaria 's1',
% 
% El resultado es devuelto a la cadena Scmp
% Ejemplo:
% s1='10010';       % representa un -12
% s=cmp2(s1)
%     s =
%         01110     % su complemento a 2 es un 12

%% Definicion del cuerpo de la funcion
function Scmp=cmp2(s1)
s1v=bin2dec(s1);
n=length(s1);
s1cmp2=bitcmp(s1v,n)+1; 
Scmp=dec2bin(s1cmp2,n);