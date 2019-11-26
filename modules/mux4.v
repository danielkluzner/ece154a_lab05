module mux4 #(parameter WIDTH = 8)
   (input logic [WIDTH-1:0] d0, d1, d2, d3,
    input logic [1:0] s,
    output logic [WIDTH-1:0] y);
   assign y =  2'b00 ? d0 : 2'b01 ? d1 : 2'b10 ? d2 : d3;
endmodule
