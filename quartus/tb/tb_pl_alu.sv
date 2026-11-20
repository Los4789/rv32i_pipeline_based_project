`timescale 1ns/1ps

// Teste unitario das dez operacoes implementadas em pl_alu.
module tb_pl_alu;
    logic [31:0] SrcA, SrcB;
    logic [3:0] Operation;
    logic [31:0] ALUResult;
    logic Zero;
    integer errors = 0;

    pl_alu dut (
        .SrcA(SrcA), .SrcB(SrcB), .Operation(Operation),
        .ALUResult(ALUResult), .Zero(Zero)
    );

    task automatic check_result(
        input logic [3:0] op,
        input logic [31:0] a,
        input logic [31:0] b,
        input logic [31:0] expected,
        input string label
    );
        begin
            Operation = op;
            SrcA = a;
            SrcB = b;
            #1;
            if (ALUResult !== expected) begin
                $display("FALHA %s: esperado=%08h obtido=%08h", label, expected, ALUResult);
                errors = errors + 1;
            end else begin
                $display("OK    %s = %08h", label, ALUResult);
            end
        end
    endtask

    initial begin
        SrcA = 0; SrcB = 0; Operation = 0;
        check_result(4'd1, 32'd7, 32'd5, 32'd12, "ADD");
        check_result(4'd2, 32'd7, 32'd5, 32'd2, "SUB");
        check_result(4'd4, 32'hA0, 32'h0F, 32'hAF, "OR");
        check_result(4'd5, 32'hAF, 32'h0F, 32'h0F, "AND");
        check_result(4'd6, 32'hAA, 32'h0F, 32'hA5, "XOR");
        check_result(4'd11, 32'hFFFFFFF0, 32'd0, 32'd1, "SLT signed");
        check_result(4'd7, 32'd3, 32'd4, 32'd48, "SLL");
        check_result(4'd3, 32'h80000000, 32'd1, 32'h40000000, "SRL");
        check_result(4'd8, 32'hFFFFFFF0, 32'd2, 32'hFFFFFFFC, "SRA");
        check_result(4'd9, 32'd10, 32'hFFFFFFF0, 32'd1, "SLTU");

        if (errors == 0) begin
            $display("PASSOU: todas as operacoes da ALU conferem.");
            $finish;
        end else begin
            $fatal(1, "Falharam %0d teste(s) da ALU.", errors);
        end
    end
endmodule
