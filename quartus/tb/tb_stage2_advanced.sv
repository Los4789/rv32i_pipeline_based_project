`timescale 1ns/1ps

// TODO (Etapa 02 - testes I-type/U-type): verifica extremos, shifts, SLT/SLTU,
// forwarding e a imutabilidade arquitetural de x0 (via leitura em x30).
module tb_stage2_advanced;
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
    logic [31:0] expected [1:31];

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
        // TODO (Etapa 02 - teste avancado): valores calculados por interpretador de referencia independente.
        expected[1] = 32'h1234507B;
        expected[2] = 32'h1234507A;
        expected[3] = 32'h0000007A;
        expected[4] = 32'hFFFFF87A;
        expected[5] = 32'h00000785;
        expected[6] = 32'h00007850;
        expected[7] = 32'h00001E14;
        expected[8] = 32'h00000F0A;
        expected[9] = 32'h00000000;
        expected[10] = 32'hABCDE000;
        expected[11] = 32'hABCDE001;
        expected[12] = 32'h000010A8;
        expected[13] = 32'h000008A8;
        expected[14] = 32'hABCDE8A9;
        expected[15] = 32'hABCDE8A2;
        expected[16] = 32'h800000B8;
        expected[17] = 32'h000000BC;
        expected[18] = 32'hFFFFF0C0;
        expected[19] = 32'h00000000;
        expected[20] = 32'h00001000;
        expected[21] = 32'h00000800;
        expected[22] = 32'h00000FFF;
        expected[23] = 32'h80000000;
        expected[24] = 32'hFFFFFFFF;
        expected[25] = 32'h00000000;
        expected[26] = 32'h00000000;
        expected[27] = 32'h000020E8;
        expected[28] = 32'h000020E8;
        expected[29] = 32'h000020E8;
        expected[30] = 32'h00000000;
        expected[31] = 32'h00000001;
































        errors = 0;

        // TODO (Etapa 02 - testes I-type/U-type): substitui a ROM de simulacao pelo programa
        // especifico desta etapa enquanto o processador permanece em reset.
        #1;
        // TODO (isolamento do teste): limpa toda a ROM com NOP antes de carregar
        // o programa avancado. Assim, instrucoes residuais de program.hex nao
        // continuam executando apos o fim do programa e nao sobrescrevem x1-x17.
        for (i = 0; i < 256; i = i + 1)
            dut.datapath.imem.rom[i] = 32'h00000013;
        $readmemh("program_stage2_advanced.hex", dut.datapath.imem.rom);

        repeat (5) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;

        // Aguarda execucao e drenagem do pipeline.
        repeat (160) @(negedge clk);

        $display("\n================================================");
        $display(" ETAPA 02 - TESTES AVANCADOS I-TYPE E U-TYPE");
        $display("================================================");
        for (i = 1; i <= 31; i = i + 1) begin
            if (dut.datapath.regfile.rf[i] !== expected[i]) begin
                $display("FALHA x%0d: esperado=%08h obtido=%08h",
                         i, expected[i], dut.datapath.regfile.rf[i]);
                errors = errors + 1;
            end else begin
                $display("OK    x%0d = %08h", i, dut.datapath.regfile.rf[i]);
            end
        end

        // TODO (Etapa 02 - x0): rf[0] pode permanecer X porque o hardware
        // bloqueia escritas em x0 e retorna zero diretamente nas portas de leitura.
        // Verifica o valor arquitetural por meio da instrucao que le x0 em x30.
        // x30 ja e conferido acima; esta checagem explicita documenta o requisito.
        if (dut.datapath.regfile.rf[30] !== 32'h00000000) begin
            $display("FALHA leitura de x0 em x30: obtido=%08h", dut.datapath.regfile.rf[30]);
            errors = errors + 1;
        end else $display("OK    leitura arquitetural de x0 (via x30) = 00000000");

        if (errors == 0) begin
            $display("\nPASSOU: 31 registradores e x0 conferem nos testes avancados da Etapa 02.");
            $finish;
        end else begin
            $display("\nFALHOU: %0d registrador(es) divergente(s).", errors);
            $fatal(1, "Falha nos testes avancados I-type/U-type.");
        end
    end

    initial begin
        #50000;
        $fatal(1, "Timeout: teste avancado Etapa 02 excedeu o tempo maximo.");
    end
endmodule
