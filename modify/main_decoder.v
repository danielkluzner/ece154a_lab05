module maindec(input logic [5:0] op,

	       output logic 	  pcwrite, memwrite, irwrite,
	       output logic 	  regwrite, alusrca, branch, iord,
	       output logic 	  memtoreg, regdest,
	       output logic [1:0] alusrcb, pcsrc, aluop);
   
  logic [14:0] controls;
  assign {pcwrite, memwrite, irwrite,
	  regwrite, alusrca, branch, iord,
	  memtoreg, regdest, alusrc,
	  pcsrc, aluop} = controls;
  always_comb
    case(op)
      6'b000000: controls <= 9'b110000010; // RTYPE
      6'b100011: controls <= 9'b101001000; // LW
      6'b101011: controls <= 9'b001010000; // SW
      6'b000100: controls <= 9'b000100001; // BEQ
      6'b001000: controls <= 9'b101000000; // ADDI
      6'b000010: controls <= 9'b000000100; // J
      default: controls <= 9'bxxxxxxxxx; // illegal op
    endcase
endmodule
