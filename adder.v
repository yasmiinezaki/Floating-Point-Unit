module adder #(parameter X =32, parameter expo_bits)(input reg A [X-1:0], input reg B[X-1:0],output [X-1:0] out);
reg [expo_bits-2:0] exp_a; 
reg [expo_bits-2:0] exp_b;
reg [X-expo_bits-1:0]mant_a;
reg [X-expo_bits-1:0]mant_b;
reg sign_a;
reg sign_b;

reg [X-expo_bits:0] mant_out;
reg [expo_bits-2:0] exp_out;
reg sign_out;

reg [X-expo_bits-1:0] diff;
reg [X-expo_bits-1:0] mant_temp;

always @ (*)
begin
	a_sign = A[X-1];
	b_sign = B[X-1];
	
	mant_a = {1'b1, A[X-expo_bits-2:0]};
	mant_b = {1'b1, B[X-expo_bits-2:0]};
	
	exp_a = A[X-2:X-expo_bits-1];
	exp_b = B[X-2:X-expo_bits-1];
	
	// add where A and B have equal signs
	if (a_sign == b_sign)
	begin
		if (exp_a == exp_b)
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
			mant_out = mant_a +mant_b;
			sign_out = a_sign;
			exp_out = exp_a;
			end
			
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
	
		// mant_a > mant_b ->
		// else ->
	
end
endmodule 