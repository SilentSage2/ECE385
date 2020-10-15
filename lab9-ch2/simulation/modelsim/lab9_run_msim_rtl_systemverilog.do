transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+I:/lab9-ch2 {I:/lab9-ch2/SubBytes.sv}
vlog -sv -work work +incdir+I:/lab9-ch2 {I:/lab9-ch2/InvShiftRows.sv}
vlog -sv -work work +incdir+I:/lab9-ch2 {I:/lab9-ch2/InvMixColumns.sv}
vlog -sv -work work +incdir+I:/lab9-ch2 {I:/lab9-ch2/AddRoundKey.sv}
vlog -sv -work work +incdir+I:/lab9-ch2 {I:/lab9-ch2/reg_128.sv}
vlog -sv -work work +incdir+I:/lab9-ch2 {I:/lab9-ch2/state_MUX.sv}
vlog -sv -work work +incdir+I:/lab9-ch2 {I:/lab9-ch2/MixColumn_MUX.sv}
vlog -sv -work work +incdir+I:/lab9-ch2 {I:/lab9-ch2/KeyExpansion.sv}
vlog -sv -work work +incdir+I:/lab9-ch2 {I:/lab9-ch2/AES.sv}
vlog -sv -work work +incdir+I:/lab9-ch2 {I:/lab9-ch2/Inv_sub.sv}
vlib lab9_soc
vmap lab9_soc lab9_soc

vlog -sv -work work +incdir+I:/lab9-ch2 {I:/lab9-ch2/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L lab9_soc -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 3000 ns
