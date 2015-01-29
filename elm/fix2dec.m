function dec=fix2dec(fix,n,m)
%n es el numero de bits de la parte entera
%m es el numero de bits de la parte flotante
%fix es el conjunto de bits que forman el numero
%dec es el valor decimal (real) resultante
fix2=fix;
if fix(1)=='1',
    fix2=cmp2(fix);
end;
    
dec=0;
k=1;
for i=n-1:-1:-m,
    dec=dec+(eval(fix2(k))*2.^i);
    k=k+1;
end

if fix(1)=='1',
    dec=-dec;
end;

