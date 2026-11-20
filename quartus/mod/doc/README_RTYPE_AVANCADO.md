# ETAPA 01 - TESTES AVANCADOS R-TYPE

Execute no Transcript do ModelSim, a partir da pasta do projeto:

    do run_rtype_advanced.do

O pacote preserva os arquivos existentes e acrescenta:
- program_rtype_advanced.hex (45 instrucoes)
- tb/tb_rtype_advanced.sv
- run_rtype_advanced.do

## Cobertura
- ADD/SUB com zero, numeros negativos e overflow de 32 bits.
- SLL/SRL/SRA com deslocamentos 0 e 31.
- SLT/SLTU com sinais opostos e operandos iguais.
- XOR/OR/AND, operacoes com duas fontes iguais.
- RAW/forwarding com dependencias consecutivas e separadas.
- Escrita em x0 seguida de leitura de x0 em x30 (x0 nao deve mudar).

As instrucoes ADDI sao usadas apenas para inicializar operandos;
o foco da validacao continua sendo R-type.

O testbench verifica x1 a x31 apos 115 ciclos; x0 e verificado
indiretamente pela leitura arquitetural de x0 em uma instrucao ADD.

IMPORTANTE: os resultados esperados foram calculados por um modelo
de referencia simples, mas NAO executamos o ModelSim neste ambiente.
Somente a sua execucao no ModelSim confirmara a aprovacao.

O testbench e exclusivo de simulacao. Nenhum modulo RTL de producao
ou arquivo de configuracao Quartus foi modificado.
