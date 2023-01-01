module goldschmidtVersion3 #(parameter mant_bits =24) 
(input [mant_bits - 1:0] a,input [mant_bits - 1:0] b,input start,input clk
,input clrn,output [mant_bits - 1:0] q,output reg ready);

reg [2:0] count; // counter
//output [mant_bits - 1:0] yn; // .11111...1
reg [(2 *mant_bits) - 1:0] reg_a; // x.xxxx...x
reg [(2 *mant_bits) - 1:0] reg_b; // 0.xxxx...x
wire [(2 *mant_bits) - 1:0] two_minus_yi = ~reg_b + 1'b1; 
wire [(4 *mant_bits) - 1:0] xi = reg_a * two_minus_yi; 
wire [(4 *mant_bits) - 1:0] yi = reg_b * two_minus_yi; 
assign q = reg_a[(2 *mant_bits) - 1:mant_bits];
//assign yn = reg_b[(2 *mant_bits) - 2:mant_bits - 2];
always @ (posedge clk or negedge clrn) begin
	if (!clrn) begin
	ready <= 0;
		count <= 0;
	end else begin
	if (start) begin
	reg_a <= {1'b0,a,{(mant_bits - 1){1'b0}}}; // 0.1x...x0...0
	reg_b <= {1'b0,b,{(mant_bits - 1){1'b0}}}; // 0.1x...x0...0
	count <= 0;
	//busy <= 1;
	ready <= 0;
//	start = 0;
	end else begin
	reg_a <= xi[(4 *mant_bits) - 2:(2 *mant_bits) - 1]; // x.xxx...x
	reg_b <= yi[(4 *mant_bits) - 2:(2 *mant_bits) - 1]; // 0.xxx...x
	count <= count + 3'b1; // count++
	if (count == 3'h7) begin // finish
//busy <= 0;
	ready <= 1; // q is ready
end
end
end
end
endmodule