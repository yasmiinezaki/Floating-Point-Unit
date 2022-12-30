module goldschmidtSV_tb();
reg[31:0] dividend;
reg[31:0] divisor;
wire [31:0]quotient;
wire [31:0]rem;
wire  busy,ready;
reg start,clk;
parameter DELAY = 2;
reg clrn;
//shortreal x = 3.5;
initial begin
	$display("time/tdividend/tdivisor/tquotient");
	$monitor("%g/t%d/t%d/t%d/t%d",$time,dividend,divisor,quotient,rem);
	clrn = 1'b1;
	#(DELAY/4) clrn = 1'b0;
	#(DELAY/4) clrn = 1'b1;
	start = 1'b1;
	clk = 1'b0;
	dividend = 32'b0_10000000000_1100000000000000000000000000000000000000000000000000;
	divisor = 32'b0_10000000000_0000000000000000000000000000000000000000000000000000;
end

always begin
	#DELAY clk = ~clk;
	if(ready)
		$finish;
end


goldschmidt gs(dividend,divisor,start,clk,clrn,quotient,busy,ready,rem);



endmodule