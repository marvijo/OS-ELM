function genproblem(filename,pathname,num_neurons,rep,prop)

% Proporcion por defecto
if (nargin < 5 )
prop=0.5;
end

% Numero de repeticiones por defecto
if (nargin < 4)
rep=50;
end

%step1
genera_datos(filename,pathname,rep,prop);

%step2
procesa(pathname,num_neurons);

%step3
vhdl(pathname);