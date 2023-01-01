module division_tb();
reg[31:0] dividend;
reg[31:0] divisor;
wire [31:0]quotient;
//wire [31:0]rem;
wire  busy,ready;
reg start,clk;
parameter DELAY = 2;
reg clrn;
wire overflow = 0;
wire underflow = 0;
initial begin
	$display("time/tdividend/tdivisor/tquotient");
	$monitor("%g/t%b/t%b/t%b/t%b/t%b",$time,dividend,divisor,quotient,underflow,overflow);
	clrn = 1'b1;
//	#(DELAY/4) clrn = 1'b0;
//	#(DELAY/4) clrn = 1'b1;
		dividend = 32'b0_10000010_11110000000000000000000;
	divisor = 32'b1_10000000_10000000000000000000000;
	clk = 1'b0;
	start = 1'b1;
//	#(DELAY *1.5) start = 1'b0;

end

always begin
	#DELAY clk = ~clk;
//	if(ready)
//		$finish;
end


division divi (dividend,divisor,quotient,start,clk,clrn,overflow,underflow);



endmodule