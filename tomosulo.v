module tomosulo();
reg clk1,clk2;
reg[5:0]pc;
reg [6:0] func7,opcode;
reg [4:0] rs1,rs2,rd;
reg [2:0] func3;
reg [11:0] imm;
reg [2:0]  inst_type;
reg[5:0] ROB[1:8][0:3];
reg[5:0] arf_rat[1:10][0:3];
reg[5:0] rs_add_sub[0:2][0:6];
reg[5:0] rs_div_mul[0:1][0:6];
reg[4:0] lsb[0:2][0:4];
reg[7:0] memory[0:17];//memory
reg [31:0] instr_set [1:7];
reg [31:0] temp;
reg [8:0] cycle;
integer i;
initial
begin
    pc = 1;
    clk1 = 0;
    clk2 = 0;
    instr_set[1]=32'h00012183;
    instr_set[2]=32'h0241c133;
    instr_set[3]=32'h026280b3;
    instr_set[4]=32'h008381b3;
    instr_set[5]=32'h023080b3;
    instr_set[6]=32'h40508233;
    instr_set[7]=32'h002200b3;
    for(i = 0;i < 18; i++)
    begin
        memory[i] = i;
    end
    cycle=0;
    arf_rat[1][1] = 12;
    arf_rat[2][1] = 16;
    arf_rat[3][1] = 45;
    arf_rat[4][1] = 5;
    arf_rat[5][1] = 3;
    arf_rat[6][1] = 4;
    arf_rat[7][1] = 1;
    arf_rat[8][1] = 2;
    arf_rat[9][1] = 2;
    arf_rat[10][1] = 3;
    
    ROB[1][0]=6'b000001;
    ROB[2][0]=6'b000010;
    ROB[3][0]=6'b000011;
    ROB[4][0]=6'b000100;
    ROB[5][0]=6'b000101;
    ROB[6][0]=6'b000110;
    ROB[7][0]=6'b000111;
    ROB[8][0]=6'b001000;
    for (i = 0; i < 3 ; i++ ) 
    begin
        rs_add_sub[i][1]= 6'b000000;//busy bit
        
    end
    for (i = 0; i < 2 ; i++ ) 
    begin
        rs_div_mul[i][1]= 6'b000000;//busy bit
        
    end
    for (i = 0; i < 3 ; i++ ) 
    begin
        lsb[i][1]= 5'b00000;//busy bit
        
    end
    for (i = 0; i < 10 ; i++ ) 
    begin
        arf_rat[i][3]= 6'b000000;//busy bit
        
    end


    arf_rat[1][2] = 6'b000001;//R1
    arf_rat[2][2] = 6'b000010;//R2
    arf_rat[3][2] = 6'b000011;
    arf_rat[4][2] = 6'b000100;
    arf_rat[5][2] = 6'b000101;
    arf_rat[6][2] = 6'b000110;
    arf_rat[7][2] = 6'b000111;
    arf_rat[8][2] = 6'b001000;
    arf_rat[9][2] = 6'b001001;
    arf_rat[10][2] = 6'b001010;//R10
    for(i = 0;i < 3;i++)begin
        rs_add_sub[i][3] = 0;
        rs_add_sub[i][4] = 0;
        lsb[i][4] = 0;
    end
    for(i = 0; i < 2; i++)begin
        rs_div_mul[i][3] = 0;
        rs_div_mul[i][4] = 0;
    end
end 
always #5 clk1 = ~clk1;
always #5 clk2 = ~clk2;
always @(posedge clk1)
begin
    temp=instr_set[pc];
    cycle+=1;    
    if(pc > 10)
        $finish;
    pc = pc+1;
end
decode inst1(temp,clk1,clk2);

endmodule