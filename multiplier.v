
module multiplier #(parameter X =32)(input wire [X-1:0]A, input wire [X-1:0]B,output reg [X-1:0] out, output reg done);

localparam expo_bits = (X == 32) ? 8 : 11; 
localparam mant_bits = (X == 32) ? 23 : 52;

	reg [expo_bits-1:0] exp_a; 
	reg [expo_bits-1:0] exp_b;
	reg [mant_bits-1:0]mant_a; //23 bits in case of 32 bit input
	reg [mant_bits-1:0]mant_b;


	reg [mant_bits-1:0] mant_out;
	reg [expo_bits-1:0] exp_out;
	reg sign;
	
	reg [(2*(mant_bits)+1):0] product; //48 (i.e. [47:0]) in case of 32 bit input (man bits 23) and 106 in case of 64 bit input therefore 2*(man_bits+1) therefore from 2*(man_bits+1)-1 to 0

	
always @ (*)
begin

	done=1'b0; //at the beginning reset done bit
	
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
	case 3: 0*num or num*0 or 0*0 -> 0 (TO-DO)
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
	
	//2. add exponents of both numbers (exp_a and exp_b) then subtract bias from the result (TO-DO) -> No need for module
	//store result in exp_out
	
	
	//3. multiply the mantissas. Note: 1.mantissaA * 1.mantissaB therefore mant_a_2 * mant_b_2
	    product = {{1'b1}, mant_a} * {{1'b1},mant_b};
	
	//4. normalize and truncate (module) (note this will affect exponent)
	
		if(product[(2*(mant_bits)+1)] == 1) //if most significant (47 in 32 bits) is 1, normalization is needed
		begin
      exp_out = exp_out + 1;
      product = product >> 1;
		mant_out = product[45:23];
      end 
		else if((product[2*(mant_bits)] != 1) && (exp_out != 0)) //if most significant was zero and second most significant is also zero then normalize again
		begin
		exp_out = exp_out - 1;
		product = product << 1; 
      end
		
		/*
		output mantissa of size 46 for 32 bits is [45:0]
		to truncate take product[45:23] in case of 32 bits:
		*/
		mant_out = product[(2*(mant_bits)-1):((2*(mant_bits)-1)-mant_bits+1)];

	//5. overflow or underflow (depending on size of exponent) exit. accepted: 254>= exponent>=1 (TO-DO)
	
	
	//6. store final answer and set done bit
		out={sign, exp_out, mant_out};
		done=1'b1;

	end
	
end
	endmodule