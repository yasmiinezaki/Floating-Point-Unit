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

// 

module adder_tb();

reg [0:31]in_data_A;
reg [0:31]in_data_B;
wire [0:31] out_data;
wire done;
wire overflow;
wire underflow;

integer i;
integer failed_test_count;


localparam T = 150;
reg [0:639] Data_to_input_A;
reg [0:639] Data_to_input_B;
reg [0:639] Expected_data;
reg [0:639] Data_output;
reg [0:19] UnderFlow_output;
reg [0:19] OverFlow_output;
reg [0:19] UnderFlow_expected;
reg [0:19] OverFlow_expected;

adder #(32) inst (in_data_A,in_data_B,out_data,done,overflow,underflow);
initial begin
	Data_to_input_A <= 640'h4001000080000000400800004108000040090000400d0000c0090000C40D0000400D0000400d000040C6800000000000009000007FC00000_7f800000_7f800000_ff800000_ff800000_40010000;
	Data_to_input_B <= 640'h0000000030020000400b00004009000044090000c0090000400d0000400D0000C40D0000c00d0000C0CCE66680000000808000007FC00000_40010000_ff800000_7f800000_ff800000_7f800000;
	Expected_data <=   640'h400100003002000040898000412a4000440989003d8000003d800000C40C7300C40C730080000000BE4CCCC08000000000000000FFFFFFFF_7f800000_FFFFFFFF_FFFFFFFF_ff800000_7f800000;
	UnderFlow_expected <= 20'b00000000000001000000;
	//OverFlow_expected <=  20'b00000000000000100000;
	OverFlow_expected <=  20'b00000000000000000000;
	for(i = 0; i< 640; i = i+32)
	begin
		#(T)
		//$monitor ("%h      %h		%h\t",in_data_A,in_data_B,out_data);
		in_data_A = Data_to_input_A[i+:32];
		in_data_B = Data_to_input_B[i+:32];
		
		#(T)
		Data_output[i+:32] = out_data;
		OverFlow_output[i/32] = overflow;
		UnderFlow_output[i/32] = underflow;
	end
	
	$display("output = %h", Data_output);
	failed_test_count =0;
	for(i = 0; i< 640; i = i+32)
	begin
		if(OverFlow_expected[i/32] == 1 || UnderFlow_expected[i/32] == 1) begin
			if(OverFlow_output[i/32] != OverFlow_expected[i/32] || UnderFlow_output[i/32] != UnderFlow_expected[i/32]) begin
				$display("Test Input A: %h Test Input B: %h Expected Output: %h, Expected Overflow: %b, Expected Underflow: %b, Actual Output: %h, Actual Overflow: %b, Actual Underflow: %b \n",Data_to_input_A[i+:32],Data_to_input_B[i+:32],Expected_data[i+:32],OverFlow_expected[i/32], UnderFlow_expected[i/32], Data_output[i+:32], OverFlow_output[i/32], UnderFlow_output[i/32]);
				failed_test_count = failed_test_count+1;
			end 
		end 
		if(OverFlow_expected[i/32] == 0 && UnderFlow_expected[i/32] == 0) begin
			if((Data_output[i+:32] != Expected_data[i+:32]) || (OverFlow_output[i/32] != OverFlow_expected[i/32]) || (UnderFlow_output[i/32] != UnderFlow_expected[i/32])) begin
				$display("Test Input A: %h Test Input B: %h Expected Output: %h, Expected Overflow: %b, Expected Underflow: %b, Actual Output: %h, Actual Overflow: %b, Actual Underflow: %b \n",Data_to_input_A[i+:32],Data_to_input_B[i+:32],Expected_data[i+:32],OverFlow_expected[i/32], UnderFlow_expected[i/32], Data_output[i+:32], OverFlow_output[i/32], UnderFlow_output[i/32]);
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