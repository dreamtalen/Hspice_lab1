.TITLE Single Inv_chain
.lib "C:\synopsys\PTM\models" ptm16lstp
.options acct list post runlvl=6
.global vdd gnd vss
.TEMP 85
.param h=3
*.param vds_sup=0.1
.param supply=0.85

.param finp=1
.param finn=1
.param length=20n
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
X2 B C INV M='H'
*X3 C D INV M='H**2'
*X4 D E INV M='H**3'
*X5 E F INV M='H**4'
X6 C D INV_EX M='120'
X7 D E INV_EX M='4'
*
*
VDD VDD GND 'SUPPLY'
VSS VSS GND 'SUPPLY'
VIN A GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 250ns 500ns
*
.tran 1ps 10us SWEEP H 2 14 1
.op all 

.measure TRAN tphl
+	TRIG v(a) VAL='SUPPLY/2' RISE=10
+	TARG v(c) VAL='SUPPLY/2' FALL=10
.measure TRAN tplh
+	TRIG v(a) VAL='SUPPLY/2' FALL=10
+	TARG V(c) VAL='SUPPLY/2' RISE=10
.measure TRAN tp param='(tphl+tplh)/2'
.end