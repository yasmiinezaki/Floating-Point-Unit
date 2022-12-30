//<<<<<<< Updated upstream
module adder_normalizer #(parameter X =32, parameter expo_bits = 8)
(input [X-expo_bits:0] mant_in ,input [expo_bits-1:0] exp_in ,output reg [X-expo_bits:0] mant_out ,output reg [expo_bits-1:0] exp_out);

//reg [expo_bits-1:0] exp_temp;
//reg [X-expo_bits:0] mant_temp;

always @(*)
begin

//	exp_temp = exp_in;
//	mant_temp = mant_in;
//	while (mant_temp[X-expo_bits-1] != 1'b1)
//	begin
//		exp_temp = exp_temp - 1;
//		mant_temp = mant_temp << 1;
//	end
//	mant_out = mant_temp;
//	exp_out = exp_temp;
		if (mant_in[23:1] == 23'b000000000000000000001) begin
			exp_out = exp_in - 22;
			mant_out = mant_in << 22;
		end else if (mant_in[23:2] == 22'b0000000000000000000001) begin
			exp_out = exp_in - 21;
			mant_out = mant_in << 21;
		end else if (mant_in[23:3] == 21'b000000000000000000001) begin
			exp_out = exp_in - 20;
			mant_out = mant_in << 20;
		end else if (mant_in[23:4] == 20'b00000000000000000001) begin
			exp_out = exp_in - 19;
			mant_out = mant_in << 19;
		end else if (mant_in[23:5] == 19'b0000000000000000001) begin
			exp_out = exp_in - 18;
			mant_out = mant_in << 18;
		end else if (mant_in[23:6] == 18'b000000000000000001) begin
			exp_out = exp_in - 17;
			mant_out = mant_in << 17;
		end else if (mant_in[23:7] == 17'b00000000000000001) begin
			exp_out = exp_in - 16;
			mant_out = mant_in << 16;
		end else if (mant_in[23:8] == 16'b0000000000000001) begin
			exp_out = exp_in - 15;
			mant_out = mant_in << 15;
		end else if (mant_in[23:9] == 15'b000000000000001) begin
			exp_out = exp_in - 14;
			mant_out = mant_in << 14;
		end else if (mant_in[23:10] == 14'b00000000000001) begin
			exp_out = exp_in - 13;
			mant_out = mant_in << 13;
		end else if (mant_in[23:11] == 13'b0000000000001) begin
			exp_out = exp_in - 12;
			mant_out = mant_in << 12;
		end else if (mant_in[23:12] == 12'b000000000001) begin
			exp_out = exp_in - 11;
			mant_out = mant_in << 11;
		end else if (mant_in[23:13] == 11'b00000000001) begin
			exp_out = exp_in - 10;
			mant_out = mant_in << 10;
		end else if (mant_in[23:14] == 10'b0000000001) begin
			exp_out = exp_in - 9;
			mant_out = mant_in << 9;
		end else if (mant_in[23:15] == 9'b000000001) begin
			exp_out = exp_in - 8;
			mant_out = mant_in << 8;
		end else if (mant_in[23:16] == 8'b00000001) begin
			exp_out = exp_in - 7;
			mant_out = mant_in << 7;
		end else if (mant_in[23:17] == 7'b0000001) begin
			exp_out = exp_in - 6;
			mant_out = mant_in << 6;
		end else if (mant_in[23:18] == 6'b000001) begin
			exp_out = exp_in - 5;
			mant_out = mant_in << 5;
		end else if (mant_in[23:19] == 5'b00001) begin
			exp_out = exp_in - 4;
			mant_out = mant_in << 4;
		end else if (mant_in[23:20] == 4'b0001) begin
			exp_out = exp_in - 3;
			mant_out = mant_in << 3;
		end else if (mant_in[23:21] == 3'b001) begin
			exp_out = exp_in - 2;
			mant_out = mant_in << 2;
		end else if (mant_in[23:22] == 2'b01) begin
			exp_out = exp_in - 1;
			mant_out = mant_in << 1;
		end

end

//=======
module adder_normalizer #(parameter X =32, parameter expo_bits = 8)(input [X-expo_bits:0] mant_in ,input [expo_bits-1:0] exp_in ,output reg [X-expo_bits:0] mant_out ,output reg [expo_bits-1:0] exp_out);

//reg [expo_bits-1:0] exp_temp;
//reg [X-expo_bits:0] mant_temp;

always @(*)
begin

//	exp_temp = exp_in;
//	mant_temp = mant_in;
//	while (mant_temp[X-expo_bits-1] != 1'b1)
//	begin
//		exp_temp = exp_temp - 1;
//		mant_temp = mant_temp << 1;
//	end
//	mant_out = mant_temp;
//	exp_out = exp_temp;
		if (mant_in[23:1] == 23'b000000000000000000001) begin
			exp_out = exp_in - 22;
			mant_out = mant_in << 22;
		end else if (mant_in[23:2] == 22'b0000000000000000000001) begin
			exp_out = exp_in - 21;
			mant_out = mant_in << 21;
		end else if (mant_in[23:3] == 21'b000000000000000000001) begin
			exp_out = exp_in - 20;
			mant_out = mant_in << 20;
		end else if (mant_in[23:4] == 20'b00000000000000000001) begin
			exp_out = exp_in - 19;
			mant_out = mant_in << 19;
		end else if (mant_in[23:5] == 19'b0000000000000000001) begin
			exp_out = exp_in - 18;
			mant_out = mant_in << 18;
		end else if (mant_in[23:6] == 18'b000000000000000001) begin
			exp_out = exp_in - 17;
			mant_out = mant_in << 17;
		end else if (mant_in[23:7] == 17'b00000000000000001) begin
			exp_out = exp_in - 16;
			mant_out = mant_in << 16;
		end else if (mant_in[23:8] == 16'b0000000000000001) begin
			exp_out = exp_in - 15;
			mant_out = mant_in << 15;
		end else if (mant_in[23:9] == 15'b000000000000001) begin
			exp_out = exp_in - 14;
			mant_out = mant_in << 14;
		end else if (mant_in[23:10] == 14'b00000000000001) begin
			exp_out = exp_in - 13;
			mant_out = mant_in << 13;
		end else if (mant_in[23:11] == 13'b0000000000001) begin
			exp_out = exp_in - 12;
			mant_out = mant_in << 12;
		end else if (mant_in[23:12] == 12'b000000000001) begin
			exp_out = exp_in - 11;
			mant_out = mant_in << 11;
		end else if (mant_in[23:13] == 11'b00000000001) begin
			exp_out = exp_in - 10;
			mant_out = mant_in << 10;
		end else if (mant_in[23:14] == 10'b0000000001) begin
			exp_out = exp_in - 9;
			mant_out = mant_in << 9;
		end else if (mant_in[23:15] == 9'b000000001) begin
			exp_out = exp_in - 8;
			mant_out = mant_in << 8;
		end else if (mant_in[23:16] == 8'b00000001) begin
			exp_out = exp_in - 7;
			mant_out = mant_in << 7;
		end else if (mant_in[23:17] == 7'b0000001) begin
			exp_out = exp_in - 6;
			mant_out = mant_in << 6;
		end else if (mant_in[23:18] == 6'b000001) begin
			exp_out = exp_in - 5;
			mant_out = mant_in << 5;
		end else if (mant_in[23:19] == 5'b00001) begin
			exp_out = exp_in - 4;
			mant_out = mant_in << 4;
		end else if (mant_in[23:20] == 4'b0001) begin
			exp_out = exp_in - 3;
			mant_out = mant_in << 3;
		end else if (mant_in[23:21] == 3'b001) begin
			exp_out = exp_in - 2;
			mant_out = mant_in << 2;
		end else if (mant_in[23:22] == 2'b01) begin
			exp_out = exp_in - 1;
			mant_out = mant_in << 1;
		end

end

//>>>>>>> Stashed changes
endmodule