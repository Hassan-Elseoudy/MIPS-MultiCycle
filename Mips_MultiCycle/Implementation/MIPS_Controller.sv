module controller(input logic clk, reset,
                  input logic [5:0] op, funct,
                  input logic zero,
                  output logic pcen, memwrite, irwrite, regwrite,
                  output logic alusrca, iord, memtoreg, regdst,
                  output logic [1:0] alusrcb, pcsrc,
                  output logic [2:0] alucontrol); //Controller module 
 logic [1:0] aluop;     // ALU Operation
 logic       branch, pcwrite;
 // Main Decoder and ALU Decoder subunits.
 maindec md(clk, reset, op, pcwrite, memwrite, irwrite, regwrite, alusrca, branch, iord, memtoreg, regdst, alusrcb, pcsrc, aluop);
 aludec ad(funct, aluop, alucontrol);
 assign pcen = pcwrite | (branch & zero);
endmodule
