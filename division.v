module division #(parameter X =32)
(input wire [X-1:0]A, input wire [X-1:0]B,output reg [X-1:0] out,input wire start,
input clk,input clrn,output reg overflow,output reg underflow);
localparam expo_bits = (X == 32) ? 8   : 11; 
localparam mant_bits = (X == 32) ? 23  : 52;
localparam bias = (X == 32) ? 127 : 1023;

	wire [expo_bits-1:0] exp_a = A[X-2:X-expo_bits-1];
	wire [expo_bits-1:0] exp_b = B[X-2:X-expo_bits-1];
	reg [expo_bits-1:0] exp_out;
//	input start; // start
//input clk, clrn;
	//23-bits in case of 32 bit input
	wire [mant_bits-1:0] mant_a = A[X-expo_bits-2:0];
	wire [mant_bits-1:0] mant_b = B[X-expo_bits-2:0];
	reg [mant_bits-1:0] mant_out;
	reg [mant_bits:0] product;
	wire [mant_bits:0]  producto;
	wire [mant_bits:0] mant_a_mod0 = {{1'b1},mant_a}; 
	wire [mant_bits:0] mant_b_mod0 = {{1'b1},mant_b};
	reg [mant_bits:0] mant_a_mod;
	reg [mant_bits:0] mant_b_mod;
	reg ready,cout,cout_2,ready2;
	wire readyo;
	reg start2;
	wire start3 = start2;
	goldschmidtVersion3 gs(mant_a_mod,mant_b_mod,start3,clk,clrn,producto,readyo);
	
	wire sign=A[X-1]^B[X-1];

always @ (posedge clk) begin
	ready = readyo;
	if (ready) begin
			product = producto;
			// if
//			if (exp_a >= exp_b) begin 
//				exp_out = exp_a - exp_b;
//			end else begin		
//				exp_out = exp_b - exp_a;
//				
//			end
			{cout, exp_out} = exp_out + bias;
			if (cout) begin
				underflow = 1'b1;
			end
			if (exp_out == 0) begin
				underflow = 1'b1;
			end
//			if(product[(2*(mant_bits)+1)] == 1) begin
//			{cout_2, exp_out} = exp_out + 1;
//			product = product >> 1;
//		end 
//		//if most significant was zero and second most significant is also zero then normalize again
//		else 
//		ready2 = 1'b1;
		if((product[(mant_bits - 1)] != 1) && (exp_out != 0)) begin
			exp_out = exp_out - 1;
			product = product << 1; 
//			ready2 = 1'b0;
		end
		
//		mant_out = product[(2*(mant_bits)-1):((2*(mant_bits)-1)-mant_bits+1)];
//		if (ready2) begin 
			// remove the first one
			mant_out = product[mant_bits - 1:0];
			out={sign, exp_out, mant_out};
//		end
	end
end

always @ (posedge clk) begin
		mant_b_mod = mant_b_mod0;
		mant_a_mod = mant_a_mod0;
		if (start) begin
		if (!(mant_b_mod >= 0 && mant_b_mod <= 1)) begin			
			mant_b_mod = mant_b_mod >> 1;
			mant_a_mod = mant_a_mod >> 1;
			
		end else begin
			start2 = 1'b1;	
			#(2 *1.5) start2 = 1'b0;
		end
		end
end



endmodule
//always @ (posedge clk) begin
//
//
//		if (ready) begin			
//			if((product[(mant_bits - 1)] != 1) && (exp_out != 0)) begin
//			exp_out = exp_out - 1;
//			product = product << 1; 
//		end else begin
//			
//		
//		end
//end
// normalize the deno ,numer


