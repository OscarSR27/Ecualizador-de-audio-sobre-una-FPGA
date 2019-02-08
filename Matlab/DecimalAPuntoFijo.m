%Programador: Oscar Soto Rivera
%Curso:Laboratorio de diseño de sistemas digitales
%Proyecto:Ecualizador de audio

%Este programa toma los valores en decimal utilizados como estimulo para
%los filtros implementados en Matlab y los convierte a formato decimal en 
%punto fijo por medio de la funcion DecAPf. El archivo convertido a binario 
%sera utilizado como estimulo para los filtros implementados en lenguaje 
%Verilog con propositos de simulacion para comparar los resultados teoricos 
%y experimentales.

fileID = fopen('VectorEntrada.txt','r'); %Abre el archivo con los valores en decimal generados como estimulo 
                                         %para los filtros en Matlab
A = fscanf(fileID,'%f');                 %Lee los datos del archivo con formato en coma flotante

Estimulo=fopen('Estimulo.txt', 'wt'); %Abre el archivo txt para escribir los valores en punto fijo
N = size(A); %Longitud de A

Magnitud = 10;%Determina la cantidad de bits en la parte entera
Presicion = 12;%Determina la cantidad de bits en la parte decimal


for i = 1:N %Este ciclo aplica la funcion DecAPf a cada dato de A
    Binario =  DecAPf(A(i), Magnitud, Presicion);
    Binario = num2str(Binario);%Conversion de int a string
    Binario(Binario == ' ') = [];%Eliminar espacio entre caracteres
    fprintf(Estimulo, '%s \n', Binario);%Escritura de datos en el archivo Estimulo.txt
end

fclose(fileID);%Se cierra el archivo VectorEntrada.txt
fclose(Estimulo);%Se cierra el archivo Estimulo.txt