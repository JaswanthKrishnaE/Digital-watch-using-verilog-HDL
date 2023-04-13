`timescale 1ns / 1ps

module stimulus();
    reg clk, reset;
    reg [16:0] time_in,Alarm;
    wire [16:0] time_out; // 5+6+6 = 17
    wire [5:0] sec, min; // 59 = 111011
    wire [4:0] hour; // 24 = 11000
    wire ring;

    
    clock24 c(clk, time_in, time_out, reset,Alarm,ring);
    assign {hour, min, sec} = time_out;

    always #5  clk = ~clk;

    initial
        begin
            clk = 0;
            reset = 0;
            time_in = 17'b10111_110000_000000; //23:48:00
            Alarm = 17'b10111_110001_000000;
            #12
            reset = 1;
            #10
            reset = 0;
            #10000000
            $finish;
        end

    initial //to get simulation outputs
      begin  
        $dumpfile("output_waveform.vcd"); 
        $dumpvars(1, hour);
        $dumpvars(2, min);
        $dumpvars(3, sec);
        $dumpvars(4, ring); 
      end

endmodule