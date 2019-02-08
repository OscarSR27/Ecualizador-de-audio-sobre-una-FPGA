%Programador: Oscar Soto Rivera
%Curso:Laboratorio de diseño de sistemas digitales
%Proyecto:Ecualizador de audio

%Esta funcion toma un numero en decimal y devuelve una representacion
%binaria en punto fijo. Sus parametros de entrada son:
    %NumDec1 = Numero decimal que se desea convertir a binario en punto
    %fijo
    %Magnitud: La cantidad de bits que van a representar la parte entenra
    %Presicion: La cantidad de bits que van a representar la parte
    %fraccionaria
    
function [BinPF] = DecAPf(NumDec1, Magnitud, Presicion)

TBits = Magnitud + Presicion;%Numero total de bits usados para la representacion en punto fijo sin tomar en
                             %cuenta el signo
NumDec2 = NumDec1 * (2^TBits);%Se multiplica el numero decimal por las combinaciones posibles en binario hechas
                              %con una cantidad de bits igual a TBits.
Entero = round(NumDec2);%Se redondea al entero mas cercano.
Conversion = decimalToBinaryVector(abs(Entero), TBits);%Se convierte de decimal a binario. Esta funcion solo
                                                        %acepta numero positivos por lo que se utiliza
                                                        %el valor absoluto

if (Entero >= 0)
    BinPF = [decimalToBinaryVector(0, Magnitud+1) Conversion(1,1:(Presicion))];
                %Se verifica si el signo del valor decimal es entero, de ser asi se concatena un
                %un cero de signo y se hace un desplazamiento a la derecha
                %en una cantidad igual a la Magnitud. Esto se realiza
                %extendiendo el signo
    
else
    BinPF_Aux = [decimalToBinaryVector(0, (Magnitud)) Conversion(1,1:(Presicion))];
                %Si el signo es negativo, primero se hace el desplazamiento
                %a la derecha en una cantidad igual a la Magnitud. Esto se realiza
                %extendiendo el signo
    
    %Ahora se realiza el complemento a dos. Se busca el primer 1 desde el LSB hasta el MSB.
    %Una vez encontrado, todos los bits desde el primer 1 encontrado hasta el LSB se dejan igual, 
    %y todos los demas se invierten
    i = TBits;  
    while BinPF_Aux(1,i:i) ~= 1 %Busqueda del primer 1
        i = i-1;
    end
    BinPF = [1 not(BinPF_Aux(1,1:i-1)) BinPF_Aux(1,i:TBits)]; %Adicion de signo, negacion y concatenacion
end