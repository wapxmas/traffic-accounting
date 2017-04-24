;;deny_dev();
	sub	ecx,ecx
    .lp:
	mov	esi,deny_dev_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_DENY_DEV
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_deny_dev
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_deny_dev:
	lodsb
	cmp	al,MAXPC_DENY_DEV
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	    
    .next:
	lodsb
	movzx	ebx,al
    .lpf:
	mov	edi,packet.dev
	call	strcmp
	jecxz	.log
	call	to_zero
	dec	ebx
	jnz	.lpf
	;;;
	ret
    .log:
	mov	dword[some_f_call_deny],1
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	