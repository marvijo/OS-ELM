% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programa cosa rara
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

randn('state',sum(100*clock));

% Dos vectores
v = [-0.8641, 0.1691, 0.6545, 0.6175, 0.5063, -0.0113, 0.2545, 0.9759, 0.8856];
x = [1, 0.1212, 0.3094, 0.0344, 0.7381, 0.3535, 0.9096, 0.7048, 0.7181];

% multiplicacion n terminos
p1 = v*x';

% multiplicacion n-1 terminos y suma del termino adicional v(1) ( como x(1)=1, no se pone)
p2 = v(2:end)*x(2:end)';
p2 = p2 + v(1);

% multiplicacion n-1 terminos y suma del termino adicional v(1)*x(1)
p3 = v(2:end)*x(2:end)' + v(1)*x(1);

% Resultados ¿¿¿ ?????

disp(strcat('p1 == p2  -> ',num2str(p1==p2)))   % NO SON IGUALES !!!!
disp(strcat('p1 == p3  -> ',num2str(p1==p3)))   % NO SON IGUALES !!!!
disp(strcat('p2 == p3  -> ',num2str(p2==p3)))

disp(strcat('p1 - p2 = ',num2str(p1-p2)))


% Lo mismo, pero aleatoriamente

randn('state',sum(100*clock));

n=1000;

v2 = rand(1,n);
x2 = [1 rand(1,n-1)];

r1 = v2*x2';

r2 = v2(2:end)*x2(2:end)';
r2 = r2 + v2(1);

r3 = v2(2:end)*x2(2:end)' + v2(1)*x2(1);

disp(strcat('r1 == r2  -> ',num2str(r1==r2)))   % NO SON IGUALES !!!! 
disp(strcat('r1 == r3  -> ',num2str(r1==r3)))   % NO SON IGUALES !!!!
disp(strcat('r2 == r3  -> ',num2str(r2==r3)))

