
module multiplier #(parameter X =32, parameter expo_bits, parameter mant_bits)(input wire A [X-1:0], input wire B[X-1:0],output reg [X-1:0] out, output reg done);

	reg [expo_bits-1:0] exp_a; 
	reg [expo_bits-1:0] exp_b;
	reg [mant_bits-1:0]mant_a; //23 bits in case of 32 bit input
	reg [mant_bits-1:0]mant_b;
	reg [mant_bits-1:0]mant_a_2; //24 bits in case of 32 bit input
	reg [mant_bits-1:0]mant_b_2;

	reg [mant_bits-1:0] mant_out;
	reg [expo_bits-1:0] exp_out;
	reg sign;
	
	reg [(2*(mant_bits)+1):0] product; //48 in case of 32 bit input (man bits 23) and 106 in case of 64 bit input therefore 2*(man_bits+1) therefore from 2*(man_bits+1)-1 to 0

	
	wire [7:0] norm_exp;
	wire [47:0] norm_mant;
	
	integer mantissa;
	integer exp;
	
	mult_normalize norm (
		.expsize(expo_bits),
		.mantsize(mant_bits),
		.in_exp(exp_out),
		.in_mant(product),
		.out_exp(norm_exp),
		.out_mant(norm_mant)
	);
	
always @ (*)
begin
	//1. calculate sign bit (general even for special numbers)
	
	sign=A[X-1]^B[X-1]; //XOR of 2 input bits
	
	//2. check for special cases:
	
	/*
	case 1: 0*inf or inf*0 -> NaN
	A -> 0 i.e. E:00000000 m:00000000000000000000000
	B -> inf i.e. E:11111111 m:00000000000000000000000
	or vice versa
	Output -> NaN i.e. E:11111111 m:1XXXXXXXXXXXXXXXXXXXXXX
	*/

	if( ( ((exp_a == 0) && (exp_b == {expo_bits{1'b1}})) || ((exp_b== 0) && (exp_a == {expo_bits{1'b1}})) ) && ((mant_a == 0) && (mant_b == 0)) )
	begin
	out={sign, {expo_bits{1'b1}}, 1'b1, {(mant_bits-1){1'bX}}};
	done=1'b1;
	end
	
	/*
	case 2: Inf*Inf -> Inf or Inf*num -> Inf or num*Inf -> Inf
	inf i.e. E:11111111 m:00000000000000000000000
	*/

	else if(((exp_a == {expo_bits{1'b1}}) && (mant_a == 0)) || ((exp_b == {expo_bits{1'b1}}) && (mant_b == 0)))
	begin
		out={sign, {expo_bits{1'b1}},{mant_bits{1'b0}}};
		done=1'b1;
	end
	
	/*
	case 3: 0*num or num*0 or 0*0 -> 0
	else if(...)
	begin
	...
	end
	
	*/
	
	/*
	case 4: A is NaN
	A -> NaN i.e. E:11111111 m:1XXXXXXXXXXXXXXXXXXXXXX
	Output -> NaN i.e. E:11111111 m:1XXXXXXXXXXXXXXXXXXXXXX
	*/
	
	else if ((exp_a == {expo_bits{1'b1}}) && (mant_a != 0)) 
	begin
		out={sign, {expo_bits{1'b1}},mant_a};
		done=1'b1;
	end
	
		/*
	case 5: B is NaN
	A -> NaN i.e. E:11111111 m:1XXXXXXXXXXXXXXXXXXXXXX
	Output -> NaN i.e. E:11111111 m:1XXXXXXXXXXXXXXXXXXXXXX
	*/
	
	else if ((exp_b == {expo_bits{1'b1}}) && (mant_b != 0)) 
	begin
		out={sign, {expo_bits{1'b1}},mant_b};
		done=1'b1;
	end
	
	else
	//Normal case:
	begin
	
	//First check if exponent of either inputs is equal to 0 (double check from TA)
		if(exp_a == 0) 
		begin
			exp_a = {{(expo_bits-1){1'b0}},1'b1};
			mant_a_2 = {{1'b0}, mant_a};
		end 
		else 
		begin
			mant_a_2 = {{1'b1}, mant_a};
		end
		
		if(exp_b == 0) 
		begin
			exp_b = {{(expo_bits-1){1'b0}},1'b1};
			mant_b_2 = {{1'b0}, mant_b};
		end 
		else
		begin
			mant_b_2 = {{1'b1}, mant_b};
		end
		
		
	
	//2. add exponents of both numbers then subtract bias from the result (module)
	
	//3. multiply the mantissas (module) Note: 1.mantissaA * 1.mantissaB therefore mant_a_2 * mant_b_2
	    product = mant_a_2 * mant_b_2;
	
	//4. normalize (module) (note this will affect exponent)
	
		//make use of module
		exp_out=norm_exp;
		product=norm_mant;
	
	

	//5. overflow or underflow (depending on size of exponent) exit. accepted: 254>= exponent>=1
	
	//6. rounding module the product [22:0] at bit new_mantissa[23] if it's 0
	
	//7. normalize again if needed
	
	//8. check Overflow or underflow again
	
	//9. store final answer and set done bit


	end
	
end
	endmodule