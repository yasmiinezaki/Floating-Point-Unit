module mult_normalize(expsize, mantsize, in_exp, in_mant, out_exp, out_mant);

	input [31:0] expsize, mantsize;
	wire [31:0] expsize, mantsize;
	
	input [expsize-1:0] in_exp;
	output [expsize-1:0] out_exp;
	input [(2*(mantsize)+1):0] in_mant;
	output [(2*(mantsize)+1):0] out_mant;

	wire [expsize-1:0] in_exp;
	wire [(2*(mantsize)+1):0] in_mant;
	reg [expsize-1:0] out_exp;
	reg [(2*(mantsize)+1):0] out_mant;

  always @ (*) begin
  
  	   if(in_mant[(2*(mantsize)+1)] == 1) //if most significant is 1, normalization is needed
		begin
      out_exp = in_exp + 1;
      out_mant = in_mant >> 1; //shift result right
      end 
		else if((in_mant[2*(mantsize)] != 1) && (in_exp != 0)) //if most significant was zero and second most significant is also zero and exp not zero then normalize (till 1)
		begin

      end
		
	end

endmodule