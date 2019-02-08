`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Ecualizador de audio
//
//Descripcion: En este modulo se genera el multiplexor para escoger la salida que se desea escuchar, ya sea la banda de frecuencias
//				   bajas, medias o altas. Ademas se puede seleccionar la suma de todas las bandas de frecuencia para escuchar el audio
//					original
//////////////////////////////////////////////////////////////////////////////////
module Mux_Filtros #(parameter N = 23)//Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
(
 input wire signed [N-1:0] bajos,medios,altos, SalidaTotal,
 input wire [1:0] caso,
 output wire signed [N-1:0] sal_Mux
);
//Declaracion de senales utilizadas dentro del modulo	 
reg signed [N-1:0] sal;

always@* //Lista sensitiva, responde ante cualquier cambio de senal
  begin 
   case(caso)  //Casos para el selector
	2'b00 : sal = bajos ; 
   2'b01 : sal = medios ; 
	2'b10 : sal = altos ; 
	2'b11 : sal = SalidaTotal ;

  default : sal = bajos;  //Salida por defecto
  endcase 
  end 
assign sal_Mux = sal; //Asignacion de salida

endmodule
