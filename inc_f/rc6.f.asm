;Copyright (C) 1999 Cecchinel Stephan <interzone@pacwan.fr>

;--------------------------------------------------
; parse the given key string, with the Ripemd algo..
; transform it in a 256 bit key to use with RC6...

PROC	parsekey , stringkey
	pusha
	xor	ecx,ecx
	mov	edi,stringkey
.strlen:
	cmp	byte[edi+ecx],1
	inc	ecx
	jnc	.strlen
	dec	ecx
	call	RMD_Init
	mov	ebx,ecx
	shr	ecx,1
	mov	esi,edi
	call	RMD_Update
	push	edi
	mov	edi,key1
	call	RMD_Final
	pop	edi
	mov	edx,ebx
	call	RMD_Init
	mov	ebx,ecx
	test	edx,1
	jz	.suite
	inc	ecx
.suite:
	lea	esi,[edi+ebx]
	call	RMD_Update
	mov	edi,key2
	call	RMD_Final

; compose key with key1 and key2

	mov	esi,key1
	cld
	mov	edi,key
	movsd
	movsd
	movsd
	lodsd
	xor	eax,[esi+4]
	stosd
	lodsd
	xor	eax,[esi+4]
	stosd
	add	esi,byte 8
	movsd
	movsd
	movsd
	popa
ENDP

;
;library functions
;

PROC	RC6_Setkey, in_key, key_len

%define	a dword[ebp-4]			;local vars on the stack
%define	b dword[ebp-8]
%define i dword[ebp-12]
%define j dword[ebp-16]

	sub	esp,byte 16

	mov	edi,l_key
	mov	dword[edi],0x0b7e15163
	xor	ecx,ecx
        inc	ecx
.cpy:
	mov	eax,dword [-4+edi+ecx*4]
	add	eax,0x09e3779b9
	mov	dword [edi+ecx*4],eax
	inc	ecx
	cmp	ecx,byte 44
	jb	.cpy

	xor	ecx,ecx
	mov	esi,in_key
	mov	edx,key_len
	shr	edx,5
.cpy1:
	mov	eax,[esi+ecx*4]
	mov	[edi+ecx*4],eax
	inc	ecx
	cmp	ecx,edx
	jb	.cpy1

        mov	esi,ll			;esi=ll
	dec	edx			;edx=t=(key_len/32)-1
	xor	ecx,ecx			;ecx=k=0
	mov	a,ecx
	mov	b,ecx
	mov	i,ecx
	mov	j,ecx			;a=b=i=j=0
