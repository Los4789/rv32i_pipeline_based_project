
# TODO (Automacao): executar todos os testes do processador RV32I em sequencia.

set testes {
    run_alu.do
    run_modelsim.do
    run_rtype.do
    run_rtype_advanced.do
    run_stage2.do
    run_stage2_advanced.do
    run_stage3_memory.do
    run_stage3_branch.do
    run_stage3_advanced.do
}

foreach teste $testes {
    puts "\n========================================"
    puts " EXECUTANDO: $teste"
    puts "========================================"

    # TODO (Automacao): encerrar a simulacao anterior antes do proximo teste.
    catch {quit -sim}

    # TODO (Automacao): interromper a bateria se o script gerar um erro Tcl.
    if {[catch {do $teste} erro]} {
        puts "ERRO NO SCRIPT: $teste"
        puts $erro
        break
    }
}

puts "\nBATERIA DE TESTES FINALIZADA."
