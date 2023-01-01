module multiplier #(parameter X =32)
(input wire [X-1:0]A, input wire [X-1:0]B,output reg [X-1:0] out, output reg done, 	output reg overflow_flag, output reg underflow_flag);

localparam expo_bits = (X == 32) ? 8   : 11; 
localparam mant_bits = (X == 32) ? 23  : 52;
localparam bias = (X == 32) ? 127 : 1023;

	reg [expo_bits-1:0] exp_a; 
	reg [expo_bits-1:0] exp_b;
	reg [expo_bits-1:0] exp_out;
	
	//23-bits in case of 32 bit input
	reg [mant_bits-1:0] mant_a; 
	reg [mant_bits-1:0] mant_b;
	reg [mant_bits-1:0] mant_out;
	
	reg sign;
	reg cout = 0;
   reg cout_2 = 0;
	
	



	
	//48 (i.e. [47:0]) in case of 32 bit input (man bits 23) and 
	//106 in case of 64 bit input therefore 2*(man_bits+1) 
	//therefore from 2*(man_bits+1)-1 to 0
	reg [(2*(mant_bits)+1):0] product; 

	
always @ (*)
begin
overflow_flag = 0;
	underflow_flag = 0;
	
	exp_a = A[X-2:X-expo_bits-1];
	exp_b = B[X-2:X-expo_bits-1];
	
	mant_a = A[X-expo_bits-2:0];
	mant_b = B[X-expo_bits-2:0];



	done=1'b0; //at the beginning reset done bit

//1. calculate sign bit (general even for special numbers)
	sign=A[X-1]^B[X-1]; //XOR of 2 input bits

//2. check for special cases:

	/*case 1: 0*inf or inf*0 -> NaN
	A -> 0 i.e. E:00000000 m:00000000000000000000000
	B -> inf i.e. E:11111111 m:00000000000000000000000
	or vice versa
	Output -> NaN i.e. E:11111111 m:1XXXXXXXXXXXXXXXXXXXXXX*/
	if( ( ((exp_a == 0) && (exp_b == {expo_bits{1'b1}})) || ((exp_b== 0) && (exp_a == {expo_bits{1'b1}})) ) && ((mant_a == 0) && (mant_b == 0)) ) begin
		out={sign, {expo_bits{1'b1}}, 1'b1, {(mant_bits-1){1'bX}}};
		done=1'b1;
	end

	/*case 2: Inf*Inf -> Inf or Inf*num -> Inf or num*Inf -> Inf
	inf i.e. E:11111111 m:00000000000000000000000*/
	else if(((exp_a == {expo_bits{1'b1}}) && (mant_a == 0)) || ((exp_b == {expo_bits{1'b1}}) && (mant_b == 0))) begin
		out={sign, {expo_bits{1'b1}},{mant_bits{1'b0}}};
		done=1'b1;
	end

	/*case 3: 0*num or num*0 or 0*0 -> 0 (TO-DO)*/
	//--------------------------------------------------------------------------------------------------------------------------- 
	//If at least one of the operands was zero, the output must be zero.
	else if ((exp_a == 0 && mant_a == 0) || (exp_b == 0 && mant_b == 0)) begin
		out = {{sign}, {expo_bits{1'b0}}, {mant_bits{1'b0}}};
	end
	//--------------------------------------------------------------------------------------------------------------------------- 

	/*case 4: A is NaN
	A -> NaN i.e. E:11111111 m:1XXXXXXXXXXXXXXXXXXXXXX
	Output -> NaN i.e. E:11111111 m:1XXXXXXXXXXXXXXXXXXXXXX*/

	else if ((exp_a == {expo_bits{1'b1}}) && (mant_a != 0)) begin
		out={sign, {expo_bits{1'b1}},mant_a};
		done=1'b1;
	end

	/*case 5: B is NaN
	A -> NaN i.e. E:11111111 m:1XXXXXXXXXXXXXXXXXXXXXX
	Output -> NaN i.e. E:11111111 m:1XXXXXXXXXXXXXXXXXXXXXX*/
	else if ((exp_b == {expo_bits{1'b1}}) && (mant_b != 0)) begin
		out={sign, {expo_bits{1'b1}},mant_b};
		done=1'b1;
	end

	//Normal case:
	else begin
//3. add exponents of both numbers (exp_a and exp_b) then subtract bias from the result (TO-DO) -> No need for module
		//store result in exp_out
		//--------------------------------------------------------------------------------------------------------------------------- 
		{cout, exp_out} = exp_a + exp_b - bias;
		//--------------------------------------------------------------------------------------------------------------------------- 

//4. multiply the mantissas. Note: 1.mantissaA * 1.mantissaB therefore mant_a_2 * mant_b_2
		product = {{1'b1}, mant_a} * {{1'b1},mant_b};

//5. normalize and truncate (module) (note this will affect exponent)
		//if most significant (47 in 32 bits) is 1, normalization is needed
		if(product[(2*(mant_bits)+1)] == 1) begin
			{cout_2, exp_out} = exp_out + 1;
			product = product >> 1;
		end 
		//if most significant was zero and second most significant is also zero then normalize again
		else if((product[2*(mant_bits)] != 1) && (exp_out != 0)) begin
			exp_out = exp_out - 1;
			product = product << 1; 
		end

		/*output mantissa of size 46 for 32 bits is [45:0]
		to truncate take product[45:23] in case of 32 bits:*/
		mant_out = product[(2*(mant_bits)-1):((2*(mant_bits)-1)-mant_bits+1)];

//6. overflow or underflow (depending on size of exponent) exit. accepted: 254>= exponent>=1 (TO-DO)
		//--------------------------------------------------------------------------------------------------------------------------- 
		//To avoid dealing with "Carries" and "Borrows" check for overflow and underflow 
		//before subtracting the bias from the sum of the two biased exponentials.

		//Let A_Exponent and B_Exponent be the biased exponents of the two inputs A and B respectively.

		//The value of each exponent is expected to range from 1 to (bias * 2).

		//if ((A_Exponent + B_Exponent) <= bias) then you would expect that after subtracting the bias 
		//you would get a value less than the minimum accepted value for the exponent (which is 1) 
		//this is when underflow is detected.

		//if ((A_Exponent + B_Exponent) >= (bias * 2)) then you would expect that after subtracting the bias 
		//you would get a value greater than the maximum accepted value for the exponent (which is (bias * 2)) 
		//this is when overflow is detected.

		//if underflow was detected then output = zero.
		//if overflow was detected then output = infinity.


		//Handling Underflow.
		//Expected Output: Zero
		if ((exp_a + exp_b) <= bias) begin
			out = {{sign}, {expo_bits{1'b0}}, {mant_bits{1'b0}}};
			underflow_flag = 1;
			done=1'b1;	
		end

		//Handling Overflow.
		//Expected Output: Infinity
		
		/*else if ((exp_a + exp_b) >= (bias * 2)) begin
			out = {{sign}, {expo_bits{1'b1}}, {mant_bits{1'b1}}};
			done=1'b1;	
		 end*/
		 
		 else if(cout ==1 || cout_2 ==1) begin
			out = {{sign}, {expo_bits{1'b1}}, {mant_bits{1'bX}}};
			overflow_flag = 1;
			done=1'b1;	
		 end
		 
		//--------------------------------------------------------------------------------------------------------------------------- 
		else begin
//7. store final answer and set done bit
			out={sign, exp_out, mant_out};
			done=1'b1;	
		end

	end
end
endmodule 