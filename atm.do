vlib work
vlog Atm.v Atm_tb.v +cover
vsim -voptargs=+acc work.tb_atm -cover
add wave *
coverage save Atm_cov.ucdb -onexit -du atm
run -all


