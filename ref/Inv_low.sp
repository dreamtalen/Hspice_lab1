.TITLE Single Inv_low
.lib "C:\synopsys\PTM\models" ptm16lstp
.options acct list post runlvl=6
.global vdd gnd vss
.TEMP 85
.param h=4
*.param vds_sup=0.1
.param supply=0.4

.param finp=1
.param finn=1
.param length=20n
.param times_stable = 1
*.param fint=12n
*.param finh=26n
*
.SUBCKT INV A Y nfinn=finn nfinp=finp
xnmos Y A GND GND lnfet l=length nfin=nfinn
xpmos Y A VDD VDD lpfet l=length nfin=nfinp
.ENDS
.SUBCKT INV_EX A Y nfinn=finn nfinp=finp
xnmos Y A GND GND lnfet l=length nfin=nfinn
xpmos Y A VSS VSS lpfet l=length nfin=nfinp
.ENDS
*
X1 A B INV
X2 B C INV_EX M='H'
X3 C D INV_EX M='4'
*
*
VDD VDD GND 'SUPPLY'
VSS VSS GND 'SUPPLY'
VIN A GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 250ns 500ns
*
.tran 1ps 10us SWEEP SUPPLY 0.85 0.2 -0.01
.op all 

.measure TRAN tphl
+	TRIG v(a) VAL='SUPPLY/2' RISE=19
+	TARG v(b) VAL='SUPPLY/2' FALL=19
.measure TRAN tplh
+	TRIG v(a) VAL='SUPPLY/2' FALL=19
+	TARG V(b) VAL='SUPPLY/2' RISE=19
.measure TRAN tp param='(tphl+tplh)/2'

.measure TRAN pwr AVG P(VDD) FROM=50ps+500ns*10 TO=50ps+500ns*18
.measure TRAN pwr_abs param='abs(pwr)'

.measure TRAN PDP param='pwr_abs*250ns'
.measure TRAN pwr_dny param='PDP/tp'
.measure TRAN EDP param='PDP*tp'
.end