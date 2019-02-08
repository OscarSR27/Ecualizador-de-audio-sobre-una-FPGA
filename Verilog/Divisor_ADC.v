`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Ecualizador de audio
//
//Descripcion: En este modulo se realiza un divisor de frecuencia para generar el reloj de 706 KHz utilizado en la maquina de estados del ADC y el DAC. 
//					Esto se realiza con ayuda de un contador
//////////////////////////////////////////////////////////////////////////////////
module Divisor_Clock_ADC
//Declaracion de senales de entrada y salida
(
 input wire Clck_in,
 input wire reset_Clock,
 output reg Clock_out
 ); 
 
 //Declaracion de senales utilizadas dentro del modulo
 reg [6:0] contador ; 

 
always @(posedge Clck_in,posedge reset_Clock) //Lista sensitiva, responde ante un flanco positivo del Clck_in o reset_Clock
 begin
      if (reset_Clock) //Si el reset esta encendido el contador permanece en cero y la salida de reloj que se quiere generar tambien
		   begin
		   Clock_out <= 0;
			contador <= 0;
			end 
      else
          begin		// Cuando el contador llega a la cuenta de 70 cambia la polaridad del reloj de salida y reinicia la cuenta, generando un reloj
							// de 706KHz. El valor de 70 necesario para obtener esta senal de reloj se obtuvo redondeando al entero mas cercano el resultado
							// de la siguiente formula: [(100MHz/706KHz)/2]-1. Donde 100MHz es el reloj interno de la FPGA y 706KHz el reloj deseado. 
		    if (contador == 7'd70)   
		        begin                    
			     contador <=7'd0;       
		        Clock_out <= ~Clock_out;
		        end 
		     else 
		        contador <= contador + 1'b1; 
          end 
 end 
  
endmodule 