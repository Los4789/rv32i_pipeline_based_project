# TODO (execucao): usa o diretorio do proprio script, sem depender da pasta atual.
set SCRIPT_DIR [file dirname [file normalize [info script]]]
cd $SCRIPT_DIR

if {[file exists work]} { vdel -lib work -all }
vlib work
vmap work work
vlog -sv pl_alu.sv [file join $SCRIPT_DIR tb tb_pl_alu.sv]
vsim work.tb_pl_alu
# TODO (simulacao): mantem o ModelSim aberto quando o testbench executa $finish.
onfinish stop
run -all
