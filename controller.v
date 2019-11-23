module controller(input logic [5:0] op, funct,
                  input logic zero,
                  output logic memtoreg, memwrite,
                  output logic pcsrc, alusrc,
                  output logic regdst, regwrite,
                  output logic jump,
                  output logic [2:0] alucontrol);

  logic [1:0] aluop;
  logic branch;
  maindec md(op, memtoreg, memwrite, branch,
             alusrc, regdst, regwrite, jump, aluop);
  aludec ad(funct, aluop, alucontrol);

// MODIFICATION
  always_comb
    case(op) // accomodates bne
      6'b000101: pcsrc = branch & ~zero; // if zero = 0 (rs != rt) then branch
      default: pcsrc = branch & zero; // otherwise, as normal
    endcase
// MODIFICATION

endmodule
