module FPU #(parameter X=32)(input [X-1:0] A, input [X-1:0] B,output reg [X-1:0] Out, input clk,input reset,input [1:0] opcode, output reg done,output reg overflow,output reg underflow);

wire overflow_add;
wire underflow_add;

wire overflow_multi;
wire underflow_multi;

wire overflow_div;
wire underflow_div;

wire done_add;
wire done_multi;
wire done_div;

reg [X-1:0] adder_a_in;
reg [X-1:0] adder_b_in;
wire [X-1:0] adder_out;

reg [X-1:0] multiplier_a_in;
reg [X-1:0] multiplier_b_in;
wire [X-1:0] multiplier_out;

reg [X-1:0] divider_a_in;
reg [X-1:0] divider_b_in;
wire [X-1:0] divider_out;

reg addition;
reg subtraction;
reg multiplication;
reg division;

//assign addition = (opcode == 2'b00)? 1'b1:1'b0;
//assign subtraction = (opcode == 2'b01)? 1'b1:1'b0;
//assign multiplication = (opcode == 2'b10)? 1'b1:1'b0;
//assign division = (opcode == 2'b11)? 1'b1:1'b0;

adder #(X) inst1 (adder_a_in,adder_b_in,adder_out,done_add,overflow_add,underflow_add);
multiplier #(X) inst3 (multiplier_a_in, multiplier_b_in,multiplier_out, done_multi, overflow_multi,underflow_multi);
division #(X) inst4 (divider_a_in,divider_b_in,divider_out,1'b1,clk,reset,overflow_div,underflow_div);

always @(posedge clk) begin
	done =1'b0;
	addition = (opcode == 2'b00)? 1'b1:1'b0;
	subtraction = (opcode == 2'b01)? 1'b1:1'b0;
	multiplication = (opcode == 2'b10)? 1'b1:1'b0;
	division = (opcode == 2'b11)? 1'b1:1'b0;
	if(addition)begin
		adder_a_in = A;
		adder_b_in = B;
		
		Out = adder_out;
		done = done_add;
		
		overflow = overflow_add;
		underflow = underflow_add;
		
	end else if (subtraction) begin
		adder_a_in = A;
		adder_b_in ={~B[X-1],B[X-2:0]};
		
		Out = adder_out;
		done = done_add;
		
		overflow = overflow_add;
		underflow = underflow_add;
	end else if (multiplication) begin
		multiplier_a_in = A;
		multiplier_b_in = B;
		
		Out = multiplier_out;
		done = done_multi;
		
		overflow = overflow_multi;
		underflow = underflow_multi;
	end else if (division) begin
		divider_a_in = A;
		divider_b_in = B;
		
		Out = divider_out;
		done = done_div;
		
		overflow = overflow_div;
		underflow = underflow_div;
	end

end

endmodule