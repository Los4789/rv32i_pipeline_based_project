# Etapa 03 — Parte 1: loads e stores

Implementadas LB, LH, LBU, LHU, SB, SH; preservados LW e SW.

Execute `do run_stage3_memory.do` no ModelSim. Envie o Transcript.

**Limitações:** acessos desalinhados e acessos parciais a MMIO não são suportados; o teste cobre apenas endereços alinhados para halfword/word.

Arquivos RTL alterados: `pl_dmem.sv` e `pl_datapath.sv`. Comentários `// TODO (Etapa 03)` indicam mudanças.

Ainda faltam branches BNE, BLT, BGE, BLTU, BGEU e jumps JAL/JALR para concluir a Etapa 03.
