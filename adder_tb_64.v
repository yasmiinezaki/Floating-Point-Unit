`timescale 1 ps / 1 ps

// tests 1) -ve and -ve zero  40010000  00000000  40010000 / 80000000 30020000 30020000 / 00000000 80000000 80000000
//			2)equal signs & equal exponents 40080000 400b0000 40898000
//			3)equal signs expo_a> expo_b 41080000 40090000 412a4000
//			4)equal sign expo_b > expo_a 40090000 44090000 44098900
//non equal sign equal exponents manta_a == manta_b 400d0000 c00d0000 80000000
//non equal sign equal expo & manta_a>manta_b 400d0000 c0090000 3d800000
//non equal sign equal expo & manta_b>manta_a c0090000 400d0000 3d800000
// non equal sign expo_a > expo_b C40D0000 400D0000 C40C7300
// non equal sign expo_b > expo_a 400D0000 C40D0000 C40C7300
// carry shifting 40C68000 40468000 4114E000
//  normalisation 40C68000 C0CCE666 BE4CCCC0
// overflow
// underflow

module adder_tb_64();

reg [0:63]in_data_A;
reg [0:63]in_data_B;
wire [0:63] out_data;
wire done;
wire overflow;
wire underflow;

integer i;
integer failed_test_count;


localparam T = 150;
reg [0:1343] Data_to_input_A;
reg [0:1343] Data_to_input_B;
reg [0:1343] Expected_data;
reg [0:1343] Data_output;
reg [0:20] UnderFlow_output;
reg [0:20] OverFlow_output;
reg [0:20] UnderFlow_expected;
reg [0:20] OverFlow_expected;

adder #(64) inst (in_data_A,in_data_B,out_data,done,overflow,underflow);
initial begin
	Data_to_input_A <= 1344'h0000000000000000_4001000000000000_8000000000000000_400CC6A7EF9DB22D_400CC6A7EF9DB22D_400CC6A7EF9DB22D_400CC6A7EF9DB22D_C00CF6A7EFFDB22D_400486A7EF9D0000_C06CF6A7EFFDB22D_C00CF6A7EFFDB22D_C00036A7EFFDB22D_40E036A7EFFDB22D_C0E036A7EFFDB22D_0010000000000000_7FF0000000000000_7FF0000000000000_FFF0000000000000_FFF0000000000000_4001C00000000000;
	Data_to_input_B <= 1344'h0000000000000000_0000000000000000_400CC6A7EF9DB22D_4001C00000000000_4011020180000000_400CC6A7EF9DB22D_C00CC6A7EF9DB22D_400486A7EF9D0000_C00CF6A7EFFDB22D_400486A7EF9D0000_406486A7EF9D0000_406486A7EF9DB22D_C02486A7EF9D0000_C02486A7EF9DE000_8010000000000003_4001C00000000000_FFF0000000000000_7FF0000000000000_FFF0000000000000_7FF0000000000000;
	Expected_data <=   1344'h0000000000000000_4001000000000000_400CC6A7EF9DB22D_40174353F7CED916_401F655577CED916_401CC6A7EF9DB22D_8000000000000000_BFF0E00000C1645A_BFF0E00000C1645A_C06CA48D503F3E2D_406412CD4FDD0938_406445cd4fddbb65_40E0355F857EB85D_C0E037F05A7CAC0B_8000000000000003_7FF0000000000000_FFFFFFFFFFFFFFFF_FFFFFFFFFFFFFFFF_FFF0000000000000_7FF0000000000000;
	UnderFlow_expected <= 21'b000000000000000100000;
	OverFlow_expected <=  21'b000000000000000000000;
	for(i = 0; i< 1024; i = i+64)
	begin
		#(T)
		//$monitor ("%h      %h		%h\t",in_data_A,in_data_B,out_data);
		in_data_A = Data_to_input_A[i+:64];
		in_data_B = Data_to_input_B[i+:64];
		
		#(T)
		Data_output[i+:64] = out_data;
		OverFlow_output[i/64] = overflow;
		UnderFlow_output[i/64] = underflow;
	end
	
	//$display("output = %h", Data_output);
	failed_test_count =0;
	for(i = 0; i< 1024; i = i+64)
	begin
		if(OverFlow_expected[i/64] == 1 || UnderFlow_expected[i/64] == 1) begin
			if(OverFlow_output[i/64] != OverFlow_expected[i/64] || UnderFlow_output[i/64] != UnderFlow_expected[i/64]) begin
				$display("%d: Test Input A: %h Test Input B: %h Expected Output: %h, Expected Overflow: %b, Expected Underflow: %b, Actual Output: %h, Actual Overflow: %b, Actual Underflow: %b \n",i, Data_to_input_A[i+:64],Data_to_input_B[i+:64],Expected_data[i+:64],OverFlow_expected[i/64], UnderFlow_expected[i/64], Data_output[i+:64], OverFlow_output[i/64], UnderFlow_output[i/64]);
				failed_test_count = failed_test_count+1;
			end 
		end 
		if(OverFlow_expected[i/64] == 0 && UnderFlow_expected[i/64] == 0) begin
			if((Data_output[i+:64] != Expected_data[i+:64]) || (OverFlow_output[i/64] != OverFlow_expected[i/64]) || (UnderFlow_output[i/64] != UnderFlow_expected[i/64])) begin
				$display("%d: Test Input A: %h Test Input B: %h Expected Output: %h, Expected Overflow: %b, Expected Underflow: %b, Actual Output: %h, Actual Overflow: %b, Actual Underflow: %b \n",i, Data_to_input_A[i+:64],Data_to_input_B[i+:64],Expected_data[i+:64],OverFlow_expected[i/64], UnderFlow_expected[i/64], Data_output[i+:64], OverFlow_output[i/64], UnderFlow_output[i/64]);
				failed_test_count = failed_test_count+1;
			end
		end
	end
	if (failed_test_count ==0) $display("All Tests succeeded\n", i);
	else begin
		$display("failed test count: %d\n",failed_test_count);
	end
	
	
	$finish;
end
endmodule