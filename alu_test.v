`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Autor:           Mateusz Kowalczyk 
// Numer Indeksu:   268533
// Grupa zajêciowa: Pi¹tek TP 9:00-11:15
// Projekt:         ALU - testbench Verilog
////////////////////////////////////////////////////////////////////////////////

module alu_test;

	// Inputs
	reg [7:0] u_a;
	reg [7:0] u_b;
	reg clk;
	reg [3:0] op;
	reg nreset; 

	// Outputs
	wire borrow;
	wire [15:0] u_result;

	// Instantiate the Unit Under Test (UUT)
	alu8bit_unsigned uut (
		.u_a(u_a), 
		.u_b(u_b), 
		.clk(clk), 
		.op(op), 
		.nreset(nreset), 
		.borrow(borrow), 
		.u_result(u_result)
	);


task wynik_test;
input [3:0] operacja; // rodzaj operatora/operacji
input [7:0] X;  
input [7:0] Y;
input [15:0] wynik;

@(posedge clk)

begin

case(operacja) // weryfikacja wyniku
4'b0000: // AND
begin if (wynik != (X & Y))
begin
$display ("blad wyniku");
end
end

4'b0001: // OR
begin if (wynik != (X | Y))
begin
$display ("blad wyniku");
end
end

4'b0010: // XOR
begin if (wynik != (X ^ Y))
begin
$display ("blad wyniku");
end
end

4'b0011: // NOT na argumencie u_a
begin if (wynik != (~X))
begin
$display ("blad wyniku");
end
end

4'b0100: // porównanie A=B
begin if (wynik != 16'b0000000000000000 | wynik != 16'b1111111111111111)
begin
$display ("blad wyniku");
end
end

4'b0101: // porównanie A>B
begin if (wynik != 16'b0000000000000000 | wynik != 16'b1111111111111111)
begin
$display ("blad wyniku");
end
end

4'b0110: // porównanie A<B
begin if (wynik != 16'b0000000000000000 | wynik != 16'b1111111111111111)
begin
$display ("blad wyniku");
end
end

4'b1000: // ADD
begin if (wynik != 8'b00000000 & (X+Y))
begin
$display ("blad wyniku");
end
end

4'b1001: // SUB
begin if (wynik != 8'b00000000 & (X-Y))
begin
$display ("blad wyniku");
end
end

4'b1010: // DIV
begin if (wynik != 8'b00000000 & (X/Y))
begin
$display ("blad wyniku");
end
end

4'b1011: // MUL
begin if (wynik != (X*Y))
begin
$display ("blad wyniku");
end
end

endcase
end
endtask

integer file;

initial begin
// Initialize Inputs + File open
file = $fopen ("wynik.txt");
u_a = 0;
u_b = 0;
clk = 0;
op = 0;
nreset = 0;
#50 // opoznienie 50 nanosekund 
nreset = 1;


u_a = 8'b00000101;
u_b = 8'b00000010;
op = 4'b0000;
#50;
wynik_test (op, u_a, u_b, u_result);
$fwrite (file, "Op = %b, a = %b, b= %b, result = %b \n", op, u_a, u_b, u_result);


u_a = 8'b00000111;
u_b = 8'b00000011;
op = 4'b0001;
#50;
wynik_test (op, u_a, u_b, u_result);
$fwrite (file, "Op = %b, a = %b, b= %b, result = %b \n", op, u_a, u_b, u_result);


u_a = 8'b00100111;
u_b = 8'b10000011;
op = 4'b0010;
#50;
wynik_test (op, u_a, u_b, u_result);
$fwrite (file, "Op = %b, a = %b, b= %b, result = %b \n", op, u_a, u_b, u_result);


u_a = 8'b00110111;
u_b = 8'b10010011;
op = 4'b0011;
#50;
wynik_test (op, u_a, u_b, u_result);
$fwrite (file, "Op = %b, a = %b, b= %b, result = %b \n", op, u_a, u_b, u_result);


u_a = 8'b10000011;
u_b = 8'b10000011;
op = 4'b0100;
#50;
wynik_test (op, u_a, u_b, u_result);
$fwrite (file, "Op = %b, a = %b, b= %b, result = %b \n", op, u_a, u_b, u_result);


u_a = 8'b11000001;
u_b = 8'b10000011;
op = 4'b0101;
#50;
wynik_test (op, u_a, u_b, u_result);
$fwrite (file, "Op = %b, a = %b, b= %b, result = %b \n", op, u_a, u_b, u_result);


u_a = 8'b11000111;
u_b = 8'b01010011;
op = 4'b0110;
#50;
wynik_test (op, u_a, u_b, u_result);
$fwrite (file, "Op = %b, a = %b, b= %b, result = %b \n", op, u_a, u_b, u_result);


u_a = 8'b01010011;
u_b = 8'b01110011;
op = 4'b1000;
#50;
wynik_test (op, u_a, u_b, u_result);
$fwrite (file, "Op = %b, a = %b, b= %b, result = %b \n", op, u_a, u_b, u_result);


u_a = 8'b01101110;
u_b = 8'b00100111;
op = 4'b1001;
#50;
wynik_test (op, u_a, u_b, u_result);
$fwrite (file, "Op = %b, a = %b, b= %b, result = %b \n", op, u_a, u_b, u_result);


u_a = 8'b10001010;
u_b = 8'b00010101;
op = 4'b1010;
#50;
wynik_test (op, u_a, u_b, u_result);
$fwrite (file, "Op = %b, a = %b, b= %b, result = %b \n", op, u_a, u_b, u_result);


u_a = 8'b10100100;
u_b = 8'b00000011;
op = 4'b1011;
#50;
wynik_test (op, u_a, u_b, u_result);
$fwrite (file, "Op = %b, a = %b, b= %b, result = %b \n", op, u_a, u_b, u_result);


#50;
$fclose (file);
$finish;


end
always
begin
#5 clk = ~clk;

end
      
endmodule
