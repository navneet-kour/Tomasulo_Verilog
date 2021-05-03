module commit(out,clk1,clk2,in_type,execute_done,dest_tag);
input clk1,clk2, execute_done;
input [2:0] in_type;
input [5:0] out,dest_tag;
reg[3:0] hpointer = 1,tpointer;
integer i;
always@(posedge clk2)
begin
    $display("-----------------------------------------------------CYCLE TABLE--------------------------------------------------------------");
    $display("clock cycles");
    $display("0x%0d",tomosulo.cycle);
    $display("-----------------------------------------------------");
    if(execute_done == 1)begin
        $display("Commit");
        tpointer = dest_tag;
        if(hpointer == tpointer)begin
            for(i = 0;i < 10;i++)begin
                if(tomosulo.arf_rat[i][2] == dest_tag)begin
                    tomosulo.arf_rat[i][1] = out;
                    tomosulo.arf_rat[i][3] = 0;
                    execute.execute_done = 0;
                end
            end            
            hpointer += 1;
        end
    tomosulo.cycle += 1;
    // $display("-----RS_ADD_SUB----");
    // $display("-----RS_DIV_MUL----");
    // $display("-----RS_LSB--------");
    end
end

endmodule