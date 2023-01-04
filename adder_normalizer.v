module adder_normalizer #(parameter X = 32, parameter expo_bits = 8)(input [X-expo_bits:0] mant_in ,input [expo_bits-1:0] exp_in ,output reg [X-expo_bits:0] mant_out ,output reg [expo_bits-1:0] exp_out, output reg underflow); 
//reg [expo_bits-1:0] exp_temp;
//reg [X-expo_bits:0] mant_temp;

reg borrow;

//	exp_temp = exp_in;
//	mant_temp = mant_in;
//	while (mant_temp[X-expo_bits-1] != 1'b1)
//	begin
//		exp_temp = exp_temp - 1;
//		mant_temp = mant_temp << 1;
//	end
//	mant_out = mant_temp;
//	{borrow,exp_out} = exp_temp;
always @(*) 
begin
	borrow = 1'b0;
	if(X == 32) begin
		if(mant_in == 24'b0000000000000000000000) begin
			{borrow,exp_out} = 0;
			mant_out = mant_in;
		end else if (mant_in[23:1] == 23'b000000000000000000001) begin
			{borrow,exp_out} = exp_in - 22;
			mant_out = mant_in << 22;
		end else if (mant_in[23:2] == 22'b0000000000000000000001) begin
			{borrow,exp_out} = exp_in - 21;
			mant_out = mant_in << 21;
		end else if (mant_in[23:3] == 21'b000000000000000000001) begin
			{borrow,exp_out} = exp_in - 20;
			mant_out = mant_in << 20;
		end else if (mant_in[23:4] == 20'b00000000000000000001) begin
			{borrow,exp_out} = exp_in - 19;
			mant_out = mant_in << 19;
		end else if (mant_in[23:5] == 19'b0000000000000000001) begin
			{borrow,exp_out} = exp_in - 18;
			mant_out = mant_in << 18;
		end else if (mant_in[23:6] == 18'b000000000000000001) begin
			{borrow,exp_out} = exp_in - 17;
			mant_out = mant_in << 17;
		end else if (mant_in[23:7] == 17'b00000000000000001) begin
			{borrow,exp_out} = exp_in - 16;
			mant_out = mant_in << 16;
		end else if (mant_in[23:8] == 16'b0000000000000001) begin
			{borrow,exp_out} = exp_in - 15;
			mant_out = mant_in << 15;
		end else if (mant_in[23:9] == 15'b000000000000001) begin
			{borrow,exp_out} = exp_in - 14;
			mant_out = mant_in << 14;
		end else if (mant_in[23:10] == 14'b00000000000001) begin
			{borrow,exp_out} = exp_in - 13;
			mant_out = mant_in << 13;
		end else if (mant_in[23:11] == 13'b0000000000001) begin
			{borrow,exp_out} = exp_in - 12;
			mant_out = mant_in << 12;
		end else if (mant_in[23:12] == 12'b000000000001) begin
			{borrow,exp_out} = exp_in - 11;
			mant_out = mant_in << 11;
		end else if (mant_in[23:13] == 11'b00000000001) begin
			{borrow,exp_out} = exp_in - 10;
			mant_out = mant_in << 10;
		end else if (mant_in[23:14] == 10'b0000000001) begin
			{borrow,exp_out} = exp_in - 9;
			mant_out = mant_in << 9;
		end else if (mant_in[23:15] == 9'b000000001) begin
			{borrow,exp_out} = exp_in - 8;
			mant_out = mant_in << 8;
		end else if (mant_in[23:16] == 8'b00000001) begin
			{borrow,exp_out} = exp_in - 7;
			mant_out = mant_in << 7;
		end else if (mant_in[23:17] == 7'b0000001) begin
			{borrow,exp_out} = exp_in - 6;
			mant_out = mant_in << 6;
		end else if (mant_in[23:18] == 6'b000001) begin
			{borrow,exp_out} = exp_in - 5;
			mant_out = mant_in << 5;
		end else if (mant_in[23:19] == 5'b00001) begin
			{borrow,exp_out} = exp_in - 4;
			mant_out = mant_in << 4;
		end else if (mant_in[23:20] == 4'b0001) begin
			{borrow,exp_out} = exp_in - 3;
			mant_out = mant_in << 3;
		end else if (mant_in[23:21] == 3'b001) begin
			{borrow,exp_out} = exp_in - 2;
			mant_out = mant_in << 2;
		end else if (mant_in[23:22] == 2'b01) begin
			{borrow,exp_out} = exp_in - 1;
			mant_out = mant_in << 1;
		end		
	end else if(X == 64) begin
		if(mant_in == 53'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_00000) begin
			{borrow,exp_out} = 0;
			mant_out = mant_in;
		end else if(mant_in[52:1] == 52'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001) begin
			{borrow,exp_out} = exp_in - 51;
			mant_out = mant_in << 51;
		end else if (mant_in[52:30] == 51'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_001) begin
			{borrow,exp_out} = exp_in - 50;
			mant_out = mant_in << 50;
		end else if (mant_in[52:30] == 50'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_01) begin
			{borrow,exp_out} = exp_in - 49;
			mant_out = mant_in <<49;
		end else if (mant_in[52:30] == 49'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1) begin
			{borrow,exp_out} = exp_in - 48;
			mant_out = mant_in << 48;
		end else if (mant_in[52:30] == 48'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001) begin
			{borrow,exp_out} = exp_in - 47;
			mant_out = mant_in << 47;
		end else if (mant_in[52:30] == 47'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_001) begin
			{borrow,exp_out} = exp_in - 46;
			mant_out = mant_in << 46;
		end else if (mant_in[52:30] == 46'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_01) begin
			{borrow,exp_out} = exp_in - 45;
			mant_out = mant_in << 45;
		end else if (mant_in[52:30] == 45'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1) begin
			{borrow,exp_out} = exp_in - 44;
			mant_out = mant_in << 44;
		end else if (mant_in[52:30] == 44'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001) begin
			{borrow,exp_out} = exp_in - 43;
			mant_out = mant_in << 43;
		end else if (mant_in[52:30] == 43'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_001) begin
			{borrow,exp_out} = exp_in - 42;
			mant_out = mant_in << 42;
		end else if (mant_in[52:30] == 42'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_01) begin
			{borrow,exp_out} = exp_in - 41;
			mant_out = mant_in << 41;
		end else if (mant_in[52:30] == 41'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1) begin
			{borrow,exp_out} = exp_in - 40;
			mant_out = mant_in << 40;
		end else if (mant_in[52:30] == 40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0001) begin
			{borrow,exp_out} = exp_in - 39;
			mant_out = mant_in << 39;
		end else if (mant_in[52:30] == 39'b0000_0000_0000_0000_0000_0000_0000_0000_0000_001) begin
			{borrow,exp_out} = exp_in - 38;
			mant_out = mant_in << 38;
		end else if (mant_in[52:30] == 38'b0000_0000_0000_0000_0000_0000_0000_0000_0000_01) begin
			{borrow,exp_out} = exp_in - 37;
			mant_out = mant_in << 37;
		end else if (mant_in[52:30] == 37'b0000_0000_0000_0000_0000_0000_0000_0000_0000_1) begin
			{borrow,exp_out} = exp_in - 36;
			mant_out = mant_in << 36;
		end else if (mant_in[52:30] == 36'b0000_0000_0000_0000_0000_0000_0000_0000_0001) begin
			{borrow,exp_out} = exp_in - 35;
			mant_out = mant_in << 35;
		end else if (mant_in[52:30] == 35'b0000_0000_0000_0000_0000_0000_0000_0000_001) begin
			{borrow,exp_out} = exp_in - 34;
			mant_out = mant_in << 34;
		end else if (mant_in[52:30] == 34'b0000_0000_0000_0000_0000_0000_0000_0000_01) begin
			{borrow,exp_out} = exp_in - 33;
			mant_out = mant_in << 33;
		end else if (mant_in[52:30] == 33'b0000_0000_0000_0000_0000_0000_0000_0000_1) begin
			{borrow,exp_out} = exp_in - 32;
			mant_out = mant_in << 32;
		end else if (mant_in[52:30] == 32'b0000_0000_0000_0000_0000_0000_0000_0001) begin
			{borrow,exp_out} = exp_in - 31;
			mant_out = mant_in << 31;
		end else if (mant_in[52:30] == 31'b0000_0000_0000_0000_0000_0000_0000_001) begin
			{borrow,exp_out} = exp_in - 30;
			mant_out = mant_in << 30;
		end else if (mant_in[52:30] == 30'b0000_0000_0000_0000_0000_0000_0000_01) begin
			{borrow,exp_out} = exp_in - 29;
			mant_out = mant_in << 29;
		end else if (mant_in[52:30] == 29'b0000_0000_0000_0000_0000_0000_0000_1) begin
			{borrow,exp_out} = exp_in - 28;
			mant_out = mant_in << 28;
		end else if (mant_in[52:30] == 28'b0000_0000_0000_0000_0000_0000_0001) begin
			{borrow,exp_out} = exp_in - 27;
			mant_out = mant_in << 27;
		end else if (mant_in[52:30] == 27'b0000_0000_0000_0000_0000_0000_001) begin
			{borrow,exp_out} = exp_in - 26;
			mant_out = mant_in << 26;
		end else if (mant_in[52:30] == 26'b0000_0000_0000_0000_0000_0000_01) begin
			{borrow,exp_out} = exp_in - 25;
			mant_out = mant_in << 25;
		end else if (mant_in[52:30] == 25'b0000_0000_0000_0000_0000_0000_1) begin
			{borrow,exp_out} = exp_in - 24;
			mant_out = mant_in << 24;
		end else if (mant_in[52:30] == 24'b0000_0000_0000_0000_0000_0001) begin
			{borrow,exp_out} = exp_in - 23;
			mant_out = mant_in << 23;
		end else if (mant_in[52:30] == 23'b000000000000000000001) begin
			{borrow,exp_out} = exp_in - 22;
			mant_out = mant_in << 22;
		end else if (mant_in[52:31] == 22'b0000000000000000000001) begin
			{borrow,exp_out} = exp_in - 21;
			mant_out = mant_in << 21;
		end else if (mant_in[52:32] == 21'b000000000000000000001) begin
			{borrow,exp_out} = exp_in - 20;
			mant_out = mant_in << 20;
		end else if (mant_in[52:33] == 20'b00000000000000000001) begin
			{borrow,exp_out} = exp_in - 19;
			mant_out = mant_in << 19;
		end else if (mant_in[52:34] == 19'b0000000000000000001) begin
			{borrow,exp_out} = exp_in - 18;
			mant_out = mant_in << 18;
		end else if (mant_in[52:35] == 18'b000000000000000001) begin
			{borrow,exp_out} = exp_in - 17;
			mant_out = mant_in << 17;
		end else if (mant_in[52:36] == 17'b00000000000000001) begin
			{borrow,exp_out} = exp_in - 16;
			mant_out = mant_in << 16;
		end else if (mant_in[52:37] == 16'b0000000000000001) begin
			{borrow,exp_out} = exp_in - 15;
			mant_out = mant_in << 15;
		end else if (mant_in[52:38] == 15'b000000000000001) begin
			{borrow,exp_out} = exp_in - 14;
			mant_out = mant_in << 14;
		end else if (mant_in[52:39] == 14'b00000000000001) begin
			{borrow,exp_out} = exp_in - 13;
			mant_out = mant_in << 13;
		end else if (mant_in[52:40] == 13'b0000000000001) begin
			{borrow,exp_out} = exp_in - 12;
			mant_out = mant_in << 12;
		end else if (mant_in[52:41] == 12'b000000000001) begin
			{borrow,exp_out} = exp_in - 11;
			mant_out = mant_in << 11;
		end else if (mant_in[52:42] == 11'b00000000001) begin
			{borrow,exp_out} = exp_in - 10;
			mant_out = mant_in << 10;
		end else if (mant_in[52:43] == 10'b0000000001) begin
			{borrow,exp_out} = exp_in - 9;
			mant_out = mant_in << 9;
		end else if (mant_in[52:44] == 9'b000000001) begin
			{borrow,exp_out} = exp_in - 8;
			mant_out = mant_in << 8;
		end else if (mant_in[52:45] == 8'b00000001) begin
			{borrow,exp_out} = exp_in - 7;
			mant_out = mant_in << 7;
		end else if (mant_in[52:46] == 7'b0000001) begin
			{borrow,exp_out} = exp_in - 6;
			mant_out = mant_in << 6;
		end else if (mant_in[52:47] == 6'b000001) begin
			{borrow,exp_out} = exp_in - 5;
			mant_out = mant_in << 5;
		end else if (mant_in[52:48] == 5'b00001) begin
			{borrow,exp_out} = exp_in - 4;
			mant_out = mant_in << 4;
		end else if (mant_in[52:49] == 4'b0001) begin
			{borrow,exp_out} = exp_in - 3;
			mant_out = mant_in << 3;
		end else if (mant_in[52:50] == 3'b001) begin
			{borrow,exp_out} = exp_in - 2;
			mant_out = mant_in << 2;
		end else if (mant_in[52:51] == 2'b01) begin
			{borrow,exp_out} = exp_in - 1;
			mant_out = mant_in << 1;
		end
	end
 underflow = borrow;
end

endmodule