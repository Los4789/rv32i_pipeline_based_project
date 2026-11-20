# TODO (Etapa 03): executa teste integrado avancado sem modificar o RTL.
# TODO (Etapa 03): compila e executa testes de branches e jumps.
# TODO (Etapa 03 loads e stores): compila a hierarquia completa e executa o testbench
# dedicado a as instrucoes I-type/U-type e dependencias, incluindo dependencias consecutivas.
set SCRIPT_DIR [file dirname [file normalize [info script]]]
cd $SCRIPT_DIR

if {[file exists work]} { vdel -lib work -all }
vlib work
vmap work work

vlog -sv pl_pipe_pkg.sv
vlog -sv pl_alu.sv pl_alu_ctrl.sv pl_control.sv pl_sign_ext.sv
vlog -sv pl_regfile.sv pl_forward.sv pl_hazard.sv
vlog -sv pl_imem.sv pl_dmem.sv pl_uart.sv pl_mmio.sv
vlog -sv pl_datapath.sv pl_cpu.sv
vlog -sv [file join $SCRIPT_DIR tb tb_stage3_advanced.sv]

vsim -voptargs=+acc work.tb_stage3_advanced
onfinish stop
run -all
