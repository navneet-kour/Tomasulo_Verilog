module execute(rs_as,rs_md,rs_ld,decode_done,clk1,clk2,in_type);

input decode_done,clk1,clk2;
input[2:0]in_type;
input[2:0] rs_as,rs_md,rs_ld;
reg execute_done=0;
reg [5:0]counter_l = 0,counter_a = 0,counter_s = 0,counter_m = 0,counter_d = 0;
reg[5:0] out;
reg[5:0] dest_tag;
integer i=0,j = 0,k=0;
always@(posedge clk1)
begin
       $display ("--------------MULTIPLICATION RESERVATION STATION---------------------------");
       $display (" INSTRUCTION   BUSY   DESTINATION WAIT(S1)  WAIT(S2)  VALUE(S1) VALUE(S2)");
       $display ("   0x%0h     0x%0d     0x%0d        0x%0d       0x%0d       0x%0d       0x%0d    ",tomosulo.rs_div_mul[0][0],tomosulo.rs_div_mul[0][1],tomosulo.rs_div_mul[0][2],tomosulo.rs_div_mul[0][3],tomosulo.rs_div_mul[0][4],tomosulo.rs_div_mul[0][5],tomosulo.rs_div_mul[0][6]);
       $display ("   0x%0d    0x%0h     0x%0d        0x%0d       0x%0d       0x%0d       0x%0d    ",tomosulo.rs_div_mul[1][0],tomosulo.rs_div_mul[1][1],tomosulo.rs_div_mul[1][2],tomosulo.rs_div_mul[1][3],tomosulo.rs_div_mul[1][4],tomosulo.rs_div_mul[1][5],tomosulo.rs_div_mul[1][6]);
       $display ("--------------ADDITION RESERVATION STATION---------------------------");
       $display ("  INSTRUCTION    BUSY  DESTINATION WAIT(S1)  WAIT(S2)  VALUE(S1) VALUE(S2)");
   $display ("    0x%0h     0x%0d     0x%0d        0x%0d       0x%0d       0x%0d       0x%0d  ",tomosulo.rs_add_sub[0][0],tomosulo.rs_add_sub[0][1],tomosulo.rs_add_sub[0][2],tomosulo.rs_add_sub[0][3],tomosulo.rs_add_sub[0][4],tomosulo.rs_add_sub[0][5],tomosulo.rs_add_sub[0][6]);
       $display ("      0x%0h     0x%0d     0x%0d        0x%0d       0x%0d       0x%0d       0x%0d ",tomosulo.rs_add_sub[1][0],tomosulo.rs_add_sub[1][1],tomosulo.rs_add_sub[1][2],tomosulo.rs_add_sub[1][3],tomosulo.rs_add_sub[1][4],tomosulo.rs_add_sub[1][5],tomosulo.rs_add_sub[1][6]);
       $display ("    0x%0h     0x%0d     0x%0d         0x%0d       0x%0d       0x%0d       0x%0d  ",tomosulo.rs_add_sub[2][0],tomosulo.rs_add_sub[2][1],tomosulo.rs_add_sub[2][2],tomosulo.rs_add_sub[2][3],tomosulo.rs_add_sub[2][4],tomosulo.rs_add_sub[2][5],tomosulo.rs_add_sub[2][6]);
    
    if(decode_done == 1)
    begin
        $display("k=%d,j=%d",k,j);
        $display("Execute");
        if (in_type == 3'b001   ) begin
             if (tomosulo.arf_rat[tomosulo.rs1][3]== 6'b000000)
             begin
                if(tomosulo.lsb[rs_ld-1][1] == 1)begin        
                    $display("load execution begins");    
                    out =   tomosulo.memory[tomosulo.lsb[rs_ld-1][3]];
                    dest_tag =  tomosulo.lsb[rs_ld-1][2];
                    tomosulo.cycle =  tomosulo.cycle + 5;
                    execute_done =   1;         
                    tomosulo.lsb[rs_ld-1][1] = 0;
                end  
             end
        end 
        else 
        begin
            if(k>2)
                k=0;
            if(j>1)
                j=0;
            if(tomosulo.rs_add_sub[k][3] == 0 && tomosulo.rs_add_sub[k][4] == 0 && in_type == 2)begin
                $display("here in add");
                    $display("add execution begins");   
                    $display("rs1 = %d, rs2 = %d,k = %d",tomosulo.rs_add_sub[k][5],tomosulo.rs_add_sub[k][6],k);
                    out = tomosulo.rs_add_sub[k][5] + tomosulo.rs_add_sub[k][6];
                    $display("Out = %d",out);                        
                    dest_tag =  tomosulo.rs_add_sub[k][2];
                    tomosulo.cycle =   tomosulo.cycle + 1;
                    execute_done = 1;
                    tomosulo.rs_add_sub[k][0] = 0;
                    tomosulo.rs_add_sub[k][1] = 0;
                    tomosulo.rs_add_sub[k][2] = 0;

                    tomosulo.rs_add_sub[k][5] = 0;

                    tomosulo.rs_add_sub[k][6] = 0;

                    k++;
            end
            else if(tomosulo.rs_add_sub[k][3] == 0 && tomosulo.rs_add_sub[k][4] == 0 && in_type == 3) begin
                    $display("sub execution begins");        
                    $display("rs1 = %d, rs2 = %d,k = %d",tomosulo.rs_add_sub[k][5],tomosulo.rs_add_sub[k][6],k);
                    out =  tomosulo.rs_add_sub[k][5] - tomosulo.rs_add_sub[k][6];
                    $display("Out = %d",out);                        
                    dest_tag =  tomosulo.rs_add_sub[k][2];
                    tomosulo.cycle =  tomosulo.cycle + 1;
                    execute_done =  1; 
                    tomosulo.rs_add_sub[k][0] = 0;
                    tomosulo.rs_add_sub[k][1] = 0;
                    tomosulo.rs_add_sub[k][2] = 0;
                     tomosulo.rs_add_sub[k][5] = 0;

                    tomosulo.rs_add_sub[k][6] = 0;

                    k++;
            end
            if(tomosulo.rs_div_mul[j][3] == 0 && tomosulo.rs_div_mul[j][4] == 0 && in_type == 4)begin
                $display("here in mul");
                    $display("mul execution begins");    
                    out =  tomosulo.rs_div_mul[j][5] * tomosulo.rs_div_mul[j][6];
                    $display("out1 = %d,out2 = %d, j = %d",tomosulo.rs_div_mul[j][5],tomosulo.rs_div_mul[j][6],j);     
                    $display("Out = %d",out);
                    dest_tag =  tomosulo.rs_div_mul[j][2];
                    tomosulo.cycle =  tomosulo.cycle + 10;                            
                    execute_done =  1;
                    tomosulo.rs_div_mul[j][0] = 0;
                    tomosulo.rs_div_mul[j][1] = 0;
                    tomosulo.rs_div_mul[j][2] = 0;
                    tomosulo.rs_div_mul[j][5] = 0;
                    tomosulo.rs_div_mul[j][6] = 0;
                    j++;                    
            end
            else if(tomosulo.rs_div_mul[j][3] == 0 && tomosulo.rs_div_mul[j][4] == 0 && in_type == 5) begin
                    $display("div execution begins");   
                    $display("out1 = %d,out2 = %d, j = %d",tomosulo.rs_div_mul[j][5],tomosulo.rs_div_mul[j][6],j);     
                    out =  tomosulo.rs_div_mul[j][5] / tomosulo.rs_div_mul[j][6];
                    $display("Out = %d",out);
                    tomosulo.cycle =  tomosulo.cycle + 40;
                    execute_done =  1;
                    dest_tag =  tomosulo.rs_div_mul[j][2];
                    tomosulo.rs_div_mul[j][0] = 0;
                    tomosulo.rs_div_mul[j][1] = 0;
                    tomosulo.rs_div_mul[j][2] = 0;
                    tomosulo.rs_div_mul[j][5] = 0;
                    tomosulo.rs_div_mul[j][6] = 0;
                    j++;   
                end          
        end            

    end    
end
always @(posedge execute_done) begin
    $display("exec_done");
    case (dest_tag)
            6'b000001:begin
                if(i > 2)
                    i = 0;
                if(j > 1)  
                    j = 0;
                tomosulo.ROB[1][3] = out;
                    if(tomosulo.rs_add_sub[i][3] == 1)begin
                        tomosulo.rs_add_sub[i][5] = out;
                        i++;
                    end
                    if(tomosulo.rs_add_sub[i][4] == 1)begin
                        tomosulo.rs_add_sub[i][6] = out;
                        i++;
                    end       
                    if(tomosulo.rs_div_mul[j][3] == 1)begin
                        tomosulo.rs_div_mul[j][5] = out;
                        j++;
                    end
                    if(tomosulo.rs_div_mul[j][4] == 1)begin
                        tomosulo.rs_div_mul[j][6] = out;
                        j++;
                    end                             
            end   
            6'b000010:begin
                if(i > 2)
                    i = 0;
                if(j > 1)  
                    j = 0; 
                tomosulo.ROB[2][3] = out;
                    if(tomosulo.rs_add_sub[i][3] == 2)begin
                        tomosulo.rs_add_sub[i][5] = out;
                    end
                    if(tomosulo.rs_add_sub[i][4] == 2)begin
                        tomosulo.rs_add_sub[i][6] = out;
                    end                    
                for(i= 0; i < 2; i++)begin
                    if(tomosulo.rs_div_mul[i][3] == 2)begin
                        tomosulo.rs_div_mul[i][5] = out;
                    end
                    if(tomosulo.rs_div_mul[i][4] == 2)begin
                        tomosulo.rs_div_mul[i][6] = out;
                    end                    
                end                 
            end 
            6'b000011:begin
                if(i > 2)
                    i = 0;
                if(j > 1)  
                    j = 0; 
                tomosulo.ROB[3][3] = out;
                    if(tomosulo.rs_add_sub[i][3] == 3)begin
                        tomosulo.rs_add_sub[i][5] = out;
                    end
                    if(tomosulo.rs_add_sub[i][4] == 3)begin
                        tomosulo.rs_add_sub[i][6] = out;
                    end                    
                    if(tomosulo.rs_div_mul[i][3] == 3)begin
                        tomosulo.rs_div_mul[i][5] = out;
                    end
                    if(tomosulo.rs_div_mul[i][4] == 3)begin
                        tomosulo.rs_div_mul[i][6] = out;
                    end                    
            end                 
            6'b000100:begin 
                if(i > 2)
                    i = 0;
                if(j > 1)  
                    j = 0;
                tomosulo.ROB[4][3] = out;
                    if(tomosulo.rs_add_sub[i][3] == 4)begin
                        tomosulo.rs_add_sub[i][5] = out;
                    end
                    if(tomosulo.rs_add_sub[i][4] == 4)begin
                        tomosulo.rs_add_sub[i][6] = out;
                    end                    
                    if(tomosulo.rs_div_mul[i][3] == 4)begin
                        tomosulo.rs_div_mul[i][5] = out;
                    end
                    if(tomosulo.rs_div_mul[i][4] == 4)begin
                        tomosulo.rs_div_mul[i][6] = out;
                    end                    
            end 
            6'b000101:begin 
                if(i > 2)
                    i = 0;
                if(j > 1)  
                    j = 0;
                tomosulo.ROB[5][3] = out;
                    if(tomosulo.rs_add_sub[i][3] == 5)begin
                        tomosulo.rs_add_sub[i][5] = out;
                    end
                    if(tomosulo.rs_add_sub[i][4] == 5)begin
                        tomosulo.rs_add_sub[i][6] = out;
                    end                    
                    if(tomosulo.rs_div_mul[i][3] == 5)begin
                        tomosulo.rs_div_mul[i][5] = out;
                    end
                    if(tomosulo.rs_div_mul[i][4] == 5)begin
                        tomosulo.rs_div_mul[i][6] = out;
                    end                    
            end 
            6'b000110:begin 
                if(i > 2)
                    i = 0;
                if(j > 1)  
                    j = 0;
                tomosulo.ROB[6][3] = out;
                    if(tomosulo.rs_add_sub[i][3] == 6)begin
                        tomosulo.rs_add_sub[i][5] = out;
                    end
                    if(tomosulo.rs_add_sub[i][4] == 6)begin
                        tomosulo.rs_add_sub[i][6] = out;
                    end                    
                    if(tomosulo.rs_div_mul[i][3] == 6)begin
                        tomosulo.rs_div_mul[i][5] = out;
                    end
                    if(tomosulo.rs_div_mul[i][4] == 6)begin
                        tomosulo.rs_div_mul[i][6] = out;
                    end                    
            end                 
            6'b000111:begin 
                if(i > 2)
                    i = 0;
                if(j > 1)  
                    j = 0;
                tomosulo.ROB[7][3] = out;
                    if(tomosulo.rs_add_sub[i][3] == 7)begin
                        tomosulo.rs_add_sub[i][5] = out;
                    end
                    if(tomosulo.rs_add_sub[i][4] == 7)begin
                        tomosulo.rs_add_sub[i][6] = out;
                    end                    
                    if(tomosulo.rs_div_mul[i][3] == 7)begin
                        tomosulo.rs_div_mul[i][5] = out;
                    end
                    if(tomosulo.rs_div_mul[i][4] == 7)begin
                        tomosulo.rs_div_mul[i][6] = out;
                    end                    
            end                 
            6'b001000:begin 
                if(i > 2)
                    i = 0;
                if(j > 1)  
                    j = 0;
                tomosulo.ROB[8][3] = out;
                    if(tomosulo.rs_add_sub[i][3] == 8)begin
                        tomosulo.rs_add_sub[i][5] = out;
                    end
                    if(tomosulo.rs_add_sub[i][4] == 8)begin
                        tomosulo.rs_add_sub[i][6] = out;
                    end                    
                    if(tomosulo.rs_div_mul[i][3] == 8)begin
                        tomosulo.rs_div_mul[i][5] = out;
                    end
                    if(tomosulo.rs_div_mul[i][4] == 8)begin
                        tomosulo.rs_div_mul[i][6] = out;
                    end                    
            end                 
    endcase

end
commit com(out,clk1,clk2,in_type,execute_done,dest_tag);
endmodule

