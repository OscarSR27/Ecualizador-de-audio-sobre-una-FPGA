`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//Programador: Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Ecualizador de audio
//
//Descripcion: Se realiza el testbench para simular el sistema digital. Las entradas se cargan por medio del archivo Estimulo.txt generado
//					en Matlab. La salide del testbench genera el archivo SalidaTruncadoParaDAC.txt. Este archivo debe ser convertido de binario
//					a decimal utilizando el programa de Matlab PuntoFijoADecimal.m, y de esta forma realizar la comparacion con el modelo teorico
//					de los filtros hechos en Matlab
//////////////////////////////////////////////////////////////////////////////////

module PruebaNueva;

	// Entradas
	reg Reset;
	reg clock_In;
	reg data_ADC;
	reg start;
	reg [1:0] Filtro;
	// Salidas
	wire done;
	wire CS;
	wire Clock_Muestreo1;
	wire Sync;
	wire Data_DAC;
	wire [3:0] data_basura;
	//Para Revision
	wire [11:0]Dac;

	// Unit Under Test (UUT)
	Proyecto_1 uut (
		.Reset(Reset), 
		.clock_In(clock_In), 
		.data_ADC(data_ADC), 
		.start(start),
		.Filtro(Filtro), 
		.done(done), 
		.CS(CS), 
		.Clock_Muestreo1(Clock_Muestreo1), 
		.Sync(Sync), 
		.Data_DAC(Data_DAC), 
		.data_basura(data_basura), 
		.Dac(Dac)
	);

integer SalidaTruncadoDAC, k;
reg [11:0]VariableAux;
reg [13:0]mem[5000:0];//Se genera una memoria para abir el fichero .txt, donde la primera parametrizacion (los primeros parentesis cuadrados 
							 //leyendo de izquierda a derecha) son para determinar el tamaño de los bits en el arreglo, mientras que los segundos es para 
							 //indicar cuantos datos existen en el fichero .txt 


   initial forever 

		#5 clock_In = ~clock_In; //Generacion de senal de reloj principal para simulacion
		
	initial begin
		// Initialize Inputs
		clock_In = 0;
		Reset = 0;
		data_ADC = 0;
		start = 0;
		Filtro = 0;
      #10;
		Reset = 0;
		#100;
		
		clock_In = 0;
		Reset = 1;
		data_ADC = 0;
		start = 0;
      #10;
		Reset = 0;
		#100;
		
		clock_In = 0;
		Reset = 0;
		data_ADC = 0;
		start = 0;
      #10;
		Reset = 0;
		#100;
	end 
	 initial begin 
		Filtro = 2'b10;
		SalidaTruncadoDAC = $fopen("SalidaTruncadoParaDAC.txt");// Abre fichero para escritura
		$readmemb("Estimulo.txt",mem);// Carga en mem los datos del fichero Estimulo.txt para lectura
		for (k=0; k<4999; k=k+1)// Ciclo for para recorrer el fichero cargado
		begin
			VariableAux = mem[k];
			@(negedge Clock_Muestreo1)
			start = 1;
			repeat(4) @(posedge Clock_Muestreo1); // Se esperan 4 ciclos de reloj, esto equivale a los primeros 4 datos del ADC que son para estabilizar
															  // la senal
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[11]; // bit numero 1 del dato 
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[10]; // bit numero 2 del dato 
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[9]; // bit numero 3 del dato 
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[8]; // bit numero 4 del dato 
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[7]; // bit numero 5 del dato 
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[6]; // bit numero 6 del dato 
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[5]; // bit numero 7 del dato 
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[4]; // bit numero 8 del dato
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[3]; // bit numero 9 del dato 
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[2]; // bit numero 10 del dato 
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[1]; // bit numero 11 del dato 
			@(negedge Clock_Muestreo1)
			data_ADC = VariableAux[0]; // bit numero 12 del dato
			start = 0; 
			#100;
			repeat(5) @(posedge Clock_Muestreo1);
			$fdisplayb(SalidaTruncadoDAC, Dac);
			
		end
		$fclose(SalidaTruncadoDAC);//Se cierra el fichero SalidaTruncadoParaDAC.txt
		$stop; 
 
	end

      
endmodule




