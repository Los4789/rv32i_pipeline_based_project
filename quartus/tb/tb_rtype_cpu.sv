`timescale 1ns/1ps

// TODO (teste R-type): carrega um programa dedicado e verifica as dez
// operacoes R-type no banco de registradores apos a drenagem do pipeline.
// Inclui dependencias consecutivas para exercitar forwarding EX/MEM e MEM/WB.
module tb_rtype_cpu;
    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic [17:0] SW = '0;
    logic [3:0] KEY_IO = 4'b1111;
    logic [17:0] LEDR;
    logic [8:0] LEDG;
    logic UART_TXD;
    logic UART_RXD = 1'b1;
    logic [31:0] PC;
    logic wb_reg_write;
    logic [4:0] wb_reg_dst;
    logic [31:0] wb_reg_data;
    logic mem_wr_en;
    logic [7:0] mem_wr_addr;
    logic [31:0] mem_wr_data;

    integer errors;
    integer i;
    logic [31:0] expected [1:17];

    always #10 clk = ~clk;

    pl_cpu dut (
        .clk(clk), .rst_n(rst_n), .PC(PC),
        .SW(SW), .KEY_IO(KEY_IO), .LEDR(LEDR), .LEDG(LEDG),
        .UART_TXD(UART_TXD), .UART_RXD(UART_RXD),
        .wb_reg_write(wb_reg_write), .wb_reg_dst(wb_reg_dst),
        .wb_reg_data(wb_reg_data), .mem_wr_en(mem_wr_en),
        .mem_wr_addr(mem_wr_addr), .mem_wr_data(mem_wr_data)
    );

    initial begin
        expected[1]  = 32'd10;
        expected[2]  = 32'd3;
        expected[3]  = 32'hFFFFFFF0;
        expected[4]  = 32'd6;
        expected[5]  = 32'd13;          // ADD
        expected[6]  = 32'd7;           // SUB
        expected[7]  = 32'd11;          // OR
        expected[8]  = 32'd2;            // AND
        expected[9]  = 32'd1;            // SLT signed
        expected[10] = 32'd9;            // XOR
        expected[11] = 32'd80;           // SLL
        expected[12] = 32'd1;            // SRL
        expected[13] = 32'hFFFFFFFE;     // SRA
        expected[14] = 32'd0;            // SLTU: 0xFFFFFFF0 < 6 unsigned = false
        expected[15] = 32'd13;           // ADD para forwarding
        expected[16] = 32'd10;           // SUB dependente de ADD
        expected[17] = 32'd23;           // ADD dependente de SUB e ADD

        errors = 0;

        // TODO (teste R-type): substitui a ROM de simulacao pelo programa
        // especifico desta etapa enquanto o processador permanece em reset.
        #1;
        // TODO (isolamento do teste): limpa toda a ROM com NOP antes de carregar
        // o programa R-type. Assim, instrucoes residuais de program.hex nao
        // continuam executando apos o fim do programa e nao sobrescrevem x1-x17.
        for (i = 0; i < 256; i = i + 1)
            dut.datapath.imem.rom[i] = 32'h00000013;
        $readmemh("program_rtype.hex", dut.datapath.imem.rom);

        repeat (5) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;

        // Aguarda execucao e drenagem do pipeline.
        repeat (60) @(negedge clk);

        $display("\n================================================");
        $display(" TESTE INTEGRADO R-TYPE - BANCO DE REGISTRADORES");
        $display("================================================");
        for (i = 1; i <= 17; i = i + 1) begin
            if (dut.datapath.regfile.rf[i] !== expected[i]) begin
                $display("FALHA x%0d: esperado=%08h obtido=%08h",
                         i, expected[i], dut.datapath.regfile.rf[i]);
                errors = errors + 1;
            end else begin
                $display("OK    x%0d = %08h", i, dut.datapath.regfile.rf[i]);
            end
        end

        if (errors == 0) begin
            $display("\nPASSOU: todas as instrucoes e dependencias R-type conferem.");
            $finish;
        end else begin
            $display("\nFALHOU: %0d registrador(es) divergente(s).", errors);
            $fatal(1, "Falha no teste integrado R-type.");
        end
    end

    initial begin
        #50000;
        $fatal(1, "Timeout: teste R-type excedeu o tempo maximo.");
    end
endmodule
