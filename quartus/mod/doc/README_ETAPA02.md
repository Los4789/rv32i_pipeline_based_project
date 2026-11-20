# Etapa 02 - I-type e U-type

Instrucoes exigidas: ADDI, ANDI, ORI, SLTI, SLLI, SRLI, SRAI, XORI, LUI e AUIPC.
O projeto tambem decodifica SLTIU (extra).

Execute no ModelSim: `do run_stage2.do`

O testbench verifica x1 a x31, mas nao constitui prova de cobertura exaustiva.
O teste nao foi executado no ModelSim neste ambiente; confirme no seu computador.

Alteracao de RTL: pl_datapath.sv, mux operando A da ALU para LUI, identificada com TODO.
Todos os demais arquivos originais foram mantidos.

Os arquivos program_stage2.hex, tb/tb_stage2.sv e run_stage2.do sao novos.
