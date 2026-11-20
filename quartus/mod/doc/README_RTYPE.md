ETAPA 01 - TESTE INTEGRADO R-TYPE
=================================

Objetivo
--------
Testar as dez operacoes R-type exigidas:
ADD, SUB, OR, AND, SLT, XOR, SLL, SRL, SRA e SLTU.

O testbench tambem inclui dependencias consecutivas:
- SUB usa imediatamente o resultado de ADD (x15).
- ADD seguinte usa os resultados de SUB (x16) e ADD (x15).
Esses casos ajudam a verificar o caminho de forwarding.

Como executar
-------------
1. Extraia o ZIP para uma pasta.
2. Abra o ModelSim nessa pasta.
3. No Transcript, execute:
      do run_rtype.do
4. Aguarde a lista de resultados x1 ate x17.

Resultado esperado
------------------
A ultima mensagem deve ser:
PASSOU: todas as instrucoes e dependencias R-type conferem.

Importante
----------
Este teste nao altera os fontes do processador. O testbench carrega
program_rtype.hex diretamente na ROM de simulacao enquanto o CPU esta em reset.
O arquivo program.hex original permanece preservado.

O teste verifica os resultados finais no banco de registradores e inclui
dependencias consecutivas. Ele nao substitui testes adicionais de casos de
borda, inspeção de waveform ou validacao fisica na FPGA.

Sobre o TODO
------------
As alteracoes/adicoes deste pacote estao identificadas com comentarios
// TODO (explicacao da mudanca), conforme solicitado.

Correcao da revisao do testbench
--------------------------------
A ROM inteira agora e preenchida com NOP antes de carregar program_rtype.hex.
Isso impede que instrucoes residuais de program.hex sejam executadas depois
do programa R-type e sobrescrevam registradores durante a verificacao.
