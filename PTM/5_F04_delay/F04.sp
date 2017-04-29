.TITLE F04 DELAY
.lib "C:\synopsys\PTM\models" ptm16lstp
.options acct list post
.global vdd gnd vss
.TEMP 85
.param h=4
.param vds_sup=0.1
.param supply=0.85

.param finp=2
.param finn=1
.param length=20n
.param fint=12n
.param finh=26n
*
.SUBCKT INV A Y nfinn=1 nfinp=2
xnmos Y A GND GND lnfet l=length nfin=nfinn
xpmos Y A VDD VDD lpfet l=length nfin=nfinp
.ENDS
*
X1 A B INV
X2 B C INV M='H'
X3 C D INV M='H**2'
X4 D E INV M='H**3'
X5 E F INV M='H**4'
X6 F G INV M='H**5'
*
*
VDD VDD GND 'SUPPLY'
VIN A GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 230ps 500ps
*
.tran 1ps 10ns
.op all 

.measure tpdrbc
+	TRIG v(b) VAL='SUPPLY/2' FALL=1
+	TARG v(c) VAL='SUPPLY/2' RISE=1
.measure dprfbc
+	TRIG v(b) VAL='SUPPLY/2' RISE=1
+	TARG V(c) VAL='SUPPLY/2' FALL=1
.end