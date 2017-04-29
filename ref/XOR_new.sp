.TITLE Single XOR_reference
.lib "C:\synopsys\PTM\models" ptm16lstp
.options acct list post runlvl=6
.global vdd gnd vss
.TEMP 85
*.param vds_sup=0.1
.param supply=0.85

.param finp=2
.param finn=2
.param length=20n
*.param fint=12n
*.param finh=26n
*
.SUBCKT XOR A B C Y nfinn=finn nfinp=finp
xnmos1 B A 1 GND lnfet l=length nfin=nfinn
xnmos2 C 1 2 GND lnfet l=length nfin=nfinn
xnmos3 A B 1 GND lnfet l=length nfin=nfinn
xnmos4 1 C 2 GND lnfet l=length nfin=nfinn

xpmos1 B A 3 VDD lpfet l=length nfin=nfinp
xpmos2 C 3 2 VDD lpfet l=length nfin=nfinp
xpmos3 A B 3 VDD lpfet l=length nfin=nfinp
xpmos4 3 C 2 VDD lpfet l=length nfin=nfinp

xnmos5 4 2 GND GND lnfet l=length nfin=nfinn
xpmos5 4 2 VDD VDD lpfet l=length nfin=nfinp
xnmos6 Y 4 GND GND lnfet l=length nfin=nfinn
xpmos6 Y 4 VDD VDD lpfet l=length nfin=nfinp
.ENDS

.SUBCKT INV_EX A Y nfinn=1 nfinp=1
xnmos Y A GND GND lnfet l=length nfin=nfinn
xpmos Y A VSS VSS lpfet l=length nfin=nfinp
.ENDS
*
X1 A D INV_EX M='16'
X2 B E INV_EX M='16'
X3 C F INV_EX M='16'
X4 D E F G XOR
X5 G H INV_EX M='16'

*
*
VDD VDD GND 'SUPPLY'
VSS VSS GND 'SUPPLY'
VINA A GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 230ps 500ps
VINB B GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 480ps 1000ps
VINC C GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 980ps 2000ps
*
.tran 1ps 10ns
.op all 

.measure TRAN tp1
+	TRIG v(d) VAL='SUPPLY/2' RISE=5
+	TARG v(g) VAL='SUPPLY/2' RISE=4
.measure TRAN tp2
+	TRIG v(d) VAL='SUPPLY/2' RISE=6
+	TARG v(g) VAL='SUPPLY/2' FALL=5
.measure TRAN tp3
+	TRIG v(d) VAL='SUPPLY/2' FALL=7
+	TARG v(g) VAL='SUPPLY/2' RISE=5
.measure TRAN tp4
+	TRIG v(d) VAL='SUPPLY/2' RISE=7
+	TARG v(g) VAL='SUPPLY/2' FALL=6
.measure TRAN tp5
+	TRIG v(d) VAL='SUPPLY/2' RISE=8
+	TARG v(g) VAL='SUPPLY/2' RISE=6
.measure TRAN tp6
+	TRIG v(d) VAL='SUPPLY/2' FALL=9
+	TARG v(g) VAL='SUPPLY/2' FALL=7
.measure TRAN tp param='(tp1+tp2+tp3+tp4+tp5+tp6)/6'
.measure TRAN pwr AVG P(VDD) FROM=500ps*4 TO=50ps+500ps*12
.measure TRAN pwr_abs param='abs(pwr)'

.measure TRAN PDP param='pwr_abs*1000ps/3'
.measure TRAN pwr_dny param='PDP/tp'
.measure TRAN EDP param='PDP*tp'
.end