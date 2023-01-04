`timescale 1 ps / 1 ps

module fpu_tb();

reg [0:1]opcode;
reg clk;
reg reset;
reg [0:31]in_data_a;
reg [0:31]in_data_b;

wire [0:31]out_data;
wire done;

integer i;
integer failed_test_count;
localparam T = 100;

reg [0:31] Expected_data_add;
reg [0:31] Expected_data_sub;
reg [0:31] Expected_data_multi;
reg [0:31] Expected_data_div;

FPU #(32)inst(in_data_a,in_data_b,out_data, clk,reset,opcode,done);	

always
	#(T/2) clk = ~clk;

	
initial begin
	
	in_data_a <= 32'h41C80000;//25
	in_data_b <= 32'h40A00000;//5
	
	Expected_data_add <= 32'h41F00000;
	Expected_data_sub <= 32'h41A00000;
	Expected_data_multi <= 32'h42FA0000;
	Expected_data_div <= 32'h40A00000;
	clk = 1;
	reset = 1'b0;
	
	#(T)
	opcode = 2'b00; // add
	
	failed_test_count = 0;
	#(T)
	if (out_data != Expected_data_add) begin
		$display("Test Input A: %h Test Input B: %h Expected Output: %h Actual Output: %h \n",in_data_a,in_data_b,Expected_data_add,out_data);
		failed_test_count = failed_test_count +1;
	end
	
	//#(T)
	opcode = 2'b01;//sub
	#(2*T)
	if (out_data != Expected_data_sub) begin
		$display("Test Input A: %h Test Input B: %h Expected Output: %h Actual Output: %h \n",in_data_a,in_data_b,Expected_data_sub,out_data);
		failed_test_count = failed_test_count +1;
	end
	
	//#(T)
	opcode = 2'b10; // multi
	#(2*T)
	if (out_data != Expected_data_multi) begin
		$display("Test Input A: %h Test Input B: %h Expected Output: %h Actual Output: %h \n",in_data_a,in_data_b,Expected_data_multi,out_data);
		failed_test_count = failed_test_count +1;
	end
	
	//#(T)
	opcode = 2'b11; // div
	#(2*T)
	if (out_data != Expected_data_div) begin
		$display("Test Input A: %d Test Input B: %d Expected Output: %d Actual Output: %d \n",in_data_a,in_data_b,Expected_data_div,out_data);
		failed_test_count = failed_test_count +1;
	end
	
	if (failed_test_count ==0) $display("All Tests succeeded\n", i);
	else begin
		$display("failed test count: %d\n",failed_test_count);
	end
	
	$finish;
	
end

endmodule
