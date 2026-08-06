quit -sim
vdel -all
vlib work

vlib work
vmap work work

#RTL
vlog -sv +cover=bcesf +acc\
            RTL/asyncFifo_if.sv \
            RTL/asyncFifo_2FF.sv \
            RTL/asyncFifo_mem.sv \
            RTL/asyncFifo_rptr_empty.sv \
            RTL/asyncFifo_wptr_full.sv \
            RTL/asyncFifo_top.sv 

#UVM
vlog -sv +incdir+TB +cover=bcesf +acc TB/asyncFifo_package.sv 

#TB Top
vlog -sv +incdir+TB TB/asyncFifo_test_top.sv

vsim -coverage -voptargs="+acc" work.asyncFifo_test_top \
    +UVM_TESTNAME=asyncFifo_test +UVM_VERBOSITY=UVM_HIGH

# 4. Waveforms and logging
view wave 
add wave -r /*
log -r /*

#Run
run -all

#Coverage Report
coverage save fifo_cov.ucdb
vcover report -details fifo_cov.ucdb -output fifo_covReport.txt

#After completion
echo "Simulation Complete. Coverage database: fifo_cov.ucdb | Report: fifo_covReport.txt"