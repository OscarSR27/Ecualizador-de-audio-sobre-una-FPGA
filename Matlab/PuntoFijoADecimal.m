%Programador: Oscar Soto Rivera
%Curso:Laboratorio de diseño de sistemas digitales
%Proyecto:Ecualizador de audio

%Este programa toma los valores en binario de las salidas de los filtros
%implementados con lenguaje Verilog y los convierte a decimal. Esto con el
%objetivo de faciliar la comparacion del modelo teorico de los filtros 
%implementados en Matlab.

A = textread('Estimulo.txt','%s', 'delimiter','\n'); %Abre el archivo con los valores en binario generados 
                                                     %por los filtros implementados con lenguaje Verilog            
                                                     %y lee los datos del archivo con formato string 
                                                     %y usando como delimitador el salto de linea


Salida=fopen('Salida.txt', 'wt'); %Abre el archivo txt para escribir los valores en decimal
N = size(A); %Longitud de A

Magnitud = 10;%Determina la cantidad de bits en la parte entera
Presicion = 12;%Determina la cantidad de bits en la parte decimal


for i = 1:N %Este ciclo aplica la funcion PfADec a cada dato de A
    Decimal =  PfADec(A(i), Magnitud, Presicion);
    fprintf(Salida, '%6f \n', Decimal);%Escritura de datos en el archivo Salida.txt
end

fclose(Salida);%Se cierra el archivo Salida.txt