module alu(input logic [31:0] a, b,
input logic [2:0] f,
output logic [31:0] y,
output logic zero);

always_comb
begin
case(f)
0 : y = a & b;
1 : y = a | b;
2 : y = a + b;
3 : y = 0;
4 : y = a & ~b;
5 : y = a | ~b;
6 : y = a - b;
7 : begin // SLT
				if (a[31] != b[31]) begin
					if (a[31] > b[31]) begin 
						y = 1;
					end else begin
						y = 0;
					end
				end else begin
					if (a < b)
					begin
						y = 1;
					end
					else
					begin
						y = 0;
					end
				end
			end
endcase

if ( y == 0 ) zero = 1 ;
else zero = 0 ;

end
endmodule
