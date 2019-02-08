`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Ecualizador de audio
//
//Descripcion: En este modulo se realiza el truncamiento y preparacion de los datos para ingresar al DAC
//////////////////////////////////////////////////////////////////////////////////

module Truncamiento_DAC #(parameter N_ADC = 12, Magnitud=8, Decimal=14, N = Magnitud+Decimal+1) //Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
(
input wire signed [N-1:0] Salida_Filtros ,
output wire  [N_ADC-1:0] Dac
);

//Declaracion de senales utilizadas dentro del modulo
wire signed [N-1:0] Data_23;

	 
Suma #(.N(N)) sum ( //Se aplica la suma con extension de signo de 2^11 que es la mitad de las combinaciones posibles con 12 bits.
						  //Esto se hace para agregar de nuevo el offset que se elimino posterior a la salida de los datos del ADC. De esta
						  //manera se mantiene la concordancia entre las conversiones
.A(Salida_Filtros),
.B(23'b00000000010000000000000),
.SUMA(Data_23));

assign Dac = Data_23 [N-2-Magnitud:Decimal-12];//Truncamiento de datos

endmodule
