// =============================================================================
// pl_hazard.sv
// Unidade de Deteccao de Hazard -- RV32I pipelined
//
// Detecta hazard load-use: instrucao LW seguida imediatamente por instrucao
// que le o registrador destino do LW.
//
// Acao ao detectar stall:
//   - PC mantido (nao avanca)
//   - IF/ID mantido (instrucao dependente fica em ID mais um ciclo)
//   - ID/EX zerado (NOP/bolha injetada no pipeline)
// =============================================================================

`timescale 1ns / 1ps

module pl_hazard (
    input  logic [4:0] if_id_rs1,       // rs1 da instrucao em ID
    input  logic [4:0] if_id_rs2,       // rs2 da instrucao em ID
    input  logic [6:0] if_id_opcode,    // TODO (hazard): identifica se a instrucao realmente consome rs1/rs2.
    input  logic [4:0] id_ex_rd,        // rd da instrucao em EX
    input  logic       id_ex_mem_read,  // instrucao em EX e LW?
    output logic       stall            // 1 = inserir bolha
);

    logic uses_rs1, uses_rs2;

    always_comb begin
        uses_rs1 = 1'b0;
        uses_rs2 = 1'b0;
        case (if_id_opcode)
            7'b0110011: begin uses_rs1 = 1'b1; uses_rs2 = 1'b1; end // R-type
            7'b0010011: begin uses_rs1 = 1'b1; end                 // I-type ALU
            7'b0000011: begin uses_rs1 = 1'b1; end                 // loads
            7'b0100011: begin uses_rs1 = 1'b1; uses_rs2 = 1'b1; end // stores
            7'b1100011: begin uses_rs1 = 1'b1; uses_rs2 = 1'b1; end // branches
            7'b1100111: begin uses_rs1 = 1'b1; end // TODO (Etapa 03): JALR depende de rs1.
            default: ;
        endcase
    end

    // TODO (hazard): evita stalls falsos quando bits do imediato coincidem com rd.
    assign stall = id_ex_mem_read && (id_ex_rd != 5'b0) &&
                   ((uses_rs1 && (id_ex_rd == if_id_rs1)) ||
                    (uses_rs2 && (id_ex_rd == if_id_rs2)));

endmodule
