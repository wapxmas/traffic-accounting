;;bin_stat_by_dev();
	sub	ecx,ecx
    .lp:
	mov	esi,bin_stat_by_dev_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_BIN_STAT_BY_DEV
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_bin_stat_bd
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_bin_stat_bd:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_BIN_STAT_BY_DEV
	jz	.nex_1
	sub	al,(MAXPC_BIN_STAT_BY_DEV-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	call	NSkipEnum
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
	lodsb
	movzx	ebx,al
    .lp:
	mov	edi,packet.dev
	call	strcmp
	jecxz	.log
	call	to_zero
	dec	ebx
	jnz	.lp
	;;;
	ret
    .log:
	dec	ebx
	jz	.nxl
	    .lp2:
		call to_zero
		dec	ebx
		jnz	.lp2
    .nxl:
	lodsd
	mov	dword[.fd],eax
	call	to_zero
	movzx	ebx,byte[packet.ptype]
	call	typeexists
	or	bh,bh
	jz	.ex
	mov	edi,stat_buffer.s2
	call	add_bin_gstat
	mov	edx,ecx
	mov	ebx,dword[.fd]
	mov	ecx,stat_buffer.s2
	call	add_traffic
    .ex:
	;;;
	ret
.fd	dd	0
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	