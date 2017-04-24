STRUC udphdr
	.source resw 1
	.dest	resw 1
	.len	resw 1
	.check	resw 1	
ENDSTRUC
STRUC tcphdr
	.source 	resw 1
	.dest 		resw 1
	.seq 		resd 1
	.ack_seq 	resd 1
	.doff		resb 1	;length first 7-4 bist, in 32 bit octets
	.flags		resb 1
				;cwr:1 bit 7
				;ece:1
				;urg:1
				;ack:1
				;psh:1
				;rst:1
				;syn:1
				;fin:1 bit 0
	.window		resw 1
	.check		resw 1
	.urg_ptr	resw 1
ENDSTRUC
STRUC iphdr
	.ihl 		resb 1	;version 7-4 bits, lenght in 32 bits, blocks 3-0 bits.
	.tos 		resb 1
	.tot_len	resw 1
	.id 		resw 1
	.frag_off 	resw 1
	.ttl 		resb 1
	.protocol 	resb 1
	.check 		resw 1
	.saddr 		resd 1
	.daddr 		resd 1
ENDSTRUC
