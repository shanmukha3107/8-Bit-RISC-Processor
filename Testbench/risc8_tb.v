`timescale 1ns/1ps

module risc8_tb;

    reg clk;
    reg reset;

    risc8 uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("Simulation/risc8.vcd");
        $dumpvars(0, risc8_tb);

        clk = 0;
        reset = 1;

        $display("8-Bit RISC Processor Test Started");

        #12;
        reset = 0;

        repeat (7) @(posedge clk);
        #1;

        $display("R0 = %0d", uut.registers[0]);
        $display("R1 = %0d", uut.registers[1]);
        $display("R2 = %0d", uut.registers[2]);
        $display("R3 = %0d", uut.registers[3]);

        $display("Program Counter = %0d", uut.PC);
        $display("Halted = %b", uut.halted);

        if (uut.registers[0] == 5 &&
            uut.registers[1] == 5 &&
            uut.registers[2] == 3 &&
            uut.registers[3] == 8 &&
            uut.halted == 1)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $display("RISC Processor Test Completed");

        $finish;
    end

endmodule
