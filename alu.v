// alu.v
// ECE 154A, Fall 2019
// Authors: Daniel Kluzner, Benji Liu

// A 32-bit arithmetic logic unit (ALU)
// as seen in 5.2.4 of "Harris & Harris"

module alu(
       input [2:0] f,
       input [31:0]  a,
       input [31:0]  b,
       output [31:0] y,
       output zero
);

   assign zero = (y == 32'b0) ? 1'b1 : 1'b0;
   assign y = (f == 3'b000) ? (a & b) :
	      (f == 3'b001) ? (a | b) :
	      (f == 3'b010) ? (a + b) :
	      (f == 3'b110) ? (a - b) :
	      (f == 3'b111 && a[31] < b[31]) ? (32'b0) :
	      (f == 3'b111 && a[31] > b[31]) ? (32'h00000001) :
	      (f == 3'b111 && a[30:0] < b[30:0]) ? (32'h00000001) :
	      (f == 3'b111 && a[30:0] > b[30:0]) ? (32'b0) :
	      32'b0;

endmodule
