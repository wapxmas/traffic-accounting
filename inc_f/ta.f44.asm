;;priority();
	mov	esi,priority_buffer+5
	push	esi
	    cmp byte[esi],'-'
	    jnz .next
	    setz byte[.ng]
    .next:
	    xor cl,cl
	    call strdec
	pop	esi
	test	byte [.ng],1
	jz	.nx
	neg	ebx
    .nx:
	mov	edx,ebx
	mov	eax,97
	mov	ebx,PRIO_PROCESS
	xor	ecx,ecx
	int	0x80	
	;;;
	ret
.ng	db	0
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	