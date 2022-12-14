#!/bin/sh
# Plotting the rastergram, two vIRT populations.xs

suffix_a=dir_here/pb_v_rast_no_intra
suffix_b=dir_here/pb_v_rast_intra   
ipar=$2
irepeat=$3

cat > frame.xx <<EOF
1950.0 0.03
1950.0 0.94

2025.0 0.03
2025.0 0.94
EOF
#2100.0 0.03
#2100.0 1.00
#
#2170.0 0.03
#2170.0 1.00

julia ../genfig/scripts_fig/process_rst.jl $suffix_a 1200.0 $ipar $irepeat
awk '{print $1 - 1200.0, $2}' ${suffix_a}/irt.sex > ${suffix_a}/irt.sex.xx

julia ../genfig/scripts_fig/process_rst.jl $suffix_b 1200.0 $ipar $irepeat
awk '{print $1 - 1200.0, $2}' ${suffix_b}/irt.sex > ${suffix_b}/irt.sex.xx

#gracebat \
xmgrace \
        -graph 0 ${suffix_a}/irt.sex.xx \
	-graph 1 ${suffix_a}/process.I1 \
	-graph 2 ${suffix_a}/process.I2 \
        -graph 3 ${suffix_a}/process.F \
	-graph 4 ${suffix_b}/irt.sex.xx \
	-graph 5 ${suffix_b}/process.I1 \
	-graph 6 ${suffix_b}/process.I2 \
        -graph 7 ${suffix_b}/process.F \
        -hdevice EPS -p ../genfig/scripts_fig/rasit_b.gr -printfile ${suffix_a}/rasit_b.eps

/bin/rm ${suffix_a}/process.* ${suffix_a}/irt.sex.xx
/bin/rm frame.xx
/bin/rm ${suffix_b}/process.* ${suffix_b}/irt.sex.xx
