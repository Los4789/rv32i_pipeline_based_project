// =============================================================================
// pl_alu_ctrl.sv
// Controle da ALU para instrucoes R-type e I-type RV32I.
// ALUOp: 00 = ADD (load/store/LUI/AUIPC); 01 = SUB (BEQ);
//        10 = decodificacao R-type; 11 = decodificacao I-type.
// =============================================================================

`timescale 1ns / 1ps

module pl_alu_ctrl (
    input  logic [1:0] ALUOp,
    input  logic [6:0] Funct7,
    input  logic [2:0] Funct3,
    output logic [3:0] Operation
);

    always_comb begin
        case (ALUOp)
            2'b00: Operation = 4'd1; // ADD para endereco, LUI e AUIPC.
            2'b01: Operation = 4'd2; // SUB para comparacao BEQ.

            2'b10: begin // R-type
                case (Funct3)
                    3'h0: Operation = Funct7[5] ? 4'd2 : 4'd1; // SUB / ADD
                    3'h1: Operation = 4'd7; // SLL
                    3'h2: Operation = 4'd11; // SLT
                    3'h3: Operation = 4'd9; // SLTU
                    3'h4: Operation = 4'd6; // XOR
                    3'h5: Operation = Funct7[5] ? 4'd8 : 4'd3; // SRA / SRL
                    3'h6: Operation = 4'd4; // OR
                    3'h7: Operation = 4'd5; // AND
                    default: Operation = 4'd1;
                endcase
            end

            // TODO (I-type): separa a decodificacao dos imediatos da decodificacao R-type;
            // assim o bit 30 de um imediato negativo nao transforma ADDI em SUB.
            2'b11: begin
                case (Funct3)
                    3'h0: Operation = 4'd1; // ADDI
                    3'h1: Operation = 4'd7; // SLLI
                    3'h2: Operation = 4'd11; // SLTI
                    3'h3: Operation = 4'd9; // SLTIU
                    3'h4: Operation = 4'd6; // XORI
                    3'h5: Operation = Funct7[5] ? 4'd8 : 4'd3; // SRAI / SRLI
                    3'h6: Operation = 4'd4; // ORI
                    3'h7: Operation = 4'd5; // ANDI
                    default: Operation = 4'd1;
                endcase
            end

            default: Operation = 4'd1;
        endcase
    end
endmodule
