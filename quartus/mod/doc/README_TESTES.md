# RV32I - pacote de simulacao e revisao inicial

Dispositivo configurado no projeto: **EP4CE115F29C7 (Cyclone IV E)**.
Top-level atualmente selecionado: `pl_top_no_pll` (clock direto de 50 MHz).

## Teste de integracao no ModelSim

1. Extraia o ZIP para uma pasta sem espacos no caminho, se possivel.
2. Abra o ModelSim na pasta raiz do projeto (a mesma pasta de `pl_pipe_pkg.sv`).
3. Execute no Transcript:

   ```tcl
   do run_modelsim.do
   ```

4. O testbench deve imprimir `PASSOU` somente se os 12 valores esperados em `dmem[0]` ate `dmem[11]` coincidirem.

O teste usa `program.hex` (gerado pelo assembler a partir do `hello.asm`) e `data.hex` (memoria de dados zerada). Os arquivos `.hex` precisam permanecer na pasta raiz durante a simulacao, pois os modulos usam `$readmemh` com esses nomes relativos.

## Escopo comprovado pelo testbench

O programa fornecido exercita ADDI, ANDI, ORI, SLTI, SLLI, SRLI, SRAI, XOR, SLL, SRL, SRA, SLTU e SW. O testbench confere os 12 resultados gravados na memoria de dados.

**Importante:** este teste NAO comprova as 37 instrucoes RV32I. JAL/JALR, todos os branches, loads/stores de byte e halfword, forwarding em todos os cenarios, hazards complexos e MMIO ainda exigem testes dedicados e/ou implementacao adicional. Nao considerar o processador integralmente validado apenas com este teste.

## Alteracoes sinalizadas

As mudancas feitas nesta revisao estao marcadas nos fontes com `TODO (explicacao)`. Em SystemVerilog, o comentario correto e `// TODO (...)`; em Python, usa-se `# TODO (...)`.

## Quartus

O QSF mantem `EP4CE115F29C7` e `pl_top_no_pll`, e agora referencia somente `pl_top_no_pll.sdc`, coerente com o top-level de 50 MHz. A UART esta configurada para 50 MHz em `pl_mmio.sv`.

Antes de programar a FPGA, compile no Quartus, confira todos os avisos de pinos/timing e valide a pinagem da placa DE2-115. A simulacao nao substitui a compilacao e o teste fisico.
