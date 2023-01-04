module multiplier_tb_3();

reg [63: 0]in_data_A;
reg [63: 0]in_data_B;
wire[63: 0]out_data;

wire done = 0;
wire overflow_flag = 0;
wire underflow_flag = 0;



integer i;
integer failed_test_count;


localparam T = 150;

reg [127: 0] Data_to_input_A;
reg [127: 0] Data_to_input_B;
reg [127: 0] Expected_data;
reg [127: 0] Data_output;

multiplier #(64) inst (in_data_A,in_data_B,out_data,done, overflow_flag, underflow_flag);

initial begin
	Data_to_input_A	<= 128'b 01111111111100000000000000000000000000000000000000000000000000000111111111110000000000000000000000000000000000000000000000000000;
	Data_to_input_B	<= 128'b 01111111111100000000000000000000000000000000000000000000000000000111110011110000000000000000000001100000000000000110000000000000;
	Expected_data		<= 128'b 01111111111100000000000000000000000000000000000000000000000000000111111111110000000000000000000000000000000000000000000000000000;
	
	for(i = 0; i< 128; i = i+64)
	begin
		#(T)
		$monitor ("%b      %b		%b\t",in_data_A,in_data_B,out_data);
		in_data_A = Data_to_input_A[i+:64];
		in_data_B = Data_to_input_B[i+:64];
		#(T)
		Data_output[i+:64] = out_data;
	end
	
		$display("output = %b", Data_output);
		failed_test_count =0;
		for(i = 0; i< 128; i = i+64)
		begin
			if(Data_output[i+:64] != Expected_data[i+:64]) begin
				$display("Test Input A: %b Test Input B: %b Expected Output: %b Actual Output: %b \n",Data_to_input_A[i+:64],Data_to_input_B[i+:64],Expected_data[i+:64],Data_output[i+:64]);
				failed_test_count = failed_test_count+1;
			end
		end
		if (failed_test_count ==0) $display("All Tests succeeded\n", i);
		else begin
			$display("failed test count: %d\n",failed_test_count);
		end
		
	$finish;
end
endmodule