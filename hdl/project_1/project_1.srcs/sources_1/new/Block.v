`timescale 1ns / 1ps

module clock24(clk, time_in, time_out, reset,Alarm,ring);
  input clk, reset; 
  input [16:0] time_in,Alarm; 
  output [16:0] time_out; 
  output ring;
  wire [5:0] sec_in, min_in;
  wire [4:0] hour_in;
  reg [5:0] sec_reg, min_reg;
  reg [4:0] hour_reg;
  reg ring; 
  assign {hour_in, min_in, sec_in} = time_in;
  always@(posedge clk or posedge reset)
    begin
      if(reset)
        begin
          sec_reg <= sec_in;
        end
      else
        begin
          sec_reg <= (sec_reg == 6'd59) ? 6'd0 : (sec_reg + 6'd1);
        end
    end

  always@(posedge clk or posedge reset)
    begin
      if(reset)
        begin
          min_reg <= min_in;
        end
      else
        begin
          if(sec_reg == 6'd59)
            begin
              min_reg <= (min_reg == 6'd59) ? 6'd0 : (min_reg + 6'd1);
            end
        end
    end

  //handle hours
  always@(posedge clk or posedge reset)
    begin
      if(reset)
        begin
          hour_reg <= hour_in;
        end
      else
        begin
          if((sec_reg == 6'd59)&(min_reg == 6'd59))
            begin
              hour_reg <= (hour_reg == 5'd23) ? 5'd0 : (hour_reg + 5'd1);
            end
        end
    end

 assign time_out = {hour_reg, min_reg, sec_reg};

//Alarm    
    always@(*)
     begin
        if(Alarm==time_out)
        begin
        ring =1'd1;
        #50 ring  = 1'd0;
      end
    end

endmodule