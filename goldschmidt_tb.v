module goldschmidt_tb();
reg[31:0] dividend;
reg[31:0] divisor;
wire [31:0]quotient;
wire [31:0]rem;
wire  busy,ready;
reg start,clk;
parameter DELAY = 2;
reg clrn;

initial begin
	$display("time/tdividend/tdivisor/tquotient");
	$monitor("%g/t%d/t%d/t%d/t%d",$time,dividend,divisor,quotient,rem);
	clrn = 1'b1;
	#(DELAY/4) clrn = 1'b0;
	#(DELAY/4) clrn = 1'b1;
	start = 1'b1;
	clk = 1'b0;
	dividend = 99;
	divisor = 3;
end

always begin
	#DELAY clk = ~clk;
	if(ready)
		$finish;
end


goldschmidtVersion2 gs(dividend,divisor,start,clk,clrn,quotient,busy,ready,rem);



endmodule