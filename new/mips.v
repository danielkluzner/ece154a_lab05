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

   wire 		       pcwrite, branch;
   wire [1:0] 		       aluop;
   
   maindec md(clk, reset, op, pcwrite, memwrite, irwrite,
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

   // opening logic
   wire [31:0] 		     pcnext, pc;
   wire [31:0] 		     instr, data;
   wire [4:0] 		     writereg, wd3;
   wire [31:0] 		     rd1, rd2, A, B;
   wire [31:0] 		     SrcA, SrcB;
   wire [31:0] 		     signtemp;
   wire [31:0] 		     aluresult, aluout;
   
   flopr_en #(32) pcreg(clk, reset, pcnext, pcen, pc);
   mux2 #(32) pcmux(pc, aluout, iord, adr);
   flopr_en #(32) instrreg(clk, 1'b0, readdata, irwrite, instr);
   flopr #(32) datareg(clk, reset, readdata, data);

   // register file logic
   regfile rf(clk, regwrite, instr[25:21], instr[20:16], writereg, wd3, rd1, rd2);
   mux2 #(5) writeregmux(instr[20:16], instr[15:11], regdst, writereg);
   flopr #(32) areg(clk, reset, rd1, A);
   flopr #(32) breg(clk, reset, rd2, B);
   mux2 #(32) wd3mux(aluout, data, memtoreg, wd3);

   signext se(instr[15:0], signtemp);
   mux2 #(32) srcAmux(pc, A, alusrca, SrcA);
   mux4 #(32) srcBmux(B, 32'h00000004, signtemp, {signtemp[31:2], 2'b0}, alusrcb, srcB);

   // alu logic
   alu ALU(SrcA, SrcB, alucontrol, aluresult, zero);
   flopr #(32) alureg(clk, reset, aluresult, aluout);
   mux4 pcsrcmux(aluresult, aluout, {pc[31:28], instr[25:0], 2'b0}, 32'b0, pcsrc, pcnext);

   assign writedata = B;
   assign op = instr[31:26];
   assign funct = instr[5:0];
   
endmodule
