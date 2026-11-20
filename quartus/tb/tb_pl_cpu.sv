`timescale 1ns/1ps

// Teste de integracao do subconjunto atualmente exercitado pelo hello.asm.
// TODO (testbench): verifica resultados observaveis na memoria de dados para
// ADDI, ANDI, ORI, SLTI, SLLI, SRLI, SRAI, XOR, SLL, SRL, SRA e SLTU.
module tb_pl_cpu;
    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic [17:0] SW = 18'b0;
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

    integer cycles;
    integer errors;
    integer i;
    logic [31:0] expected [0:11];

    always #10 clk = ~clk; // 50 MHz equivalente para a variante pl_top_no_pll.

    pl_cpu dut (
        .clk(clk), .rst_n(rst_n), .PC(PC),
        .SW(SW), .KEY_IO(KEY_IO), .LEDR(LEDR), .LEDG(LEDG),
        .UART_TXD(UART_TXD), .UART_RXD(UART_RXD),
        .wb_reg_write(wb_reg_write), .wb_reg_dst(wb_reg_dst),
        .wb_reg_data(wb_reg_data), .mem_wr_en(mem_wr_en),
        .mem_wr_addr(mem_wr_addr), .mem_wr_data(mem_wr_data)
    );

    initial begin
        expected[0]  = 32'd42;
        expected[1]  = 32'd8;
        expected[2]  = 32'd15;
        expected[3]  = 32'd1;
        expected[4]  = 32'd40;
        expected[5]  = 32'h0FFFFFFF;
        expected[6]  = 32'hFFFFFFFC;
        expected[7]  = 32'd12;
        expected[8]  = 32'd80;
        expected[9]  = 32'h1FFFFFFE;
        expected[10] = 32'hFFFFFFFE;
        expected[11] = 32'd1;

        errors = 0;
        repeat (5) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;

        // O programa possui 28 instrucoes; 80 ciclos deixam o pipeline drenar.
        repeat (80) @(negedge clk);

        $display("\n============================================");
        $display(" TESTE DE INTEGRACAO RV32I - RESULTADOS DMEM");
        $display("============================================");
        for (i = 0; i < 12; i = i + 1) begin
            if (dut.datapath.dmem.ram[i] !== expected[i]) begin
                $display("FALHA dmem[%0d]: esperado=%08h obtido=%08h",
                         i, expected[i], dut.datapath.dmem.ram[i]);
                errors = errors + 1;
            end else begin
                $display("OK    dmem[%0d] = %08h", i, dut.datapath.dmem.ram[i]);
            end
        end

        if (errors == 0) begin
            $display("\nPASSOU: os 12 resultados conferem.");
            $finish;
        end else begin
            $display("\nFALHOU: %0d resultado(s) divergente(s).", errors);
            $fatal(1, "Falha no teste de integracao do CPU.");
        end
    end

    initial begin
        #50000;
        $fatal(1, "Timeout: o testbench excedeu o tempo maximo.");
    end
endmodule
