%Programador: Oscar Soto Rivera
%Curso:Laboratorio de diseño de sistemas digitales
%Proyecto:Ecualizador de audio

%Esta funcion toma un numero en binario en punto fijo y devuelve una 
%representacion decimal. Sus parametros de entrada son:
    %NumBin = Numero binario que se desea convertir a decimal
    %Magnitud: La cantidad de bits que van a representar la parte entenra
    %Presicion: La cantidad de bits que van a representar la parte
    %fraccionaria

function [Dec] = PfADec(NumBin, Magnitud, Presicion)

TBits = Magnitud + Presicion;%Numero total de bits usados para la representacion en punto fijo
                             %tomando en cuenta el signo
NumBin = char(NumBin);%Conversion de cell a char para simplificar el recorrido sobre los elementos

if (NumBin(1,1:1) == '0')%Si el numero binario es positivo se convierte a su representacion en decimal.
                         
                         %Una vez en decimal se devuelve el proceso
                         %matematico que se utilizo para su conversion a
                         %binario diviendo por las combinaciones posibles 
                         %en binario hechas con una cantidad de bits igual 
                         %a TBits (2^TBits). 
                         %Sin embargo ya que el numero en binario
                         %sufrio un desplazamiento a la derecha (lo que es 
                         %igual a dividir) por una cantidad igual a la 
                         %Magnitud, esta ya fue dividida por 2^Magnitud, 
                         %Asi que eso se resta al exponente TBits para
                         %obtener la cantidad correcta por la cual hay que
                         %dividir el numero en decimal.
    Dec = bin2dec(NumBin)/(2^(TBits-Magnitud));
else    
    %Si el numero binario es negativo se realiza el complemento a dos. Se busca el primer 1 desde el 
    %LSB hasta el MSB. Una vez encontrado, todos los bits desde el primer 1 encontrado hasta el LSB 
    %se dejan igual, y todos los demas se invierten
    i = TBits+1;
    NumBinArray = (1:1:(TBits+1)); %Debido a que se haran operaciones logicas bit a bit se transforma el
                                   %char en un arreglo de strings
    for k = 1:TBits+1
        NumBinArray(1,k:k) = str2num(NumBin(1,k:k));%Escritura en el arreglo NumBinArray
    end
    
    while NumBinArray(1,i:i) ~= 1%Busqueda del primer 1
        i = i-1;
    end
    NumBin_C2 = [not(NumBinArray(1,1:i-1)) NumBinArray(1,i:TBits+1)];%Negacion de bits y concatenacion
    
    Dec = -1*(binaryVectorToDecimal(NumBin_C2)/(2^(TBits-Magnitud)));%Se transforma el numero a decimal con
                                                                     %el mismo proceso explicado para el
                                                                     %caso de binarios positivos con la
                                                                     %diferencia de multiplicar por -1
end