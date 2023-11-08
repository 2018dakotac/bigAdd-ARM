# bigAdd-AR 
Name        : bigAdd.s  
Written by Dakota Crozier 2021  
Subroutine to add large numbers stored in memory written in ARM assembly  
Resources: https://developer.arm.com/documentation/dui0204/j/arm-and-thumb-instructions/instruction-summary  
Subroutine follows C calling convention result will be stored in r0  
Address of the large numbers should be stored in r0,r1 and length of largest in number in words in r3  
Functon interface: int bigAdd(bigNumN bigN0P, const bigNumN bigN1P, unsigned int maxN0Size);  
