# Etapa 03 — testes avancados integrados

Execute no ModelSim: `do run_stage3_advanced.do`.

- 87 instrucoes de maquina; 77 instrucoes executadas no interpretador de referencia.
- Testa loads LB/LBU/LH/LHU/LW, stores SB/SH/SW, load-use, load->store, load->branch, load->JALR, forwarding, loop com branch retroativo, comparacoes signed/unsigned, JAL/JALR, PC+4, flush e protecao de x0.
- Confere x1..x31, 6 palavras da RAM e contadores de stalls/redirecionamentos.
- x31 e inicializado em zero e usado como indicador de erro caso o fluxo execute uma instrucao proibida.
- Os destinos JALR usam endereco impar para conferir limpeza do bit 0.
- A RAM de teste e zerada explicitamente, permitindo detectar store indevido apos branch.
- Programa gerado por montador simples, e resultados esperados calculados por interpretador Python separado do RTL.
- Arquivos RTL originais preservados; TODO nos novos arquivos de teste e script.
- Nao inclui acessos desalinhados ou MMIO parcial; nao substitui testes na FPGA.

Resultado esperado: `PASSOU: testes avancados integrados da Etapa 03.`

**Nota:** O pacote nao foi executado no ModelSim neste ambiente. Envie o Transcript para diagnostico.
