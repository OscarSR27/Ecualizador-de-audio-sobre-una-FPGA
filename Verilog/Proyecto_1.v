`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Ecualizador de audio
//
//Descripcion: Este es el modulo principal en donde se realiza la instanciacion de todos los submodulos digitales que conforman el ecualizador de audio.
//////////////////////////////////////////////////////////////////////////////////
module Proyecto_1 #(parameter Magnitud=8, Decimal=14, N = Magnitud+Decimal+1, N_ADC = 12) //Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
(
input wire Reset,clock_In,
input wire data_ADC,start,
input wire [1:0] Filtro,
output wire done,
output wire CS,Clock_Muestreo1, clck, Sync,Data_DAC,
output wire [3:0] data_basura,
output wire signed [N_ADC-1:0] Dac
    );
assign clck = Clock_Muestreo;

//Senal de reloj para la maquina de estados del ADC y el DAC
Divisor_Clock_ADC c (.Clck_in(clock_In),.reset_Clock(Reset),.Clock_out(Clock_Muestreo1));

//Declaracion de senales utilizadas dentro del modulo
wire [N_ADC-1:0] Dato,Dac2,ent_filt;
reg Enable;
wire signed [N-1:0] Entrada_Filtros,Data_Out_bajos,Data_Out_medios,Data_Out_altos,Salida_Filtros, SalidaSuma1, SumaTotal;

//Senal de reloj para los modulos del sistema excluyendo el ADC y el DAC
divisor50MHZmodule c1 (
    .Clck_in(clock_In), 
    .reset_Clock(Reset), 
    .Clock_out(Clock1)
    );

//Maquina de estados del ADC para obtener dato entrante
Prueba_ADC adc (
    .Clock_Nexys(clock_In), 
    .Reset(Reset), 
    .reset_Clck(Reset), 
    .data_ADC(data_ADC), 
    .start(start), 
    .done(done), 
    .CS(CS), 
    .Clock_Muestreo(Clock_Muestreo), 
    .data_basura(data_basura), 
    .Dato(Dato)
    );
//Registro para almacenar los datos del ADC e introducirlos al tratamiento de datos
Registro_N_bits #(.N(N_ADC)) adc1 (.clock(clock_In),.reset(Reset),.d(Dato),.q(ent_filt));

//Tratamiento para los datos provenientes del ADC para hacerlos compatibles con las operaciones aritmeticas hechas en los filtros
Concatenacion_ADC #(.N_ADC(N_ADC),.N(N)) tadc
(.data_ADC(ent_filt),.Entrada_Filtros(Entrada_Filtros));

//Se genera una senal que habilita la carga de iteraciones en los registros de cada filtro.
always @* //Lista sensitiva, responde ante cualquier cambio de senal
	if (done && Clock_Muestreo1)
		Enable = 0;
	else
		Enable = 1;
wire Activar;

//La carga de iteraciones en los registros es gobernada por una senal de reloj generada a partir de la senal done y el reloj de la maquina de estados
//utilizada en el ADC y el DAC
and(Activar, Clock_Muestreo, done);

//Ecuaciones para los filtros de frecuencias bajas, medias y altas
EtapaFiltros #(.Magnitud(Magnitud),.Decimal(Decimal)) f 
(   
    .Data_In(Entrada_Filtros), 
    .clock_In(Clock1), 
	 .clk_Registros(Activar),
    .Reset(Reset), 
    .enable(Enable), 
    .Data_Out_bajos(Data_Out_bajos), 
    .Data_Out_medios(Data_Out_medios), 
    .Data_Out_altos(Data_Out_altos)
    );

//Se genera la suma de las tres bandas de frecuencias para reconstruir el audio original e introducirla como una de las opciones a seleccionar
Suma #(.N(N)) Suma1 (
    .A(Data_Out_bajos), 
    .B(Data_Out_medios), 
    .SUMA(SalidaSuma1)
    );
Suma #(.N(N)) Suma2 (
    .A(SalidaSuma1), 
    .B(Data_Out_altos), 
    .SUMA(SumaTotal)
    );

//Multiplexor para seleccionar cual banda de frecuencias se desea escuchar o bien si se desea escuchar el audio original	 
Mux_Filtros #(.N(N)) sel_sal 
(
 .bajos(Data_Out_bajos)
 ,.medios(Data_Out_medios)
 ,.altos(Data_Out_altos)
 ,.SalidaTotal(SumaTotal)
 ,.caso(Filtro)
 ,.sal_Mux(Salida_Filtros)
    );


//Tratamiento de datos antes de ingresar al DAC
Truncamiento_DAC #(.N_ADC(N_ADC),.Magnitud(Magnitud),.Decimal(Decimal)) tdac 
(.Salida_Filtros(Salida_Filtros),.Dac(Dac));

//Registro para almacenar los datos mientras se envian al DAC
Registro_N_bits #(.N(N_ADC)) r3 (.clock(clock_In),.reset(Reset),.d(Dac),.q(Dac2));


//Maquina de estados para enviar los datos al DAC y obtener la senal analogica
Protocolo_DAC d (
    .Clock_Muestreo(Clock_Muestreo), 
    .Clock(clock_In), 
    .reset(Reset), 
    .data_In(Dac2), 
    .start(start), 
    .Sync(Sync), 
    .Data_DAC(Data_DAC)
    );

endmodule
