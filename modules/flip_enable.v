module flopr_en #(parameter WIDTH = 8)
   (input logic clk, reset,
    input logic [WIDTH-1:0]  d,
    input logic enable,
    output logic [WIDTH-1:0] q);
   always_ff @(posedge clk, posedge reset, enable)
     if(enable || reset) begin
	if (reset) q <= 0;
	else q <= d;
     end
endmodule
