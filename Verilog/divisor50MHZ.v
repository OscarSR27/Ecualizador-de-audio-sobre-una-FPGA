`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Ecualizador de audio
//
//Descripcion: En este modulo se realiza un divisor de frecuencia para generar el reloj de 50MHz que gobernara la mayoria de los modulos a exepcion del 
//					ADC y el DAC 
//////////////////////////////////////////////////////////////////////////////////
module divisor50MHZmodule 
//Declaracion de senales de entrada y salida
(
 input wire Clck_in,
 input wire reset_Clock,
 output reg Clock_out
); 
 
 

 
always @(posedge Clck_in,posedge reset_Clock) //Lista sensitiva, responde ante un flanco positivo del Clck_in o reset_Clock
 begin
      if (reset_Clock) //Si el reset esta encendido el contador permanece en cero y la salida de reloj que se quiere generar tambien
		   begin
		   Clock_out <= 0;
			end 
      else
          begin		// Debido a que cada cambio de 1 a 0 en la senal Clock_out ocurre hasta el flanco positivo del reloj de entrada, es decir un 
							// periodo completo, cada cambio en Clock_out ocurrira a la mitad de la frecuencia del reloj de entrada. Ya que este tiene un
							// valor de 100 MHz, la senal de reloj resultante de este modulo sera 50 MHz
		    if (Clock_out == 0)  
		        begin                        
		        Clock_out <= Clock_out+1'b1;
		        end 
		     else 
		        Clock_out <= 0; 
          end 
 end 
  
endmodule 

