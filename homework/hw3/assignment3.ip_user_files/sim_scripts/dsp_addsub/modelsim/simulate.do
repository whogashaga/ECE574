onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc"  -L xbip_dsp48_wrapper_v3_0_5 -L xbip_utils_v3_0_11 -L xbip_pipe_v3_0_7 -L dsp_macro_v1_0_4 -L xil_defaultlib -L secureip -lib xil_defaultlib xil_defaultlib.dsp_addsub

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {dsp_addsub.udo}

run 1000ns

quit -force