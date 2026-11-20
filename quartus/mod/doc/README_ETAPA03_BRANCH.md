# Etapa 03 - Parte 2: Branches e Jumps

Implementados BNE, BLT, BGE, BLTU, BGEU, JAL, JALR; BEQ preservado.

Execute `do run_stage3_branch.do` no ModelSim, a partir da pasta do projeto.

Testa desvios tomados e nao tomados, comparacao signed/unsigned, forwarding para branch, flush, JAL/JALR, bit zero do alvo JALR, e endereco de retorno PC+4. x31 e sentinela de falha.

**Ainda nao validado em ModelSim.** Testes nao cobrem todas as combinacoes, nem FPGA, nem jumps desalinhados/erros de instrucao.

Arquivos RTL alterados com comentarios `// TODO (Etapa 03)`.
