module goldschmidtVersion2 #(parameter X =32) (a,b,start,clk,clrn,q,ready,yn);

localparam expo_bits = (X == 32) ? 8   : 11; 
localparam mant_bits = (X == 32) ? 23  : 52;
localparam bias = (X == 32) ? 127 : 1023;



input [31:0] a; 
input [31:0] b; 
input start; // start
input clk, clrn; // clock and reset
output [31:0] q; 
//output reg busy; 
output reg ready;
//output [2:0] count; 
output [31:0] yn; 
reg [63:0] reg_a; 
reg [63:0] reg_b; 
reg [63:0] reg_b_Negative; 
reg [2:0] count;
wire [63:0] two_minus_yi;// 2's complement
wire [63:0] twoWire = 64'b0_10000000000_0000000000000000000000000000000000000000000000000000;
wire done,overflow,underflow;
wire mostSignificant1 = 64'b1_00000000000_0000000000000000000000000000000000000000000000000000;
wire [31:0] dNegative = q | mostSignificant1;

wire [127:0] xi = reg_a * two_minus_yi; // 0x.xxx...x
wire [127:0] yi = reg_b * two_minus_yi; // 0x.xxx...x
//assign q = reg_a[63:32] + |reg_a[31:29]; // rounding up
assign q = reg_a[63:32];
assign yn = reg_b[62:31];
always @ (posedge clk or negedge clrn) begin
if (!clrn) begin
//busy <= 0;
ready <= 0;
end else begin
if (start) begin
reg_a <= {1'b0,a,31'b0}; 
reg_b <= {1'b0,b,31'b0}; 
reg_b_Negative <= {1'b1,b,31'b0};
//busy <= 1;
ready <= 0;
count <= 0;
end else begin
reg_a <= xi[126:63]; 
reg_b <= yi[126:63]; 
reg_b_Negative <= reg_b | mostSignificant1;
count <= count + 3'b1; 
if (count == 3'h7) begin 
//busy <= 0;
ready <= 1; // q is ready
end
end
end
end

adder #(64) inst (twoWire,reg_b_Negative,two_minus_yi,done,overflow,underflow);
//multiplier multiplier #(64) inst2 (reg_a,two_minus_yi,);

endmodule