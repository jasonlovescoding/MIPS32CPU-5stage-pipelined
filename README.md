# MIPS32CPU-5stage-pipelined
A 5-stage pipelined mips32 processor   

·Finished as a final project for the course "Computer Architecture" in Beihang University.  

·FGPA configuration  

Family: Spartan6   

Device: XC6SLX100  

Package: FGG676  

Speed: -2  

·Instructions supported:  

LB、LBU、LH、LHU、LW、SB、SH、SW、ADD、ADDU、SUB、SUBU、SLL、SRL、SRA、SLLV、SRLV、SRAV、 AND、OR、XOR、NOR、ADDI、ADDIU、ANDI、ORI、XORI、LUI、SLT、SLTI、 SLTIU、SLTU、BEQ、BNE、BLEZ、BGTZ、BLTZ、BGEZ、J、JAL、JALR、JR、ERET、MFC0、MTC0  

·Interruption supported (Timer and MiniUART can send interruption requests)  

·Serial Communication through MiniUART module (RS-232 prototype)  

·Forwarding as long as it's possible. Stalling when needed.

![design](https://cloud.githubusercontent.com/assets/12913794/25858732/07658d10-350f-11e7-861a-8f5a4fda534c.JPG)

![configs](https://cloud.githubusercontent.com/assets/12913794/25858734/079502fc-350f-11e7-92b2-83abadf45572.PNG)

![address mapping](https://cloud.githubusercontent.com/assets/12913794/25858735/07b61b72-350f-11e7-8199-417546c46f12.PNG)

![architecture](https://cloud.githubusercontent.com/assets/12913794/25858851/5fcc9f7a-350f-11e7-9d90-30313cfa4d97.JPG)
