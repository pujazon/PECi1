.text

movi r0, 32
movi r1, 0xAB
wrs s0, r1
movi r1, 0x10
movhi r1, 0xC0
wrs s1, r1
reti
halt
rds r5, s7
st 0(r0), r5
halt


