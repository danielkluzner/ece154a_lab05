module imem(input logic [5:0] a,
            output logic [31:0] rd);

  logic [31:0] RAM[63:0];

  initial

// MODIFICATION
    $readmemh("memfile2.dat", RAM); // now reads from instructions containing ori and bne
// MODIFICATION
    
  assign rd = RAM[a]; // word aligned
endmodule
