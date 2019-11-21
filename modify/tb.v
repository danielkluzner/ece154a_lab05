module tb();
  logic clk;
  logic reset;
  logic [31:0] writedata, dataadr;
  logic memwrite;

  // instantiate device to be tested
  top dut (clk, reset, writedata, dataadr, memwrite);
  
  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end
  // check results
  always @(negedge clk)
    begin
      if (memwrite) begin

// MODIFICATION
        if (dataadr === 84 & writedata === 32'hffff7f02) begin // Mem[0x54] = 0xffff7f02 (should be)
// MODIFICATION

	  $display("Simulation succeeded");
          $stop;
        end else if (dataadr != 80) begin
          $display("Simulation failed");
          $stop;
        end
      end
    end // always @ (negedge clk)
   
endmodule
