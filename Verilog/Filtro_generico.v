`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Ecualizador de audio
//
//Descripcion: En este modulo se instancian las operaciones de suma y multiplicacion asi como los registros para conformar un filtro simple
//					ya sea paso bajo o paso alto
//////////////////////////////////////////////////////////////////////////////////
module Filtro_Generico#(
	parameter Magnitud = 8,//Se parametriza para hacer flexible el cambio de ancho de palabra
	parameter Decimal = 14,//Se parametriza para hacer flexible el cambio de ancho de palabra
	parameter N = 1 + Magnitud + Decimal//Se parametriza para hacer flexible el cambio de ancho de palabra
	)
 //Declaracion de senales de entrada y salida
 (
 input wire clk, clk_Registros,reset,enable,
 input wire signed [N-1:0] Data_In,
 input wire signed [N-1:0] a1, a2, b0, b1, b2,
 output wire signed[N-1:0] Data_Out
 );
//Declaracion de senales para la instanciaciacion
wire signed [N-1:0] Suma_sal_Fk,sal_multiplicacion_b0,Reg_1,sal_multiplicacion_a1,sal_multiplicacion_b1,
      Reg_2,sal_multiplicacion_a2,sal_multiplicacion_b2,Suma_sal_iz,Suma_sal_der,
		sal_FK,sal_iz,sal_der,multiplicacion_b0,multiplicacion_a1,multiplicacion_b1,
		multiplicacion_a2,multiplicacion_b2,sal_reg2;
//Instanciacion de modulos aritmeticos y registros para conformar el diagrama de bloques de un filtro digital mediante forma directa II
Suma #(.N(N)) Entrada (.A(Data_In),.B(sal_iz),.SUMA(Suma_sal_Fk));

Registro_N_bits #(.N(N)) suma_ent (.clock(clk),.reset(reset),.d(Suma_sal_Fk),.q(sal_FK));

Suma #(.N(N)) izquierda (.A(multiplicacion_a1),.B(multiplicacion_a2),.SUMA(Suma_sal_iz));

Registro_N_bits #(.N(N)) suma_izq (.clock(clk), .reset(reset), .d(Suma_sal_iz),.q(sal_iz));

Suma #(.N(N)) derecha (.A(multiplicacion_b1),.B(multiplicacion_b2),.SUMA(Suma_sal_der));

Registro_N_bits #(.N(N)) suma_der (.clock(clk), .reset(reset),.d(Suma_sal_der),.q(sal_der));

Suma  #(.N(N)) salida(.A(multiplicacion_b0),.B(sal_der),.SUMA(Data_Out));

Multiplicacion #(.Magnitud(Magnitud),.Decimal(Decimal)) b_0  (.A(Suma_sal_Fk),.B(b0),.multi(sal_multiplicacion_b0));

Registro_N_bits #(.N(N)) mb_0 (.clock(clk), .reset(reset), .d(sal_multiplicacion_b0), .q(multiplicacion_b0));

Multiplicacion #(.Magnitud(Magnitud),.Decimal(Decimal)) multiplicacion1 (.A(Reg_1),.B(a1),.multi(sal_multiplicacion_a1));

Registro_N_bits #(.N(N)) ma_1 (.clock(clk),.reset(reset),.d(sal_multiplicacion_a1),.q(multiplicacion_a1));

Multiplicacion #(.Magnitud(Magnitud),.Decimal(Decimal)) b_1 (.A(Reg_1),.B(b1),.multi(sal_multiplicacion_b1));

Registro_N_bits #(.N(N)) mb_1 (.clock(clk), .reset(reset), .d(sal_multiplicacion_b1),.q(multiplicacion_b1));
	 
Multiplicacion #(.Magnitud(Magnitud),.Decimal(Decimal)) a_2 (.A(sal_reg2),.B(a2),.multi(sal_multiplicacion_a2));

Registro_N_bits #(.N(N)) ma_2 (.clock(clk), .reset(reset),.d(sal_multiplicacion_a2),.q(multiplicacion_a2));
	 
Multiplicacion #(.Magnitud(Magnitud),.Decimal(Decimal)) b_2 (.A(sal_reg2),.B(b2),.multi(sal_multiplicacion_b2));

Registro_N_bits #(.N(N)) mb_2 (.clock(clk),.reset(reset),.d(sal_multiplicacion_b2),.q(multiplicacion_b2));

Registro_Pipeline #(.N(N)) regp_1  (.clk(clk_Registros),.reset(reset),.data_in(sal_FK),.enable(enable),.q_out(Reg_1));

Registro_Pipeline #(.N(N)) regp_2  (.clk(clk_Registros),.reset(reset),.data_in(Reg_1),.enable(enable),.q_out(Reg_2));

Registro_N_bits #(.N(N)) r_2 (.clock(clk), .reset(reset), .d(Reg_2), .q(sal_reg2));

endmodule
