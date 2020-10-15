transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+F:/lab5_demo/yifanziyang {F:/lab5_demo/yifanziyang/ripple_adder.sv}
vlog -sv -work work +incdir+F:/lab5_demo/yifanziyang {F:/lab5_demo/yifanziyang/HexDriver.sv}
vlog -sv -work work +incdir+F:/lab5_demo/yifanziyang {F:/lab5_demo/yifanziyang/control.sv}
vlog -sv -work work +incdir+F:/lab5_demo/yifanziyang {F:/lab5_demo/yifanziyang/reg_8.sv}
vlog -sv -work work +incdir+F:/lab5_demo/yifanziyang {F:/lab5_demo/yifanziyang/synchronizers.sv}
vlog -sv -work work +incdir+F:/lab5_demo/yifanziyang {F:/lab5_demo/yifanziyang/lab4_8_bit_multiplier_toplevel.sv}

vlog -sv -work work +incdir+F:/lab5_demo/yifanziyang {F:/lab5_demo/yifanziyang/testbench_4.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench_4

add wave *
view structure
view signals
run 1000 ns
