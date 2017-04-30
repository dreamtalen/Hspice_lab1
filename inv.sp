.TITLE Single INV
.lib "/home/wjin/dmtalen/hspice/Hspice_lab1/PTM/models" ptm16lstp
.options acct list post runlvl=6
.global vdd gnd vss
.TEMP 85
.param supply=0.85

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
VIN A GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 480ps 1ns

.tran 1ps 10us SWEEP finp 1 10 1
.op all 

.measure TRAN tphl
+	TRIG v(a) VAL='SUPPLY/2' RISE=10
+	TARG v(b) VAL='SUPPLY/2' FALL=10
.measure TRAN tplh
+	TRIG v(a) VAL='SUPPLY/2' FALL=10
+	TARG v(b) VAL='SUPPLY/2' RISE=10

.end