.cpy2:
	push	ecx
	mov	ebx,i
	mov	eax,[edi+ebx*4]
	add	eax,a
	add	eax,b
	rol	eax,3
	add	b,eax			;b+=a
	mov	a,eax			;a=rol(l_key[i]+a+b
	mov	ebx,j
	mov	eax,dword [esi+ebx*4]
	add	eax,b
	mov	ecx,b
	rol	eax,cl
	mov	b,eax			;b=rol(ll[j]+b,b)
	mov	eax,a
	mov	ebx,i
	mov	[edi+ebx*4],eax		;l_key[i]=a
	mov	eax,b
	mov	ebx,j
	mov	[esi+ebx*4],eax		;ll[j]=b
	mov	eax,i
	inc	eax
	cmp	eax,byte 43
	jnz	.s1
	xor	eax,eax
.s1:
	mov	i,eax			;i=i+1 %43

	mov	eax,j
	inc	eax
	cmp	eax,edx
	jnz	.s2
	xor	eax,eax
.s2:
	mov	j,eax
	pop	ecx
	inc	ecx
	cmp	ecx,132
	jb	.cpy2
	mov	eax,edi

	add	esp,byte 16
ENDP


;---------------------------------------
;encrypt:
;
; input:	edi=in_block
;		esi=out_block

PROC RC6_Encrypt, in_block, out_block
	pusha
	mov	esi,out_block
	mov	edi,in_block
	push	esi
	mov	esi,l_key
	mov	eax,[edi]		;a=in_block[0]
	mov	ebx,[edi+4]
	add	ebx,[esi]		;b=in_block[1]+l_key[0]
	mov	ecx,[edi+8]		;c=in_block[2]
	mov	edx,[edi+12]
	add	edx,[esi+4]		;d=in_block[3]+l_key[1]
	lea	ebp,[esi+8]
.boucle:
	lea	esi,[edx+edx+1]
	imul	esi,edx
	rol	esi,5			;u=rol(d*(d+d+1),5)

	lea	edi,[ebx+ebx+1]
	imul	edi,ebx
	rol	edi,5			;t=rol(b*(b+b+1),5)

	push	ecx
	mov	ecx,esi
	xor	eax,edi
	rol	eax,cl
	add	eax,[ebp]		;a=rol(a^t,u)+l_key[i]
	pop	ecx

	push	eax
	xchg	ecx,eax
	mov	ecx,edi
	xor	eax,esi
	rol	eax,cl
	add	eax,[ebp+4]		;c=rol(c^u,t)+l_key[i+1]
	xchg	ecx,eax
	pop	eax

	push	eax
	mov	eax,ebx
	mov	ebx,ecx
	mov	ecx,edx
	pop	edx
	add	ebp,byte 8
	cmp	ebp,(l_key+(42*4))
	jnz	.boucle

	pop	edi
	mov	esi,l_key
	add	eax,[esi+(42*4)]
	mov	[edi],eax
	mov	[edi+4],ebx
	add	ecx,[esi+(43*4)]
	mov	[edi+8],ecx
	mov	[edi+12],edx
	
	popa
ENDP

;---------------------------------------
PROC RC6_Decrypt, in_blk2, out_blk2

	pusha
	mov	esi,out_blk2
	push	esi
	mov	edi,in_blk2
	mov	esi,l_key

	mov	edx,[edi+12]		;d=in_blk[3]
	mov	ecx,[edi+8]
	sub	ecx,[esi+(43*4)]	;c=in_blk[2]-l_key[43]
	mov	ebx,[edi+4]		;b=in_blk[1]
	mov	eax,[edi]
	sub	eax,[esi+(42*4)]	;a=in_blk[0]-l_key[42]
	lea	ebp,[esi+(40*4)]

.boucle2:
	push	edx
	mov	edx,ecx
	mov	ecx,ebx
	mov	ebx,eax
	pop	eax

	lea	esi,[edx+edx+1]
	imul	esi,edx
	rol	esi,5			;u=rol(d*(d+d+1),5)

	lea	edi,[ebx+ebx+1]
	imul	edi,ebx
	rol	edi,5			;t=rol(b*(b+b+1),5)

	push	eax
	xchg	ecx,eax
	mov	ecx,edi
	sub	eax,[ebp+4]
	ror	eax,cl
	xor	eax,esi
	xchg	ecx,eax
	pop	eax

	push	ecx
	mov	ecx,esi
	sub	eax,[ebp]
	ror	eax,cl
	xor	eax,edi
	pop	ecx

	sub	ebp,byte 8
	cmp	ebp,l_key
	jnz	.boucle2

	mov	esi,ebp
	pop	edi
	sub	edx,[esi+4]
	mov	[edi+12],edx		;out_blk[3]=d-l_key[1]
	mov	[edi+8],ecx		;out_blk[2]=c
	sub	ebx,[esi]
	mov	[edi+4],ebx		;out_blk[1]=b-l_key[0]
	mov	[edi],eax		;out_blk[0]=a

	popa
ENDP

;
;RMD
;

;size of incoming data buffer
;needs to be fixed for RMD_Final
;needs to be a power of two

%assign	BUFSIZE	0x2000

;magic initialization constants

%assign	_A	0x67452301
%assign	_B	0xefcdab89
%assign	_C	0x98badcfe
%assign	_D	0x10325476
%assign	_E	0xc3d2e1f0

;RMD-160 core constants, bit shifts, offsets
;Never change the order

Round1:	dd FF,0
	db 0,11,1,14,2,15,3,12
	db 4,5,5,8,6,7,7,9
	db 8,11,9,13,10,14,11,15
	db 12,6,13,7,14,9,15,8
Round2:	dd GG,0x5a827999
	db 7,7,4,6,13,8,1,13
	db 10,11,6,9,15,7,3,15
	db 12,7,0,12,9,15,5,9
	db 2,11,14,7,11,13,8,12
Round3:	dd HH,0x6ed9eba1
	db 3,11,10,13,14,6,4,7
	db 9,14,15,9,8,13,1,15
	db 2,14,7,8,0,13,6,6
	db 13,5,11,12,5,7,12,5
Round4:	dd II,0x8f1bbcdc
	db 1,11,9,12,11,14,10,15
	db 0,14,8,15,12,9,4,8
	db 13,9,3,14,7,5,15,6
	db 14,8,5,6,6,5,2,12
Round5:	dd JJ,0xa953fd4e
	db 4,9,0,15,5,5,9,11
	db 7,6,12,8,2,13,10,12
	db 14,5,1,12,3,13,8,14
	db 11,11,6,8,15,5,13,6
Round6:	dd JJJ,0x50a28be6
	db 5,8,14,9,7,9,0,11
	db 9,13,2,15,11,15,4,5
	db 13,7,6,7,15,8,8,11
	db 1,14,10,14,3,12,12,6
Round7:	dd III,0x5c4dd124
	db 6,9,11,13,3,15,7,7
	db 0,12,13,8,5,9,10,11
	db 14,7,15,7,8,12,12,7
	db 4,6,9,15,1,13,2,11
Round8:	dd HHH,0x6d703ef3
	db 15,9,5,7,1,15,3,11
	db 7,8,14,6,6,6,9,14
	db 11,12,8,13,12,5,2,14
	db 10,13,0,13,4,7,13,5
Round9:	dd GGG,0x7a6d76e9
	db 8,15,6,5,4,8,1,11
	db 3,14,11,14,15,6,0,14
	db 5,6,12,9,2,12,13,9
	db 9,12,7,5,10,15,14,8
Round10: dd FFF,0
	db 12,8,15,5,10,12,4,9
	db 1,12,5,5,8,14,7,6
	db 6,8,2,13,13,6,14,5
	db 0,15,3,13,9,11,11,11

;-----------------------------------------
; return:  eax=(b)^(c)^(d)
FF:
FFF:	xor	ecx,ebx
	xor	ecx,edx
	jmp	endf2

;----------------------------------------
; return:  eax= ( (b)&(c) | (~b)&(d) )
%define var	dword [ebp-24]
GGG:
GG:	and	ecx,ebx
	not	ebx
	and	edx,ebx
	or	ecx,edx
	jmp	endf

;----------------------------------------
; return:  eax=( (b)&(d)  |  (c)&(~d) )
III:
II:	and	ebx,edx
	not	edx
	and	ecx,edx
	or	ecx,ebx
	jmp	endf

;------------------------------------------
; return:  (b)^(c)|(~d)
JJJ:
JJ:	not	edx
	or	ecx,edx
	xor	ecx,ebx
	jmp	endf

;------------------------------------------
; II:  return eax=( (b)| ((~c)^(d) )
HHH:
HH:	not	ecx
	or	ecx,ebx
	xor	ecx,edx
endf:	add	ecx,[esi+4]
endf2:	movzx	edx,byte[esi+8]
	add	ecx,[edi+edx*4]
	add	eax,ecx
	mov	cl,byte[esi+9]
	rol	eax,cl
	add	esi,byte 10
	ret

;RMD-160 core hashing function
;
;do the calculation in 5 rounds of 16 calls to in order FF,GG,HH,II,JJ
;then one parallel pass of 5 rounds of 16 calls to JJJ,III,HHH,GGG,FFF  
;don't try to understand the code,
;it extensively uses black magic and Voodoo incantations
;
;input:    edi: buffer to process

%define	ee	dword [ebp-4]		;local vars on the stack
%define	dd	dword [ebp-8]
%define	cc	dword [ebp-12]
%define	bb	dword [ebp-16]
%define	aa	dword [ebp-20]

%define	e	dword [ebp-24]
%define	d	dword [ebp-28]
%define	c	dword [ebp-32]
%define	b	dword [ebp-36]
%define	a	dword [ebp-40]

%define	eee	e
%define	ddd	d
%define	ccc	c
%define	bbb	b
%define	aaa	a

;
;macro for calling the FF,GG,HH,II functions
;

%macro invoke_f 5
	mov	eax,%1
	mov	ebx,%2
	mov	ecx,%3
	mov	edx,%4
	call	dword [esi]
	add	eax,%5
	mov	%1,eax
	rol	%3,10
%endmacro

RMD_Transform:

	pusha
	mov	ebp,esp
	sub	esp,byte 40		;protect the local vars space

	cld
	push	edi
	mov	esi,A
	lea	edi,[ebp-40]
	push	esi
	mov	ecx,5
	push	ecx
	rep	movsd
	pop	ecx			;copy A to E in a-d and aa-dd
	pop	esi
	rep	movsd
	pop	edi

	add	esi,byte (Rounds-LoPart);esi=Rounds

	mov	ecx,2
.round0:
	push	ecx
	mov	ecx,16
.round1:
	push	ecx
	invoke_f	a,b,c,d,e
	invoke_f	e,a,b,c,d
	invoke_f	d,e,a,b,c	;do the jerk
	invoke_f	c,d,e,a,b
	invoke_f	b,c,d,e,a
	pop	ecx
	loop	.round1
	pop	ecx
	add	ebp,byte 20
	dec	ecx
	jnz	near .round0
	sub	ebp,byte 40

	mov	edi,A
	mov	eax,dd
	add	eax,ccc
	add	eax,[edi+4]
	push	eax
	mov	eax,ee
	add	eax,ddd
	add	eax,[edi+8]
	mov	[edi+4],eax
	mov	eax,aa
	add	eax,eee
	add	eax,[edi+12]
	mov	[edi+8],eax
	mov	eax,bb
	add	eax,aaa
	add	eax,[edi+16]
	mov	[edi+12],eax
	mov	eax,cc
	add	eax,bbb
	add	eax,[edi]
	mov	[edi+16],eax
	pop	eax
	mov	[edi],eax	

	add	esp,byte 40
	popa
	ret

;---------------------------------------------
; initialize the RIPEMD-160 engine with the 5 magic constants(_A to _E)
; and clear the LowPart & HighPart counters & the calculation buffer
; then generate the Rounds table from the Round1 to Round8 tables
;
; 1st function to call to calc.RMD160 

RMD_Init:
	pusha
	cld
	mov	edi,A
	mov	eax,_A
	stosd
	mov	eax,_B
	stosd
	mov	eax,_C
	stosd
	mov	eax,_D
	stosd
	mov	eax,_E
	stosd
	xor	eax,eax
	stosd
	stosd
	mov	ecx,16
	rep	stosd			;clear the buffer

;build Rounds table

	mov	esi,Round1
	mov	ecx,10
.in1:	push	ecx
	mov	ebx,[esi]		;get func.
	mov	edx,[esi+4]		;get var.
	add	esi,byte 8
	mov	ecx,16
.in2:	lodsw
	mov	[edi],ebx
	mov	[edi+4],edx
	mov	[edi+8],ax
	add	edi,byte 10
	loop	.in2
	pop	ecx
	loop	.in1

	popa
	ret
%undef	dd
;-----------------------------------------------
; the most of the job is done here
; process ecx bytes from esi input buffer
;
; input:	esi=input
;		ecx=number of bytes
RMD_Update:
	pusha
	mov	edi,esi
	mov	edx,ecx
	shr	ecx,6
	jz	.upd1a	
.upd1:	call	RMD_Transform
	add	edi,byte 64
	loop	.upd1
.upd1a:
	mov	esi,LoPart
	mov	eax,[esi]
	mov	ecx,eax
	add	eax,edx
	cmp	eax,ecx
	jge	.upd2
	inc	dword[esi+4]
.upd2:	mov	[esi],eax
	popa
	ret

;--------------------------------------------------------------------
; finalize the job, and write the resulting 160 bits digest RMD code
; in edi buffer (20 bytes length) 
;
; RMD_Final:
;	input:	edi=digest

RMD_Final:
	pusha
	push	edi

	mov	esi,buffer_RC6
	mov	eax,[LoPart]
	push	eax
	mov	ecx,eax
	mov	edx,eax
	and	eax,(BUFSIZE-64)
	add	esi,eax
	and	ecx,byte 63
	mov	edi,buff1
	push	edi
	rep	movsb

	mov	ebx,edx
	mov	ecx,edx
	shr	edx,2
	and	edx,byte 15
	and	ecx,byte 3
        lea	ecx,[ecx*8+7]
	xor	eax,eax
	inc	eax
	shl	eax,cl
	pop	edi
	xor	[edi+edx*4],eax

	and	ebx,byte 63
	cmp	ebx,byte 55
	jle	.fin2

	call	RMD_Transform
	push	edi
	xor	eax,eax
	mov	ecx, 16
	rep	stosd
	pop	edi
.fin2:
	pop	eax
	shl	eax,3
	mov	[edi+(14*4)],eax
	mov	eax,[HiPart]
	shr	eax,29
	mov	[edi+(15*4)],eax
	call	RMD_Transform

	pop	edi
	mov	ecx,5
	mov	esi,A
	rep	movsd
	popa
	ret
