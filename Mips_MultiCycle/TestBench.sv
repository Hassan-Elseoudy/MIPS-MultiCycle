module testbench3();
logic [2:0] counter = 0;
logic clk, reset;
logic [5:0] op, funct;
logic zero;
logic pcen, memwrite, irwrite, regwrite;
logic alusrca, iord, memtoreg, regdst;
logic [1:0] alusrcb, pcsrc;
logic [2:0] alucontrol;
logic [3:0] vectornum;
logic [12:0] testvectors[10000:0];
// instantiate device under test
controller dut(clk,reset,op,funct,zero,pcen,memwrite,irwrite,regwrite,alusrca,iord,memtoreg,regdst,alusrcb,pcsrc,alucontrol);
// generate clock
always
begin
clk = 1; #100; clk = 0; #100;
end
// at start of test, load vectors and pulse reset
initial
begin
$readmemb("example.txt", testvectors);
vectornum = 0;
reset = 1; #27; reset = 0;
end
// apply test vectors on rising edge of clk
always @(posedge clk)
begin
#1; {op,zero,funct} = testvectors[vectornum];
case(op)
    6'b000010 : counter = 3;  //J
    6'b000100 : counter = 3;  //BEQ
    6'b000000 : counter = 4;  //R
    6'b101011 : counter = 4;  //SW
    6'b001000 : counter = 4;  //ADDI
    6'b100011 : counter = 5;  //LW
    default: counter = 1;
endcase
end
// check results on falling edge of clk
always @(negedge clk)
if (~reset) 
begin // skip during reset
counter = counter - 1;
if(counter == 0)
begin
$stop;
end
end
endmodule