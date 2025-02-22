
module maindec(input clk, reset,
	       input [5:0]  op,
	       output reg	  pcwrite, memwrite, irwrite,
	       output reg 	  regwrite, alusrca, branch, iord,
	       output reg 	  memtoreg, regdst,
	       output reg [1:0] alusrcb, pcsrc, aluop);
   
  reg [15:0] controls;
  reg convenience;

  reg [3:0] nextstate;

  always @(posedge clk) begin

     if(reset)
        nextstate = 4'b0;
     else begin
        casex({nextstate, op})
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
	  default: nextstate = 4'b0;
        endcase // case (state)
     end

     case(nextstate)
      4'b0: controls = 16'h5010;
      4'b0001: controls = 16'h0030;
      4'b0010: controls = 16'h0420;
      4'b0011: controls = 16'h0100;
      4'b0100: controls = 16'h0880;
      4'b0101: controls = 16'h2100;
      4'b0110: controls = 16'h0402;
      4'b0111: controls = 16'h0840;
      4'b1000: controls = 16'h0605;
      4'b1001: controls = 16'h0420;
      4'b1010: controls = 16'h0800;
      4'b1011: controls = 16'h4008;
      default: controls = 16'bxxxxxxxxxxxxxxxx; // illegal state
    endcase // case (state)

    assign {convenience, pcwrite, memwrite, irwrite,
	    regwrite, alusrca, branch, iord,
	    memtoreg, regdst, alusrcb,
	    pcsrc, aluop} = controls;

  end // always @ (posedge clk)
endmodule
