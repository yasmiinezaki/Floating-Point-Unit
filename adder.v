module adder #(parameter X =32)(input [X-1:0] A, input [X-1:0] B,output [X-1:0] out,output reg done,output overflow,output underflow);
localparam expo_bits = (X == 32) ? 8 : 11; 
localparam mant_bits = (X == 32) ? 23 : 52;

reg [expo_bits-1:0] exp_a; // 8/11 bit exponent
reg [expo_bits-1:0] exp_b;
reg [X-expo_bits-1:0]mant_a; // 24/53 bit mantissa (1 for the 1 before the floating point and 23/52 from the input)
reg [X-expo_bits-1:0]mant_b;
reg a_sign;
reg b_sign;

reg carry;
reg [X-expo_bits:0] mant_out; // 25 bit output mantissa for any carry that occurs during addition
reg [expo_bits-1:0] exp_out;
reg sign_out;

reg [expo_bits-1:0] diff; // used to store the difference in exponents
reg [X-expo_bits-1:0] mant_temp; // used to store the shifted mantissa

reg [X-expo_bits:0] mant_normalizer_in; 
wire [X-expo_bits:0] mant_normalizer_out;
reg [expo_bits-1:0] exp_normalizer_in;
wire [expo_bits-1:0] exp_normalizer_out;

wire underflow_in;
reg underflow_out;
adder_normalizer #(.X(X),.expo_bits(expo_bits)) inst (mant_normalizer_in,exp_normalizer_in,mant_normalizer_out,exp_normalizer_out,underflow_in);

always @ (*)
begin
	done=1'b0;
	a_sign = A[X-1];
	b_sign = B[X-1];
	exp_a = A[X-2:X-expo_bits-1];
	exp_b = B[X-2:X-expo_bits-1];
	
	if(exp_a == 0 && A[X-expo_bits-2:0]==0) begin
		mant_a = {1'b0, A[X-expo_bits-2:0]};
	end else begin
		mant_a = {1'b1, A[X-expo_bits-2:0]};
	end
	if(exp_b == 0 && B[X-expo_bits-2:0]==0) begin
		mant_b = {1'b0, B[X-expo_bits-2:0]};
	end else begin
		mant_b = {1'b1, B[X-expo_bits-2:0]};
	end
	

	
	// add where A and B have equal signs
	if (a_sign == b_sign)
	begin
		if (exp_a == exp_b) // if exponents are equal add mantissa directly
		begin
			mant_out = mant_a +mant_b;
			sign_out = a_sign;
			exp_out = exp_a;
		end
		else if(exp_a > exp_b)
		begin
			diff = exp_a - exp_b;
			mant_temp = mant_b >> diff;
			
			mant_out = mant_a +mant_temp;
			sign_out = a_sign;
			exp_out = exp_a;
			
		end
		else
		begin
			diff = exp_b - exp_a;
			mant_temp = mant_a >> diff;
			
			mant_out = mant_b +mant_temp;
			sign_out = a_sign;
			exp_out = exp_b;	
		end
	end
	else // sub else sign a is not equal sign b
	begin
	
		if (exp_a == exp_b)
		begin
		
			if(mant_a > mant_b) begin
				mant_out = mant_a - mant_b;
				sign_out = a_sign;
				exp_out = exp_a;
			end
			else begin
				mant_out = mant_b - mant_a;
				sign_out = b_sign;
				exp_out = exp_a;			
			end		
			
		end
		else if(exp_a > exp_b)
		begin
			diff = exp_a - exp_b;
			mant_temp = mant_b >> diff;
			
			mant_out = mant_a - mant_temp;
			sign_out = a_sign;
			exp_out = exp_a;
			
		end
		else
		begin
			diff = exp_b - exp_a;
			mant_temp = mant_a >> diff;
			
			mant_out = mant_b - mant_temp;
			sign_out = b_sign;
			exp_out = exp_b;			
		end
	end
	underflow_out = 0;
	carry = 0;
	// mant_out 
	// remove carry if existing at bit 24 and shift right
	
	if (mant_out[X-expo_bits] == 1'b1) // if last bit in output mantissa has carry
	begin
		
		mant_out = mant_out >> 1;
		{carry,exp_out} = exp_out + 1;

	end else if( mant_out[X-expo_bits-1] == 1'b0 ) begin// normalize if there is no 1 at bit 23
		mant_normalizer_in = mant_out; 
		exp_normalizer_in = exp_out;
		mant_out = mant_normalizer_out;
		exp_out = exp_normalizer_out;
		underflow_out = underflow_in;
	end
	done=1'b1;
end 

assign out[X-1] = sign_out;
assign out[X-2:X-expo_bits-1] = exp_out;
assign out[X-expo_bits-2:0] = mant_out[X-expo_bits-2:0];
assign overflow = carry;
assign underflow = underflow_out;
endmodule 