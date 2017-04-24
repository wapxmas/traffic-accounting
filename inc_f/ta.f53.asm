;;log_by_ip_local;
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_ip_local_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_IP_LOCAL
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_ip_local
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_ip_local:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_log_by_ip_local
	call	add_to_timer_f	
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LOG_BY_IP_LOCAL
	jz	.nex_1
	sub	al,(MAXPC_LOG_BY_IP_LOCAL-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	call	NSkipIP
	mov	dword[file_estart],esi
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
	call	Qallow_ipN
	jc .ex
	call NSkipFile
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	.ex
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LOG_BIP_LOCAL
	call	find_in_db
	jc	.lpe
	lodsd
	sub	eax,dword[current.nfunc]
	jz	.innc
    .nx1:
	mov	esi,ebx
	jmp short .lpf
    .innc:
	call	to_zero
	call	to_zero
	call	increment_packet
    .ex:
	;;;
	ret
    .lpe:	;;ADD TO;
		;pktypes_inc
	mov	edi,main_buffer
	mov	eax,dword[current.nfunc]
	stosd
	mov	edx,edi
	mov	esi,process.dev
	call	strcat_z
	mov	ebp,edi
	sub	ebp,edx
	mov	esi,dword[name_esi_tmp]
	push	edi
	call	ip_ranges_to_str
	pop	eax
	 mov ecx,edi
	 sub ecx,eax
	 add ebp,ecx
	push	edi
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	rep	movsb
	pop	esi
	call	increment_packet
	mov	ecx,ebp
	add	ecx,pktypes_inc_l+4+4
	mov	esi,main_buffer
	mov	dl,DB_ID_LOG_BIP_LOCAL
	call	add_to_db
	;;;
	ret
.first	db	0
.st	db	0
on_timer_log_by_ip_local:
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_ip_local_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_IP_LOCAL
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_ip_timer_local
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_ip_timer_local:
	mov	dword[.nfunc],ecx
	lodsb
	mov	dword[.esi_tmp],esi
	call ciplp
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LOG_BIP_LOCAL
	call	find_in_db
	jc	near .lpe
	lodsd
	sub	eax,dword[.nfunc]
	jz	.innc
    .nx1:
	mov	esi,ebx
	jmp short .lpf
    .innc:
	mov	dword[.dev],esi
	call	to_zero
	push	esi
	mov	esi,dword[.esi_tmp]
	call	NSkipIP
	mov	eax,dword[esi]
	mov	dword[.fd],eax
	mov	edi,main_buffer
	mov	esi,dword[.dev];packet.dev
	call	strcat
	mov	al,byte[spec_ch]
	stosb
	pop	esi
	call	generate_log
	sub	al,al
	stosb
	mov	eax,93
	mov	ebx,dword[.fd]
	sub	ecx,ecx
	int	0x80	
	mov	edi,main_buffer
	call	strlen
	mov	edx,ecx
	mov	eax,4
	mov	ebx,dword[.fd]
	mov	ecx,main_buffer
	int	0x80	
    .ex:
	;;;
	ret
    .lpe:	;;ADD TO;
	;;;
	ret
.esi_tmp	dd	0
.fd		dd	0
.dev		dd	0
.nfunc		dd	0
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>