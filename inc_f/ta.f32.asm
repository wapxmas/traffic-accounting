;;bin_stat_global;
	sub	ecx,ecx
    .lp:
	mov	esi,bin_stat_global_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_BIN_STAT_GLOBAL
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_bin_stat_gb
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_bin_stat_gb:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_BIN_STAT_GLOBAL
	jz	.nex_1	
	sub	al,(MAXPC_BIN_STAT_GLOBAL-1)
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
	call	add_bin_gstat
	mov	edx,ecx
	mov	ebx,dword[.fd]
	mov	ecx,stat_buffer.s1
	call	add_traffic
    .ex:
	;;;
	ret
.fd	dd	0
add_bin_gstat:
	;push	esi
	    push edi
	    mov edi,packet.dev
	    call strlen
	    pop edi
	    push ecx
	    mov	esi,packet.dev
	    call strcat_z
	    pop ecx
	    add ecx,14
	    mov	eax,dword[packet.sa]
	    ;bswap eax
	    stosd
	    mov	eax,dword[packet.da]
	    ;bswap eax
	    stosd
	    mov	eax,dword[packet.len]
	    stosd
	    mov al,byte[packet.ptype]
	    stosb
	    test byte[use_time_stamp],1
	    jz	.nxti
	    mov al,1	;use time stamp
	    stosb
	    mov	eax,13
	    sub	ebx,ebx
	    int	0x80
	    stosd
	    add ecx,5
	    ;;;
	    ret
	.nxti:
	    sub al,al
	    stosb	;time stamp is not
	    inc ecx
	;pop	esi
	;;;
	ret
.tm	db	0
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	