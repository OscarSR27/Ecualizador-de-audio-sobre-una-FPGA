`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez
//Curso: Laboratorio de circuitos digitales
//Proyecto: Ecualizador de audio
//
//Descripcion: En este modulo se realiza la interfaz con el DAC por medio de una maquina de estados para convertir los datos de digital a analogicos. 
//////////////////////////////////////////////////////////////////////////////////

module Protocolo_DAC
#(parameter N=12) //Parametrizacion
//Declaracion de senales de entrada y salida
(
input wire Clock_Muestreo,
input wire Clock,reset, 
input wire [N-1:0] data_In,
input wire start,
output wire Sync,
output wire Data_DAC
);
 
// Se definen los estados de la maquina 

localparam [1:0]
                Inicio = 2'b00,
					 enviar = 2'b01,
					 Listo  = 2'b10;
// Variables de logica de la maquina 
					 
reg Data_Act,Data_next;
reg [3:0] bit_num_A, bit_num_N;
reg Sync_A , Sync_N; 
reg [1:0] Estado_Act,Estado_Next;
reg [3:0]contador_A,contador_N; 
reg done; 
reg [1:0] valor_A;
wire [1:0] Valor_next; 
reg  clockd_A;
wire clockd_next;

always @(posedge Clock, posedge reset) //Lista sensitiva, responde ante un flanco positivo del Clock o reset
  if (reset)
     begin 
	        valor_A <= 0 ;
			  clockd_A <= 0 ;
	  end   
  else 
     begin 
	       valor_A <= Valor_next ;
			 clockd_A <= clockd_next ;
			end 
	assign Valor_next =  {Clock_Muestreo,valor_A[1]};
   assign clockd_next =  (valor_A==2'b11) ? 1'b1 :
		                   (valor_A==2'b00) ? 1'b0 :
								  clockd_A;
								  
	assign fall_edge = clockd_A & ~ clockd_next ;
	
// Acualizacion de los estados actuales, siguiente y reset. Se definen los valores por defecto de las salidas de la maquina de estados
always@(negedge Clock, posedge reset) //Lista sensitiva, responde ante un flanco positivo del Clock o reset
       begin 
		      if(reset)
				   begin
				   Data_Act <= 0;
               Sync_A <= 1;
					Estado_Act <= 0;
					contador_A <= 0;
					bit_num_A <= 0;
				   end
            else 
				   begin 
				   Data_Act <= Data_next;
					Sync_A <= Sync_N;
					Estado_Act <= Estado_Next;
					contador_A <= contador_N;
					bit_num_A <= bit_num_N;
					end 
			end 
			
// logica de estado proximo de la maquina 

always @*
      begin 
		Data_next = Data_Act;
		Sync_N =Sync_A;
		Estado_Next = Estado_Act;
		contador_N = contador_A;
		bit_num_N = bit_num_A; 
		case (Estado_Act)
		      
				Inicio :  if(start && Sync_N && fall_edge) //Se permanece en este estado hasta que se indique el inicio de una conversion
				             begin
				             Sync_N = 1'b0;
								 bit_num_N = 4'd11; 
								 contador_N = 4'd0;

							    Estado_Next = enviar;//El estado siguiente es Capturar
							    end 
							 else 
							    Estado_Next = Inicio;
		    enviar :  if(fall_edge)//En este estado se procede a enviar hacia el DAC los 12 bits de dato + 4 bits de estabilizacion de senal.
											//Mientras no se hayan enviado los 16 bits se permanece en este estado
			              begin
			               if (contador_N == 15)
						          begin
								    Estado_Next = Listo;//El siguiente estado es Listo
                            end 
						  
						      else if (contador_N >= 3)
							        begin 
							        Data_next = data_In [bit_num_N] ;
							        bit_num_N = bit_num_N - 1'b1 ;
							        contador_N = contador_N + 1'b1 ;
							        end
							    else 
							        begin 
								     Data_next = 1'b0;
								     contador_N = contador_N + 1'b1;
								     end 
								end 
			 Listo :
			            begin
						   Data_next = 1'b0; //En este estado se indica la finalizacion del proceso al asignar el valor de 1 a la senal Sync_N
							Sync_N = 1'b1;
							Estado_Next = Inicio; //Se regresa al inicio de la maquina de estados
							end 
							
			default :   Estado_Next = Inicio; //Estado por defecto
			endcase
			end 
// Asignaciones a las salidas del modulo 

assign Sync = Sync_A;
assign Data_DAC= Data_Act;
endmodule

