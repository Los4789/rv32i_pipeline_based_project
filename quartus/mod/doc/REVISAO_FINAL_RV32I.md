# Revisão final — Processador RV32I pipelined

Data: 13/11/2026
Base examinada: `stage3_advanced_build`, versão dos testes avançados integrados da Etapa 03.

## Resultado das simulações informadas pelo usuário

- Etapa 01: testes R-type básicos e avançados aprovados.
- Etapa 02: testes I-type/U-type básicos e avançados aprovados.
- Etapa 03, memória: testes básicos aprovados.
- Etapa 03, branches/jumps: testes básicos aprovados.
- Etapa 03, integrado avançado: 31 registradores e 6 palavras de RAM conferidos; 7 stalls e 17 redirecionamentos observados. PASSOU, segundo o Transcript enviado.

**Limite:** esta revisão não executou ModelSim, Quartus, análise de timing nem testes físicos na DE2-115.

## Achados da inspeção estática

### 1. Atenção: UART e clock (prioridade alta para FPGA)

- `Projeto_Arquitetura.qsf` seleciona `pl_top_no_pll` como top-level e `pl_top_no_pll.sdc` como SDC. Nessa configuração, a CPU opera diretamente em `CLOCK_50` (50 MHz).
- `pl_mmio.sv` instancia `pl_uart` com `CLK_HZ(50_000_000)`, coerente com o top-level atualmente selecionado.
- `pl_top.sv`, variante com PLL, declara clock de 10 MHz. Se essa variante for selecionada, **é necessário ajustar/parametrizar a frequência usada pelo UART**; caso contrário, a taxa serial poderá ficar incorreta.
- O comentário de `pl_top_no_pll.sv` que diz 'baud incorreto sem ajuste' está desatualizado em relação ao `pl_mmio.sv` atual.

### 2. Programas de simulação e de síntese (prioridade alta)

- `pl_imem.sv` usa `program.hex` na simulação (`$readmemh`) e `instruction.mif` para inicialização na síntese (`ram_init_file`).
- `pl_dmem.sv` usa `data.hex` na simulação e `data.mif` na síntese.
- Os testbenches avançados injetam programas específicos na ROM durante a simulação. Portanto, **passar no ModelSim não demonstra que a FPGA executará esse mesmo programa**.
- Antes da síntese, escolher o programa demonstrativo e sincronizar `instruction.mif` e, se aplicável, `data.mif` com os dados esperados.

### 3. Alinhamento e endereçamento (limitação conhecida)

- `pl_datapath.sv` implementa seleção de bytes e halfwords para loads/stores.
- O próprio código informa que acessos desalinhados LH/SH/LW/SW não são suportados.
- A RAM possui 256 palavras de 32 bits; a ROM também possui 256 palavras. Os endereços são truncados para selecionar essas posições. Não há evidência de tratamento completo de exceções de acesso.

### 4. MMIO (testar em hardware)

- `pl_mmio.sv` documenta SW, KEY, LEDR, LEDG, UART e contador de ciclos.
- O caminho MMIO seleciona periféricos com `alu_result[10]`; acessos parciais a MMIO não foram validados pelos testes avançados e precisam de contrato explícito.
- Validar leitura das chaves/botões, escrita nos LEDs e transmissão/recepção UART na placa.

### 5. Documentação e comentários

- `pl_control.sv` contém cabeçalho antigo descrevendo apenas um subconjunto (add, and, lw, sw, beq), embora o decodificador atual inclua mais instruções.
- Comentários `// TODO (Etapa 03)` estão presentes nos arquivos alterados, como `pl_datapath.sv`, `pl_dmem.sv`, `pl_control.sv` e `pl_hazard.sv`.
- `run_stage3_advanced.do` contém comentários TODO herdados de etapas anteriores; recomendável simplificar futuramente.
- Não modifiquei RTL nem comentários nesta entrega: esta é uma auditoria, não um patch.

## Checklist antes de levar à FPGA

- [ ] Selecionar `pl_top_no_pll` (50 MHz) ou `pl_top` (PLL/10 MHz) e conferir UART/SDC.
- [ ] Verificar pinos e dispositivo EP4CE115F29C7 no Quartus.
- [ ] Definir programa de demonstração e atualizar `instruction.mif`.
- [ ] Conferir inicialização `data.mif` e mapa de memória.
- [ ] Compilar no Quartus e revisar erros, avisos, uso de recursos e timing.
- [ ] Testar reset, LEDs, chaves, botões e UART na placa.
- [ ] Reexecutar os testes de regressão após qualquer alteração de RTL.
- [ ] Registrar resultados reais de hardware no relatório acadêmico.

## Conclusão

As três etapas passaram nos testes de simulação reportados, inclusive a integração avançada da Etapa 03. A implementação está pronta para **preparação e validação de síntese**, mas não está comprovadamente validada na FPGA. Não afirmar conformidade exaustiva com todo o RV32I, tratamento de exceções ou acessos desalinhados.
