`timescale 1ns/1ps
// TODO (Etapa 03): teste integrado de loads/stores, desvios, loops, JAL/JALR e hazards.
module tb_stage3_advanced;
    logic clk=0, rst_n=0;
    logic [31:0] PC;
    logic [17:0] LEDR;
    logic [8:0] LEDG;
    logic UART_TXD;
    logic wb_reg_write,mem_wr_en;
    logic [4:0] wb_reg_dst;
    logic [31:0] wb_reg_data,mem_wr_data;
    logic [7:0] mem_wr_addr;
    integer i, errors, stall_count, redirect_count;

    pl_cpu dut(.clk(clk),.rst_n(rst_n),.PC(PC),.SW(18'b0),.KEY_IO(4'hf),
      .LEDR(LEDR),.LEDG(LEDG),.UART_TXD(UART_TXD),.UART_RXD(1'b1),
      .wb_reg_write(wb_reg_write),.wb_reg_dst(wb_reg_dst),.wb_reg_data(wb_reg_data),
      .mem_wr_en(mem_wr_en),.mem_wr_addr(mem_wr_addr),.mem_wr_data(mem_wr_data));
    always #10 clk=~clk;

    // TODO (Etapa 03): conta stalls e redirecionamentos realmente observados.
    always @(posedge clk) begin
      if (rst_n) begin
        if (dut.datapath.stall) stall_count = stall_count + 1;
        if (dut.datapath.pc_src) redirect_count = redirect_count + 1;
      end
    end

    task automatic check_reg(input integer r,input logic [31:0] expected);
      begin
        if (dut.datapath.regfile.rf[r] !== expected) begin
          $display("FALHA x%0d: obtido=%h esperado=%h",r,dut.datapath.regfile.rf[r],expected);
          errors=errors+1;
        end else $display("OK x%0d = %h",r,expected);
      end
    endtask

    task automatic check_mem(input integer addr,input logic [31:0] expected);
      begin
        if (dut.datapath.dmem.ram[addr] !== expected) begin
          $display("FALHA RAM[%0d]: obtido=%h esperado=%h",addr,dut.datapath.dmem.ram[addr],expected);
          errors=errors+1;
        end else $display("OK RAM[%0d] = %h",addr,expected);
      end
    endtask

    initial begin
      errors=0;stall_count=0;redirect_count=0;
      // TODO (Etapa 03): elimina instrucoes residuais depois do programa.
      for(i=0;i<256;i=i+1) dut.datapath.imem.rom[i]=32'h00000013;
      $readmemh("program_stage3_advanced.hex",dut.datapath.imem.rom);
      // TODO (Etapa 03): zera a RAM de teste para conferir stores descartados pelo flush.
      #1;
      for(i=0;i<256;i=i+1) dut.datapath.dmem.ram[i]=32'h00000000;
      repeat(3) @(negedge clk);
      rst_n=1;
      repeat(220) @(negedge clk);
      $display("============================================");
      $display("ETAPA 03 - TESTES AVANCADOS INTEGRADOS");
      $display("============================================");
      check_reg(1,32'h0000004d);
      check_reg(2,32'h80ff7123);
      check_reg(3,32'hffffffff);
      check_reg(4,32'h00000000);
      check_reg(5,32'h00000000);
      check_reg(6,32'h00000063);
      check_reg(7,32'h80000000);
      check_reg(8,32'h00000001);
      check_reg(9,32'h00000000);
      check_reg(10,32'h80000000);
      check_reg(11,32'h00000001);
      check_reg(12,32'hffffffff);
      check_reg(13,32'h7fffffff);
      check_reg(14,32'h80000000);
      check_reg(15,32'h80ff7123);
      check_reg(16,32'h80ff7123);
      check_reg(17,32'h80ff7123);
      check_reg(18,32'h80ff7124);
      check_reg(19,32'h80ff7124);
      check_reg(20,32'h00000005);
      check_reg(21,32'h00000005);
      check_reg(22,32'h00000005);
      check_reg(23,32'h000000bc);
      check_reg(24,32'h000000bc);
      check_reg(25,32'h000000d9);
      check_reg(26,32'h000000d0);
      check_reg(27,32'h000000d0);
      check_reg(28,32'h000000f9);
      check_reg(29,32'h000000f9);
      check_reg(30,32'h000000f0);
      check_reg(31,32'h00000000);
      check_mem(32,32'hffffff23);
      check_mem(40,32'h80ff7123);
      check_mem(41,32'h80ff7123);
      check_mem(42,32'h80ff7124);
      check_mem(43,32'h000000f9);
      check_mem(44,32'h00000000);
      // TODO (Etapa 03): garante que a simulacao exerceu stalls e desvios.
      if (stall_count < 4) begin
        $display("FALHA: stalls insuficientes (%0d)",stall_count);errors=errors+1;
      end else $display("OK stalls observados = %0d",stall_count);
      if (redirect_count < 10) begin
        $display("FALHA: redirecionamentos insuficientes (%0d)",redirect_count);errors=errors+1;
      end else $display("OK redirecionamentos observados = %0d",redirect_count);
      if(errors==0) $display("PASSOU: testes avancados integrados da Etapa 03.");
      else $fatal(1,"FALHOU: %0d verificacoes.",errors);
      $finish;
    end
endmodule
