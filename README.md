# MIPS-MultiCycle
This is an implementation of Multi-cycled MIPS.

You can change op / zero / funct in example.txt file upon on your option.
LW : 100011_0_000000
SW : 101011_0_000000
R-Type (add) : 000000_0_100000
BEQ : 000100_1_00000
J : 000010_0_000000

-----

BEQ , J -> 3 Cycles
R-Type,SW,ADDI -> 4 Cycles
LW -> 5 Cycles

