.TITLE Single Inv_low
.lib "/home/wjin/dmtalen/hspice/Hspice_lab1/PTM/models" ptm16lstp
.options acct list post runlvl=6
.global vdd gnd vss
.TEMP 85
.param h=4
*.param vds_sup=0.1
.param supply=0.85

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
*
*
VDD VDD GND 'SUPPLY'
VSS VSS GND 'SUPPLY'
VIN A GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 250ns 500ns
*
.tran 1ps 10us SWEEP finp 0 10 1
.op all 

.measure TRAN tphl
+	TRIG v(a) VAL='SUPPLY/2' RISE=19
+	TARG v(b) VAL='SUPPLY/2' FALL=19
.measure TRAN tplh
+	TRIG v(a) VAL='SUPPLY/2' FALL=19
+	TARG V(b) VAL='SUPPLY/2' RISE=19

.end