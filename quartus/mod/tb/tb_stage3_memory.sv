`timescale 1ns/1ps
// TODO (Etapa 03): teste integrado de LB/LH/LBU/LHU/SB/SH e regressao LW/SW.
module tb_stage3_memory;
 logic clk=0, rst_n=0;
 logic [17:0] SW='0, LEDR;
 logic [3:0] KEY_IO=4'b1111;
 logic [8:0] LEDG;
 logic UART_TXD, UART_RXD=1'b1;
 logic [31:0] PC, wb_reg_data, mem_wr_data;
 logic wb_reg_write, mem_wr_en;
 logic [4:0] wb_reg_dst;
 logic [7:0] mem_wr_addr;
 logic [31:0] expected [1:29];
 integer errors=0, j;
 always #10 clk=~clk;
 pl_cpu dut (.clk(clk),.rst_n(rst_n),.PC(PC),.SW(SW),.KEY_IO(KEY_IO),
  .LEDR(LEDR),.LEDG(LEDG),.UART_TXD(UART_TXD),.UART_RXD(UART_RXD),
  .wb_reg_write(wb_reg_write),.wb_reg_dst(wb_reg_dst),.wb_reg_data(wb_reg_data),
  .mem_wr_en(mem_wr_en),.mem_wr_addr(mem_wr_addr),.mem_wr_data(mem_wr_data));
 initial begin
        expected[1] = 32'h80ff7123;
        expected[2] = 32'h00000023;
        expected[3] = 32'h00000023;
        expected[4] = 32'h00000071;
        expected[5] = 32'h00000071;
        expected[6] = 32'hffffffff;
        expected[7] = 32'h000000ff;
        expected[8] = 32'hffffff80;
        expected[9] = 32'h00000080;
        expected[10] = 32'h80ff7123;
        expected[11] = 32'hffffffff;
        expected[12] = 32'hffffffff;
        expected[13] = 32'h000000ff;
        expected[14] = 32'h80ffff23;
        expected[15] = 32'hffffffff;
        expected[16] = 32'h0000ffff;
        expected[17] = 32'hffffff23;
        expected[18] = 32'hffffffff;
        expected[19] = 32'h000000ff;
        expected[20] = 32'hffffff23;
        expected[21] = 32'h0000ff23;
        expected[22] = 32'h00000023;
        expected[23] = 32'h00000023;
        expected[24] = 32'hffffff23;
        expected[25] = 32'hffffff24;
        expected[26] = 32'hffffff24;
        expected[27] = 32'hffffff27;
        expected[28] = 32'h00000027;
        expected[29] = 32'h27ffff24;
  // TODO (Etapa 03): isola ROM e memoria de dados para teste reproduzivel.
  #1;
  for(j=0;j<256;j=j+1) begin
    dut.datapath.imem.rom[j]=32'h00000013;
    dut.datapath.dmem.ram[j]=32'b0;
  end
  $readmemh("program_stage3_memory.hex",dut.datapath.imem.rom);
  repeat(5) @(posedge clk);
  @(negedge clk) rst_n=1;
  repeat(140) @(negedge clk);
  $display("\nETAPA 03 - MEMORIA (LOADS/STORES)");
  for(j=1;j<=29;j=j+1) begin
    if(dut.datapath.regfile.rf[j] !== expected[j]) begin
      $display("FALHA x%0d: esperado=%08h obtido=%08h",j,expected[j],dut.datapath.regfile.rf[j]); errors=errors+1;
    end else $display("OK x%0d = %08h",j,expected[j]);
  end
  // TODO (Etapa 03): verifica preservacao de bytes nao selecionados.
  if(dut.datapath.dmem.ram[0] !== 32'hffff_ff23) begin
    $display("FALHA dmem[0] = %08h",dut.datapath.dmem.ram[0]); errors=errors+1;
  end
  if(dut.datapath.dmem.ram[1] !== 32'h27ffff24) begin
    $display("FALHA dmem[1] = %08h",dut.datapath.dmem.ram[1]); errors=errors+1;
  end
  if(errors==0) $display("PASSOU: testes de memoria da Etapa 03.");
  else $fatal(1,"FALHOU: %0d verificacoes.",errors);
  $finish;
 end
endmodule
