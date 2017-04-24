;;addons to bss;
server_funcs	resd	SCNT_TYPES
fdset_rd	resb	fd_set_size
fdset_wr	resb	fd_set_size
pfile	resb MAXPATHLEN
buffer_login	resb	BUFSIZE
buffer_ps	resb	BUFSIZE
buffer_input	resb	BUFSIZE
server_packet	resb	MAXSRVPACKLEN

A_MD5	resd	1
B_MD5	resd	1
C_MD5	resd	1
D_MD5	resd	1
LoPart_MD5	resd	1
HiPart_MD5	resd	1
buff1_MD5	resd	16

;

digest_MD5	resd	4		;resulting 128 bit MD5 code
text2_MD5	resd	9		;ascii version of MD5 code

A	resd	1
B	resd	1
C	resd	1
D	resd	1
E	resd	1
LoPart	resd	1
HiPart	resd	1
buff1	resd	16		;calculation buffer

Rounds	resb	(10*16*10)	;to store the expanded Round1 to Round8 tables

;
;internal RC6 key
;
RC6_keys:
l_key	resd	45			
ll	resd	9
len_key_data	equ	$-RC6_keys
;---------------------------------------------------------------------

;ibuffer	resb	FBUFSIZE	;input file buffer

buffer_RC6	resd	BUFSIZE
action	resb	1		;encrypt/decrypt
flength	resd	1

    key1	resd	5
    key2	resd	5
    key	resd	8
