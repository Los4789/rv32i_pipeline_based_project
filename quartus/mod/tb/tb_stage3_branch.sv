`timescale 1ns/1ps
module tb_stage3_branch;
    logic clk=0, rst_n=0;
    logic [31:0] PC;
    logic [17:0] LEDR; logic [8:0] LEDG; logic UART_TXD;
    logic wb_reg_write,mem_wr_en;
    logic [4:0] wb_reg_dst; logic [31:0] wb_reg_data,mem_wr_data;
    logic [7:0] mem_wr_addr;
    pl_cpu dut(.clk(clk),.rst_n(rst_n),.PC(PC),.SW(18'b0),.KEY_IO(4'hf),
      .LEDR(LEDR),.LEDG(LEDG),.UART_TXD(UART_TXD),.UART_RXD(1'b1),
      .wb_reg_write(wb_reg_write),.wb_reg_dst(wb_reg_dst),.wb_reg_data(wb_reg_data),
      .mem_wr_en(mem_wr_en),.mem_wr_addr(mem_wr_addr),.mem_wr_data(mem_wr_data));
    always #10 clk=~clk;
    integer i,errors;
    task automatic check_reg(input integer r,input logic [31:0] exp);
      begin
        if (dut.datapath.regfile.rf[r] !== exp) begin
          $display("FALHA x%0d: obtido=%h esperado=%h",r,dut.datapath.regfile.rf[r],exp);
          errors=errors+1;
        end else $display("OK x%0d = %h",r,exp);
      end
    endtask
    initial begin
      // TODO (Etapa 03): inicializa ROM com NOP antes de carregar branches e jumps.
      for(i=0;i<256;i=i+1) dut.datapath.imem.rom[i]=32'h00000013;
      $readmemh("program_stage3_branch.hex",dut.datapath.imem.rom);
      repeat(3) @(negedge clk);rst_n=1;
      repeat(150) @(negedge clk);
      errors=0;
      $display("ETAPA 03 - BRANCHES E JUMPS");
      check_reg(10,32'h00000001);
      check_reg(11,32'h00000002);
      check_reg(12,32'h00000003);
      check_reg(13,32'h00000004);
      check_reg(14,32'h00000005);
      check_reg(15,32'h00000006);
      check_reg(16,32'h00000007);
      check_reg(17,32'h00000084);
      check_reg(18,32'h00000008);
      check_reg(19,32'h00000098);
      check_reg(20,32'h00000009);
      check_reg(21,32'h0000000a);
      check_reg(31,32'h00000000);
      // TODO (Etapa 03): x31=0 garante que nenhum desvio indevido chegou a FAIL.
      if(errors==0) $display("PASSOU: branches e jumps da Etapa 03.");
      else $fatal(1,"FALHOU: %0d verificacoes.",errors);
      $finish;
    end
endmodule
