`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Ecualizador de audio
//
//Descripcion: En este modulo se realiza la concatenacion de los datos provenientes del ADC para que sean compatibles con el ancho de palabra
//					utilizado en las operaciones aritmeticas de los filtros. Tambien se elimina el offset adicionado a la senal por el acondicionamiento
//					analogico
//////////////////////////////////////////////////////////////////////////////////
module Concatenacion_ADC  #(parameter N_ADC = 12,N=23) //Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
(
input wire [N_ADC-1:0]data_ADC,
output wire signed [N-1:0] Entrada_Filtros 
);

//Declaracion de senales utilizadas dentro del modulo
reg signed [N-1:0] Data_23;

always @* //Lista sensitiva, responde ante cualquier estimulo
       begin 
		 Data_23 = {11'd0,data_ADC};	//Se toman 11 bits en las posiciones mas significaticas y se concatenan con los datos provenientes del ADC
		 end 									//El MSB corresponde al bit de signo
		 
Suma #(.N(N)) sum ( //Se aplica la suma con extension de signo de 2^11 que es la mitad de las combinaciones posibles con 12 bits. Al ser una suma con signo
						  //lo que provoca es una resta. Esto se hace para eliminar el offset que sufrio la senal durante el acondicionamiento
						  //analogico
.A(Data_23),
.B(23'b11111111111100000000000),
.SUMA(Entrada_Filtros));

endmodule
