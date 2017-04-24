;;server errors listing;

srv_e1:
	dd	srv_e1_len;
	db	PTYPE_TIMEOUT;
srv_e1_len	equ	$-srv_e1
srv_e2:
	dd	srv_e2_len;
	db	PTYPE_ERROR;
srv_e2_len	equ	$-srv_e2
srv_e3:
	dd	srv_e3_len;
	db	PTYPE_ERRTP;
srv_e3_len	equ	$-srv_e3
