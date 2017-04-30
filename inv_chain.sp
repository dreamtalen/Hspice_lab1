.TITLE Single inv_chain
.lib "/home/wjin/dmtalen/hspice/Hspice_lab1/PTM/models" ptm16lstp
.options acct list post runlvl=6
.global vdd gnd vss
.TEMP 85
.param h=5
.param supply=0.85

.param finp=1
.param finn=1
.param length=20n
.param times_stable = 1

.SUBCKT INV A Y nfinn=finn nfinp=finp
xnmos Y A GND GND lnfet l=length nfin=nfinn
xpmos Y A VDD VDD lpfet l=length nfin=nfinp
.ENDS
.SUBCKT INV_CL A Y nfinn=finn nfinp=finp
xnmos Y A GND GND lnfet l=length nfin=nfinn
xpmos Y A VSS VSS lpfet l=length nfin=nfinp
.ENDS

***********3 stage*************
X1 A B INV
X2 B C INV M='H'
X3 C D INV M='H**2'

XL1 D E INV_CL M='120'
XL2 E F INV_CL M='4'

***********4 stage*************
*X1 A B INV
*X2 B C INV M='H'
*X3 C D INV M='H**2'
*X4 D E INV M='H**3'

*XL1 E F INV_CL M='120'
*XL2 F G INV_CL M='4'

VDD VDD GND 'SUPPLY'
VSS VSS GND 'SUPPLY'

VIN A GND PULSE 0 'SUPPLY' 50ps 10ps 10ps 480ps 1ns

.tran 1ps 50ns SWEEP H 2 8 0.5
.op all 

.measure TRAN tphl
+	TRIG v(a) VAL='SUPPLY/2' RISE=10
+	TARG v(d) VAL='SUPPLY/2' FALL=10
*+	TARG v(e) VAL='SUPPLY/2' FALL=10
.measure TRAN tplh
+	TRIG v(a) VAL='SUPPLY/2' FALL=10
+	TARG v(d) VAL='SUPPLY/2' RISE=10
*+	TARG v(e) VAL='SUPPLY/2' RISE=10
.measure TRAN tp param='(tphl+tplh)/2'

.end