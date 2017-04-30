.TITLE Single inv_min
.lib "/home/wjin/dmtalen/hspice/Hspice_lab1/PTM/models" ptm16lstp
.options acct list post runlvl=6
.global vdd gnd vss
.TEMP 85
.param supply=0.2

.param finp=1
.param finn=1
.param length=20n
.param times_stable = 1

.SUBCKT INV A Y nfinn=finn nfinp=finp
xnmos Y A GND GND lnfet l=length nfin=nfinn
xpmos Y A VDD VDD lpfet l=length nfin=nfinp
.ENDS

X1 A B INV

VDD VDD GND 'SUPPLY'
VIN A GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 200ns 400ns

.tran 1ps 10us SWEEP SUPPLY 0.2 0.85 0.01
.op all 

.measure TRAN tphl
+	TRIG v(a) VAL='SUPPLY/2' RISE=10
+	TARG v(b) VAL='SUPPLY/2' FALL=10
.measure TRAN tplh
+	TRIG v(a) VAL='SUPPLY/2' FALL=10
+	TARG v(b) VAL='SUPPLY/2' RISE=10
.measure TRAN tp param='(tphl+tplh)/2'

.measure TRAN power AVG P(VDD) FROM=3us TO=8us
.measure TRAN power_abs param='abs(power)'
.measure TRAN PDP param='power_abs*200ns/2'
.measure TRAN dynamic_power param='PDP/tp'
.measure TRAN EDP param='PDP*tp'

.end