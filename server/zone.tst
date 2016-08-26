;
;  Database file zone.tst for @. zone.
;	Zone version: 2011052807
;

$ORIGIN zone.tst.


$TTL 600
@		600	IN  SOA  ns.zone.tst. hostmaster.zone.tst. (
				2011052807	; serial number
				18000	; refresh
				1800	; retry
				1209600	; expire
				86400	; minimum TTL
				)
;
; Zone NS Records
;

@	600	IN	NS	ns.zone.tst.
ns	600	IN	A	192.168.16.62
m1	600	IN	A	192.168.12.70
m2	600	IN	A	192.168.12.135
atom	600	IN	A	172.16.0.4
