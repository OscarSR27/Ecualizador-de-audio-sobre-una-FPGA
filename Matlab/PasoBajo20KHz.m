%Programador: Oscar Soto Rivera
%Curso:Laboratorio de dise�o de sistemas digitales
%Proyecto:Ecualizador de audio

%Esta funcion fue tomada del instructivo del proyecto del ecualizador de audio. Implementa
%la ecuacion de un filtro. El tipo de filtro as� como su frecuencia de corte estan determinados 
%por las constantes

function [ y ] = PasoBajo20KHz( Entrada )
%Filtro paso bajo de 20KHz

%Variables para almacenar las iteraciones de los calculos
fNMenos1 = 0;
fNMenos2 = 0;

%Constantes para el filtro
a1 = 1.591;
a2 = 0.6617;
b0 = 0.8132;
b1 = 1.626;
b2 = 0.8132;

n = length(Entrada); %Longitud de Entrada
y = [];
for i = 1:1:n %Ejecuta la ecuacion del filtro
    f = Entrada(i)-a1*fNMenos1-a2*fNMenos2;
    y(i) = b0*f+b1*fNMenos1+b2*fNMenos2;
    fNMenos2 = fNMenos1;
    fNMenos1 = f;
end

