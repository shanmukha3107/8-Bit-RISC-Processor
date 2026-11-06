module risc8(
    input clk,
    input reset
);

    reg [7:0] PC;
    reg [7:0] registers [0:3];
    reg [15:0] instruction_memory [0:15];

    reg [15:0] instruction;
    reg [7:0] result;
    reg [3:0] opcode;
    reg [1:0] rd, rs1, rs2;
    reg halted;

    integer i;

    initial begin
        instruction_memory[0] = 16'h5405;
        instruction_memory[1] = 16'h5803;
        instruction_memory[2] = 16'h0D80;
        instruction_memory[3] = 16'h1380;
        instruction_memory[4] = 16'hF000;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 0;
            halted <= 0;
            for (i = 0; i < 4; i = i + 1)
                registers[i] <= 0;
        end
        else if (!halted) begin
            instruction = instruction_memory[PC[3:0]];
            opcode = instruction[15:12];
            rd = instruction[11:10];
            rs1 = instruction[9:8];
            rs2 = instruction[7:6];

            case (opcode)
                4'h0: begin
                    result = registers[rs1] + registers[rs2];
                    registers[rd] <= result;
                end
                4'h1: begin
                    result = registers[rs1] - registers[rs2];
                    registers[rd] <= result;
                end
                4'h2: begin
                    result = registers[rs1] & registers[rs2];
                    registers[rd] <= result;
                end
                4'h3: begin
                    result = registers[rs1] | registers[rs2];
                    registers[rd] <= result;
                end
                4'h4: begin
                    result = registers[rs1] ^ registers[rs2];
                    registers[rd] <= result;
                end
                4'h5: begin
                    result = instruction[7:0];
                    registers[rd] <= result;
                end
                4'hF: halted <= 1;
                default: result = 0;
            endcase

            if (opcode != 4'hF)
                PC <= PC + 1;
        end
    end

endmodule
