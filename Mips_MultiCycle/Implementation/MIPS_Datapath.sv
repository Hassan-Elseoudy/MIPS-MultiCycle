module datapath(input logic clk, reset,
                input logic pcen, irwrite,
                input logic regwrite,
                input logic alusrca, iord, memtoreg, regdst,
                input logic [1:0] alusrcb, pcsrc,
                input logic [2:0] alucontrol,
                output logic [5:0] op, funct,
                output logic zero,
                output logic [31:0] adr, writedata,
                input logic [31:0] readdata);
    // Internal signals of the datapath module.
    logic [4:0] writereg;
    logic [31:0] pcnext, pc;
    logic [31:0] instr, data, srca, srcb;
    logic [31:0] a;
    logic [31:0] aluresult, aluout;
    logic [31:0] signimm; // sign-extended immediate
    logic [31:0] signimmsh; // sign-extended immediate
 
    // shifted left by 2
    logic [31:0] wd3, rd1, rd2;
 
    // op and funct fields to controller
    assign op = instr[31:26];
    assign funct = instr[5:0];
 
    // datapath
    flopenr #(32) pcreg(clk, reset, pcen, pcnext, pc);
    mux2 #(32) adrmux(pc, aluout, iord, adr);
    flopenr #(32) instrreg(clk, reset, irwrite, readdata, instr);
    flopr #(32) datareg(clk, reset, readdata, data);
    mux2 #(5) regdstmux(instr[20:16], instr[15:11], regdst, writereg);
    mux2 #(32) wdmux(aluout, data, memtoreg, wd3);
    regfile rf(clk, regwrite, instr[25:21], instr[20:16], writereg, wd3, rd1, rd2);
    signext se(instr[15:0], signimm);
    sl2 immsh(signimm, signimmsh);
    flopr #(32) areg(clk, reset, rd1, a);
    flopr #(32) breg(clk, reset, rd2, writedata);
    mux2 #(32) srcamux(pc, a, alusrca, srca);
    mux4 #(32) srcbmux(writedata, 32'b100, signimm, signimmsh, alusrcb, srcb);
    alu alu(srca, srcb, alucontrol, aluresult, zero);
    flopr #(32) alureg(clk, reset, aluresult, aluout);
    mux3 #(32) pcmux(aluresult, aluout, {pc[31:28], instr[25:0], 2'b00}, pcsrc, pcnext);

endmodule