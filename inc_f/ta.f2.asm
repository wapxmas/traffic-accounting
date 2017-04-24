;;stat_global;
	sub	ecx,ecx
    .lp:
	mov	esi,stat_global_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_STAT_GLOBAL
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_stat_gb
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
;;input edi=*buffer;
ptype:
	mov	ah,byte[packet.ptype]
	mov	esi,host_pack_types
	or	ah,ah
	jz	.pt
    .lp:
	lodsb
	or	al,al
	jnz	.lp
	lodsb
	or	al,al
	jz	.pt
	dec	esi
	dec	ah
	jnz	.lp
    .pt:
	push	edi
	mov	edi,esi
	call	strlen
	pop	edi
	rep	movsb
	;;;
	ret
host_pack_types:
	    db	"input",0
	    db	"broadcast",0
	    db	"multicast",0
	    db	"forward",0
	    db	"output",0
	    db	0
	    db	"unknown",0
do_stat_gb:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_STAT_GLOBAL
	jz	.nex_1	
	sub	al,(MAXPC_STAT_GLOBAL-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	mov	dword[file_estart], esi
	call	NSkipFile
	call	NSkipEnum
	mov	dword[name_deny_addr],esi
	pop	esi
	mov	dword[some_f_name_deny],0
	mov	esi,dfuncs_ntable
	call	run_f
	test	dword[some_f_name_deny],1
	jz	.next
	;;;
	ret	
    .next:
	mov	esi,dword[name_esi_tmp]
	lodsd
	mov dword[.fd],eax
	call to_zero
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	.ex
	mov	edi,stat_buffer.s1
	call	add_gstat
	mov	edi,stat_buffer.s1
	call	strlen
	mov	edx,ecx
	mov	ebx,dword[.fd]
	mov	ecx,stat_buffer.s1
	call	add_traffic
    .ex:
	;;;
	ret
.fd	dd	0
add_gstat:
	;push	esi	    
	    mov	esi,packet.dev
	    call strcat
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"s:"
	     stosw	    
	    mov	ebx,dword[packet.sa]
	    bswap ebx
	    call ipn2s
	    dec	edi
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"d:"
	     stosw
	    mov	ebx,dword[packet.da]
	    bswap ebx
	    call ipn2s
	    dec edi
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"l:"
	     stosw	    
	    mov	eax,dword[packet.len]
	    call d2s
	    dec edi
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"t:"
	     stosw	    
	    call ptype
	    cmp dword[use_time_stamp],0
	    je	.nxti
	    mov al,byte[spec_ch]
	    stosb
	    mov	eax,13
	    sub	ebx,ebx
	    int	0x80
	    call d2s
	    dec	edi
	.nxti:
	    mov al,0xA
	    stosb
	    sub	al,al
	    stosb
	;pop	esi
	;;;
	ret
use_time_stamp	dd	0
;;INPUT edi=*buffer, ebx=ipNUM;
ipn2s:
	mov	ecx,4
    .lp:
	sub	eax,eax
	push	ecx
	mov	cl,8
	shld	eax,ebx,cl
	shl	ebx,cl
	    push ebx
		call	d2s
	    pop	ebx
	pop	ecx
	cmp	ecx,1
	jnz	.next
	    ;;;
	    ret
    .next:
	dec	edi
	mov	al,'.'
	stosb	
	dec	ecx
	jnz	.lp
	;;;
	ret
err_sPC:
	db	"Error: parameter count is wrong",0x0A,0
	
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>