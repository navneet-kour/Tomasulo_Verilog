module decode(input [31:0]temp,input clk1,input clk2);
integer inst_count=1;
reg [9:0]conc;
reg [5:0]l; 
reg done = 0;
reg[2:0] rs_as=0,rs_md=0,rs_ld=0;
reg decode_done = 0;
reg[2:0]in_type; 
always @(posedge clk2)
begin  
$display("------------------------ROB------------------------------------------------------");
       $display("ROB NO.       INSTRUCTION             DESTINATION         VALUE  ");
       $display("0x%0d           0x%0h                     0x%0d               0x%0d",tomosulo.ROB[1][0],tomosulo.ROB[1][1],tomosulo.ROB[1][2],tomosulo.ROB[1][3]);
       $display("0x%0d           0x%0h                   0x%0d               0x%0d",  tomosulo.ROB[2][0],tomosulo.ROB[2][1],tomosulo.ROB[2][2],tomosulo.ROB[2][3]);
       $display("0x%0d           0x%0h                   0x%0d               0x%0d",  tomosulo.ROB[3][0],tomosulo.ROB[3][1],tomosulo.ROB[3][2],tomosulo.ROB[3][3]);
       $display("0x%0d           0x%0h                    0x%0d               0x%0d", tomosulo.ROB[4][0],tomosulo.ROB[4][1],tomosulo.ROB[4][2],tomosulo.ROB[4][3]);
       $display("0x%0d           0x%0h                   0x%0d               0x%0d",  tomosulo.ROB[5][0],tomosulo.ROB[5][1],tomosulo.ROB[5][2],tomosulo.ROB[5][3]);
       $display("0x%0d           0x%0h                 0x%0d               0x%0d",   tomosulo.ROB[6][0],tomosulo.ROB[6][1],tomosulo.ROB[6][2],tomosulo.ROB[6][3]);
       $display("0x%0d           0x%0h                    0x%0d               0x%0d", tomosulo.ROB[7][0],tomosulo.ROB[7][1],tomosulo.ROB[7][2],tomosulo.ROB[7][3]);
       $display("0x%0d           0x%0h                   0x%0d               0x%0d\n",tomosulo.ROB[8][0],tomosulo.ROB[8][1],tomosulo.ROB[8][2],tomosulo.ROB[8][3]);
       
    $display("Inside Decode Stage");
    tomosulo.func3 = temp[14:12] ;
    $display("func3 = %b",tomosulo.func3);
    if(tomosulo.func3==3'b010)
    begin
      $display("Load decode");
      tomosulo.imm=temp[31:20];
      tomosulo.rs1=temp[19:15];
      tomosulo.rd=temp[11:7];
      tomosulo.opcode=temp[6:0];
      tomosulo.inst_type=3'b001;//LOAD
      in_type = 3'b001;
    end
    else
    begin
      $display("Add-sub-mul-div decode");
      tomosulo.rs1=temp[19:15];
      tomosulo.rd=temp[11:7];
      tomosulo.opcode=temp[6:0];
      tomosulo.func7=temp[31:25];
      tomosulo.rs2=temp[24:20];
      conc={temp[31:25],temp[14:12]};
      case (conc)
      10'b0000000000  : in_type = 3'b010;//ADD
      10'b0100000000  : in_type = 3'b011;//SUB
      10'b0000001000  : in_type = 3'b100;//MUL
      10'b0000001100  : in_type = 3'b101;//DIV
      endcase
    end
    done = 1;
end
always @(posedge done)
begin
tomosulo.ROB[inst_count][1] = in_type;
tomosulo.ROB[inst_count][2] = tomosulo.rd;
tomosulo.arf_rat[tomosulo.rd][2] = tomosulo.ROB[inst_count][0];
tomosulo.arf_rat[tomosulo.rd][3] = 6'b000001;
 
case (in_type)
  3'b001 : 
   begin
     if(rs_ld<3)
     begin
        $display("Load");
        if (tomosulo.arf_rat[tomosulo.rs1][3]== 6'b000001) begin
         l=tomosulo.arf_rat[tomosulo.rs1][2];
         
      end 
      else begin
         l = tomosulo.arf_rat[tomosulo.rs1][1];
       
       end
    tomosulo.lsb[rs_ld][0] = in_type;
    tomosulo.lsb[rs_ld][1] = 6'b000001;
    tomosulo.lsb[rs_ld][2] = tomosulo.ROB[inst_count][0];
    tomosulo.lsb[rs_ld][3] = tomosulo.imm + l;
    tomosulo.lsb[rs_ld][4] = tomosulo.rs1;
    rs_ld=rs_ld+1;
     end
  end
  3'b010 : begin
    if(rs_as<3)
    begin
    tomosulo.rs_add_sub[rs_as][0] = in_type;
    $display("rs_as = %d,tomosulo.rs_add_sub[rs_as][0] = %d",rs_as,tomosulo.rs_add_sub[rs_as][0]);
    tomosulo.rs_add_sub[rs_as][1] = 6'b000001;
    tomosulo.rs_add_sub[rs_as][2] = tomosulo.ROB[inst_count][0];//destination_tag
    $display("dest_tag=%d",tomosulo.rs_add_sub[rs_as][2]);
    $display("Add");      
      if (tomosulo.arf_rat[tomosulo.rs1][3]== 6'b000001) begin
         tomosulo.rs_add_sub[rs_as][3]=tomosulo.arf_rat[tomosulo.rs1][2];
         
      end 
      else begin
         tomosulo.rs_add_sub[rs_as][5]= tomosulo.arf_rat[tomosulo.rs1][1];
          
       end
                
       
      if (tomosulo.arf_rat[tomosulo.rs2][3]== 6'b000001) begin
         tomosulo.rs_add_sub[rs_as][4]=tomosulo.arf_rat[tomosulo.rs2][2];
             
       end 
       else begin
         tomosulo.rs_add_sub[rs_as][6]= tomosulo.arf_rat[tomosulo.rs2][1];
          
       end       
       
      rs_as=rs_as+1; 
    end
  else 
    rs_as = 0;        
  end
  3'b011: begin
    if(rs_as < 3)
    begin
    tomosulo.rs_add_sub[rs_as][0] = in_type;
    $display("rs_as = %d,tomosulo.rs_add_sub[rs_as][0] = %d",rs_as,tomosulo.rs_add_sub[rs_as][0]);    
    tomosulo.rs_add_sub[rs_as][1] = 6'b000001;
    tomosulo.rs_add_sub[rs_as][2] = tomosulo.ROB[inst_count][0];//destination_tag
      $display("dest_tag=%d",tomosulo.rs_add_sub[rs_as][2]);
    $display("Sub");      
      if (tomosulo.arf_rat[tomosulo.rs1][3]== 6'b000001) begin
         tomosulo.rs_add_sub[rs_as][3]=tomosulo.arf_rat[tomosulo.rs1][2];
         
      end 
      else begin
         tomosulo.rs_add_sub[rs_as][5]= tomosulo.arf_rat[tomosulo.rs1][1];  
          
       end
                
       
      if (tomosulo.arf_rat[tomosulo.rs2][3]== 6'b000001) begin
         tomosulo.rs_add_sub[rs_as][4]=tomosulo.arf_rat[tomosulo.rs2][2];
             
       end 
       else begin
         tomosulo.rs_add_sub[rs_as][6]= tomosulo.arf_rat[tomosulo.rs2][1];
          
       end
                       
       rs_as=rs_as+1;  
    end
    else 
      rs_as = 0;         
    end
     3'b100: begin //MUL
     if(rs_md < 2)
     begin
    tomosulo.rs_div_mul[rs_md][0] = in_type;
      $display("rs_md = %d,tomosulo.rs_div_mul[rs_md][0] = %d",rs_md,tomosulo.rs_div_mul[rs_md][0]);    
    tomosulo.rs_div_mul[rs_md][1] = 6'b000001;
    tomosulo.rs_div_mul[rs_md][2] = tomosulo.ROB[inst_count][0];//destination_tag
      $display("dest_tag=%d",tomosulo.rs_div_mul[rs_md][2]);
    $display("MUL");
      if (tomosulo.arf_rat[tomosulo.rs1][3]== 6'b000001) begin
         tomosulo.rs_div_mul[rs_md][3]=tomosulo.arf_rat[tomosulo.rs1][2];
         
      end 
      else begin
         tomosulo.rs_div_mul[rs_md][5]= tomosulo.arf_rat[tomosulo.rs1][1];
          
       end
                
       
      if (tomosulo.arf_rat[tomosulo.rs2][3]== 6'b000001) begin
         tomosulo.rs_div_mul[rs_md][4]=tomosulo.arf_rat[tomosulo.rs2][2];
             
       end 
       else begin
         tomosulo.rs_div_mul[rs_md][6]= tomosulo.arf_rat[tomosulo.rs2][1];
          
       end
                  
       
      rs_md=rs_md+1; 
     end 
      else 
        rs_md = 0;         
     end

     3'b101: begin//DIV
     if(rs_md < 2)
     begin
      tomosulo.rs_div_mul[rs_md][0] = in_type;
      $display("rs_md = %d,tomosulo.rs_div_mul[rs_md][0] = %d",rs_md,tomosulo.rs_div_mul[rs_md][0]);    
      tomosulo.rs_div_mul[rs_md][1] = 6'b000001;
      tomosulo.rs_div_mul[rs_md][2] = tomosulo.ROB[inst_count][0];//destination_tag
      $display("dest_tag=%d",tomosulo.rs_div_mul[rs_md][2]);
      $display("DIV");
         if (tomosulo.arf_rat[tomosulo.rs1][3]== 6'b000001) begin
           tomosulo.rs_div_mul[rs_md][3]=tomosulo.arf_rat[tomosulo.rs1][2];
            $display("tomosulo.rs_div_mul[rs_md][3] = %d",tomosulo.rs_div_mul[rs_md][3]);
         
      end 
      else begin
         tomosulo.rs_div_mul[rs_md][5]= tomosulo.arf_rat[tomosulo.rs1][1];
         $display("tomosulo.rs_div_mul[rs_md][5] = %d",tomosulo.rs_div_mul[rs_md][5]);
          
       end
                
       
      if (tomosulo.arf_rat[tomosulo.rs2][3]== 6'b000001) begin
         tomosulo.rs_div_mul[rs_md][4]=tomosulo.arf_rat[tomosulo.rs2][2];
             
       end 
       else begin
         tomosulo.rs_div_mul[rs_md][6]= tomosulo.arf_rat[tomosulo.rs2][1];
          
       end
                        
       
      rs_md=rs_md+1;
     end
      else 
        rs_md = 0;           
     end

endcase
done=0;
decode_done = 1;
// tomosulo.cycle = tomosulo.cycle+1;//Issue  to RS
inst_count++;
end
execute e1(rs_as,rs_md,rs_ld,decode_done,clk1,clk2,in_type);
endmodule


