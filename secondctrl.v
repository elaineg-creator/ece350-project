module secondctrl(reset, clock, status, on, pc_reset);
    input reset, clock, pc_reset, on;
    output status;

    reg[9:0] count = 0;
    reg status = 0;

    always @(posedge clock) begin    
        if(on) begin
            if(pc_reset) begin
                status <= 0;
                count <= 0;
            end else if(reset) begin  //if reset is triggered, set status to on (1) and reset count
                status <= 1;
                count <= 0;
            end else begin
                if(count < 999 && status) begin
                    count <= count + 1;
                end else if(count == 999) begin             //if one second passed i.e. 1000 ms, set status to off (0)
                    status <= 0;
                end
            end
        end       
        
    end

endmodule


