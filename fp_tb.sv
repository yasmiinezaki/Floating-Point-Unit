module fp_tb();
shortreal x = 1.5;

initial
begin

$display("sreal to bits: %b", $shortrealtobits(x));
$display("bits to sreal: %f, %g", $bitstoshortreal(32'b00111111110000000000000000000000), $bitstoshortreal(32'b00111111110000000000000000000000));
end

endmodule