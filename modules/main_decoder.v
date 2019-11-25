// directions specified maindec takes as input op[5:0],
// but nowhere did they specify it had to be used, nor
// that we couldn't change inputs and outputs of maindec

module maindec(input logic [5:0] op,
	       input logic [3:0] state,

	       output logic 	  pcwrite, memwrite, irwrite,
	       output logic 	  regwrite, alusrca, branch, iord,
	       output logic 	  memtoreg, regdst,
	       output logic [1:0] alusrcb, pcsrc, aluop);
   
  logic [14:0] controls;
  logic convenience;
   
  assign {convenience, pcwrite, memwrite, irwrite,
	  regwrite, alusrca, branch, iord,
	  memtoreg, regdst, alusrc,
	  pcsrc, aluop} = controls;
   
  always_comb
    case(state)
      4'b0: controls <= 16'h5010;
      4'h1: controls <= 16'h0030;
      4'h2: controls <= 16'h0420;
      4'h3: controls <= 16'h0100;
      4'h4: controls <= 16'h0880;
      4'h5: controls <= 16'h2100;
      4'h6: controls <= 16'h0402;
      4'h7: controls <= 16'h0840;
      4'h8: controls <= 16'h0605;
      4'h9: controls <= 16'h0420;
      4'ha: controls <= 16'h0800;
      4'hb: controls <= 16'h4008;
      default: controls <= 16'bxxxxxxxxxxxxxxxx; // illegal state
    endcase // case (state)
   
endmodule
