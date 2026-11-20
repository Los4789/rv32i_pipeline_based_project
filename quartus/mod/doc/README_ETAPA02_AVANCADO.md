# Etapa 02 — Teste avançado I-type / U-type

Este pacote preserva os módulos RTL da Etapa 02. Nenhum RTL foi alterado.

Execute no ModelSim: `do run_stage2_advanced.do`

O programa contém 63 instruções, incluindo ADDI, ANDI, ORI, XORI, SLTI, SLTIU (extra RV32I), SLLI, SRLI, SRAI, LUI, AUIPC e ADD R-type para interoperabilidade.

Cobre limites dos imediatos -2048 e 2047, shifts 0 e 31, sinal, PC variável em AUIPC, escrita x0, dependências consecutivas e integração R/I/U.

Os valores esperados são conferidos no final contra x1..x31 e x0. A verificação de estado final não substitui checagem de todas as transições de pipeline.

O testbench usa acesso hierárquico à ROM e aos registradores, exclusivamente para simulação.

## Instruções (índice / PC em bytes / descrição)
00 / 000: ADDI x1,x0,2047
01 / 004: ADDI x2,x0,-2048
02 / 008: ADDI x3,x0,-1
03 / 012: ADDI x4,x0,0
04 / 016: ADDI x5,x0,1
05 / 020: ADDI x6,x1,1 -> 2048
06 / 024: ADDI x7,x2,-1 -> -2049
07 / 028: ADDI x8,x3,-2048
08 / 032: ANDI -1,2047
09 / 036: ORI 0,-2048
10 / 040: XORI -1,2047
11 / 044: SLTI -2048 < -2047
12 / 048: SLTI equality
13 / 052: SLTI 2047 < -1
14 / 056: SLTI -1 < 1
15 / 060: SLTIU -1 < 0
16 / 064: SLTIU 0 < -1 unsigned
17 / 068: SLLI 1,31
18 / 072: SRLI 0x80000000,31
19 / 076: SRAI 0x80000000,31
20 / 080: SRLI -1,0
21 / 084: SRAI -1,0
22 / 088: SLLI 1,0
23 / 092: SRLI -1,31
24 / 096: SRAI -1,31
25 / 100: LUI positive
26 / 104: LUI negative
27 / 108: LUI min signed
28 / 112: LUI zero
29 / 116: AUIPC positive, PC != 0
30 / 120: AUIPC negative
31 / 124: ADDI dependent on AUIPC
32 / 128: ADDI dependent on ADDI
33 / 132: ANDI dependent on ADDI
34 / 136: ORI dependent on ANDI
35 / 140: XORI dependent on ORI
36 / 144: SLLI dependent on XORI
37 / 148: SRLI dependent on SLLI
38 / 152: SRAI dependent on SRLI
39 / 156: SLTI dependent on SRAI
40 / 160: LUI overwrite x10
41 / 164: ADDI dependent on LUI
42 / 168: AUIPC +4096
43 / 172: ADDI dependent on AUIPC
44 / 176: R-type ADD dependent on I-type
45 / 180: I-type dependent on R-type
46 / 184: AUIPC signed min
47 / 188: AUIPC zero imm => PC
48 / 192: AUIPC -4096
49 / 196: attempt write x0
50 / 200: read x0 after write
51 / 204: LUI 4096
52 / 208: LUI + ADDI negative
53 / 212: dependent immediate positive
54 / 216: shift forwarded value
55 / 220: arithmetic shift forwarded value
56 / 224: SLTIU forwarded value
57 / 228: SLTI forwarded value
58 / 232: AUIPC PC varied
59 / 236: forward AUIPC
60 / 240: forward consecutive AUIPC
61 / 244: LUI zero after AUIPC
62 / 248: forward LUI zero
