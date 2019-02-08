%Programador: Oscar Soto Rivera
%Curso:Laboratorio de diseño de sistemas digitales
%Proyecto:Ecualizador de audio

%Este programa genera una funcion de rampa para estimular los filtros
%hechos en Matlab y lenguaje Verilog.

rampa = fopen ('FuncRampa.txt','wt');%Se abre el archivo para escritura
Tiempo = 0:2.2676e-5:100*2.2676e-5;%Se especifica el paso entre cada intervalo de tiempo

for i = 1:101%Se genera la funcion rampa basandose en los intervalos de tiempo
             %y el uso de la ecuacion lineal y = mx + b. La combinacion de una
             %funcion lineal con pendiente positiva y otra con pendiente
             %negativa dan por resultado la funcion de rampa que se quiere
             %generar
    if (i <= 50)
    y(i) = (176.5*Tiempo(i))-0.1;
    else
    y(i) = ((-176.5*Tiempo(i))+0.1)+2*y(50);
    end
    fprintf(rampa,'%f\n',y(i));%Escritura de datos
end

fclose(rampa);%Se cierra el archivo FuncRampa.txt
load FuncRampa.txt;%Se carga el archivo FuncRampa y se grafica contra el tiempo para comprobar su funcionamiento
plot (Tiempo, FuncRampa,'x');