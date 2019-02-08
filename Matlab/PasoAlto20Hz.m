%Programador: Oscar Soto Rivera
%Curso:Laboratorio de diseño de sistemas digitales
%Proyecto:Ecualizador de audio

%Esta funcion fue tomada del instructivo del proyecto del ecualizador de audio. Implementa
%la ecuacion de un filtro. El tipo de filtro así como su frecuencia de corte estan determinados 
%por las constantes

function [ y ] = PasoAlto20Hz( Entrada )
%Filtro paso alto de 20Hz

%Variables para almacenar las iteraciones de los calculos
fNMenos1 = 0;
fNMenos2 = 0;

%Constantes para el filtro
a1 = -1.996;
a2 = 0.996;
b0 = 0.998;
b1 = -1.996;
b2 = 0.998;

n = length(Entrada); %Longitud de Entrada
y = [];
for i = 1:1:n %Ejecuta la ecuacion del filtro
    f = Entrada(i)-a1*fNMenos1-a2*fNMenos2;
    y(i) = b0*f+b1*fNMenos1+b2*fNMenos2;
    fNMenos2 = fNMenos1;
    fNMenos1 = f;
end

