.TITLE Single XOR_3input_ref
.lib "/home/wjin/dmtalen/hspice/Hspice_lab1/PTM/models" ptm16lstp
.options acct list post runlvl=6
.global vdd gnd vss
.TEMP 85
.param supply=0.85

.param finp=2
.param finn=2
.param length=20n

.SUBCKT XOR A B C Y nfinn=finn nfinp=finp

xpmos1 1 A VDD VDD lpfet l=length nfin=nfinp
xpmos2 1 B VDD VDD lpfet l=length nfin=nfinp
xpmos3 4 B VDD VDD lpfet l=length nfin=nfinp
xpmos4 2 C 1 VDD lpfet l=length nfin=nfinp
xpmos5 2 A 4 VDD lpfet l=length nfin=nfinp

xpmos6 6 A VDD VDD lpfet l=length nfin=nfinp
xpmos7 6 B VDD VDD lpfet l=length nfin=nfinp
xpmos8 6 C VDD VDD lpfet l=length nfin=nfinp
xpmos9 7 2 6 VDD lpfet l=length nfin=nfinp

xpmos10 9 A VDD VDD lpfet l=length nfin=nfinp
xpmos11 10 B 9 VDD lpfet l=length nfin=nfinp
xpmos12 7 C 10 VDD lpfet l=length nfin=nfinp

xnmos1 3 A GND GND lnfet l=length nfin=nfinn
xnmos2 3 B GND GND lnfet l=length nfin=nfinn
xnmos3 5 B GND GND lnfet l=length nfin=nfinn
xnmos4 2 C 3 GND lnfet l=length nfin=nfinn
xnmos5 2 A 5 GND lnfet l=length nfin=nfinn

xnmos6 8 A GND GND lnfet l=length nfin=nfinn
xnmos7 8 B GND GND lnfet l=length nfin=nfinn
xnmos8 8 C GND GND lnfet l=length nfin=nfinn
xnmos9 7 2 8 GND lnfet l=length nfin=nfinn

xnmos10 12 A GND GND lnfet l=length nfin=nfinn
xnmos11 11 B 12 GND lnfet l=length nfin=nfinn
xnmos12 7 C 11 GND lnfet l=length nfin=nfinn

xnmos13 Y 7 GND GND lnfet l=length nfin=nfinn
xpmos13 Y 7 VDD VDD lpfet l=length nfin=nfinp

.ENDS
.SUBCKT INV_CL A Y nfinn=finn nfinp=finp
xnmos Y A GND GND lnfet l=length nfin=nfinn
xpmos Y A VSS VSS lpfet l=length nfin=nfinp
.ENDS

X1 A B C D XOR
X2 D E INV_CL M='8'

VDD VDD GND 'SUPPLY'
VSS VSS GND 'SUPPLY'
VINA C GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 230ps 500ps
VINB B GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 480ps 1ns
VINC A GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 980ps 2ns
*
.tran 1ps 10ns
.op all 

.measure TRAN tp1
+	TRIG v(c) VAL='SUPPLY/2' RISE=5
+	TARG v(d) VAL='SUPPLY/2' RISE=4
.measure TRAN tp2
+	TRIG v(c) VAL='SUPPLY/2' FALL=5
+	TARG v(d) VAL='SUPPLY/2' FALL=4
.measure TRAN tp3
+	TRIG v(c) VAL='SUPPLY/2' FALL=6
+	TARG v(d) VAL='SUPPLY/2' RISE=5
.measure TRAN tp4
+	TRIG v(c) VAL='SUPPLY/2' RISE=7
+	TARG v(d) VAL='SUPPLY/2' FALL=5
.measure TRAN tp5
+	TRIG v(c) VAL='SUPPLY/2' FALL=7
+	TARG v(d) VAL='SUPPLY/2' RISE=6
.measure TRAN tp6
+	TRIG v(c) VAL='SUPPLY/2' FALL=8
+	TARG v(d) VAL='SUPPLY/2' FALL=6

.measure TRAN tp param='(tp1+tp2+tp3+tp4+tp5+tp6)/6'
.measure TRAN power AVG P(VDD) FROM=2ns TO=8ns
.measure TRAN power_abs param='abs(power)'
.measure TRAN PDP param='power_abs*2ns/6'
.measure TRAN dynamic_power param='PDP/tp'
.measure TRAN EDP param='PDP*tp'
.end