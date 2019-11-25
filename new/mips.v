//-------------------------------------------------------
// Multicycle MIPS processor
//------------------------------------------------

module mips(input        clk, reset,
            output [31:0] adr, writedata,
            output        memwrite,
            input [31:0] readdata);

  wire        zero, pcen, irwrite, regwrite,
               alusrca, iord, memtoreg, regdst;
  wire [1:0]  alusrcb, pcsrc;
  wire [2:0]  alucontrol;
  wire [5:0]  op, funct;

  controller c(clk, reset, op, funct, zero,
               pcen, memwrite, irwrite, regwrite,
               alusrca, iord, memtoreg, regdst, 
               alusrcb, pcsrc, alucontrol);
  datapath dp(clk, reset, 
              pcen, irwrite, regwrite,
              alusrca, iord, memtoreg, regdst,
              alusrcb, pcsrc, alucontrol,
              op, funct, zero,
              adr, writedata, readdata);
endmodule

// Todo: Implement controller module
module controller(input       clk, reset,
                  input [5:0] op, funct,
                  input       zero,
                  output       pcen, memwrite, irwrite, regwrite,
                  output       alusrca, iord, memtoreg, regdst,
                  output [1:0] alusrcb, pcsrc,
                  output [2:0] alucontrol);

// **PUT YOUR CODE HERE**

   wire [3:0] 		       state;
   reg [3:0] 		       nextstate;

   always @(posedge clk) begin
      if(reset) nextstate = 4'b0;
   end // always @ (posedge clk)
   
   
   always @(posedge clk) begin
      casex({state, op})
	10'b0000xxxxxx: nextstate = 4'h1; // S0
	10'b000110x011: nextstate = 4'h2; // LW + SW (S1)
	10'b0001000000: nextstate = 4'h6; // RTYPE (S1)
	10'b0001000100: nextstate = 4'h8; // BEQ (S1)
	10'b0001001000: nextstate = 4'h9; // ADDI (S1)
	10'b0001000010: nextstate = 4'hb; // J (S1)
	10'b0010100011: nextstate = 4'h3; // LW (S2)
	10'b0010101011: nextstate = 4'h5; // SW (S2)
	10'b0011xxxxxx: nextstate = 4'h4; // S3
	10'b0100xxxxxx: nextstate = 4'b0; // S4
	10'b0101xxxxxx: nextstate = 4'b0; // S5
	10'b0110xxxxxx: nextstate = 4'h7; // S6
	10'b0111xxxxxx: nextstate = 4'b0; // S7
	10'b1000xxxxxx: nextstate = 4'b0; // S8
	10'b1001xxxxxx: nextstate = 4'ha; // S9
	10'b1010xxxxxx: nextstate = 4'b0; // S10
	10'b1011xxxxxx: nextstate = 4'b0; // S11
      endcase // case (state)
   end // always @ (posedge clk)
   
   assign state = nextstate;
   
   wire 		       pcwrite, branch;
   wire [1:0] 		       aluop;
   
   maindec md(op, state, pcwrite, memwrite, irwrite,
	      regwrite, alusrca, branch, iord,
	      memtoreg, regdst, alusrcb,
	      pcsrc, aluop);
   aludec ad(funct, aluop, alucontrol);
   
   assign pcen = (zero && branch) || pcwrite;
 
endmodule

// Todo: Implement datapath
module datapath(input        clk, reset,
                input        pcen, irwrite, regwrite,
                input        alusrca, iord, memtoreg, regdst,
                input [1:0]  alusrcb, pcsrc, 
                input [2:0]  alucontrol,
                output [5:0]  op, funct,
                output        zero,
                output [31:0] adr, writedata, 
                input [31:0] readdata);

// **PUT YOUR CODE HERE**
 
   
endmodule
