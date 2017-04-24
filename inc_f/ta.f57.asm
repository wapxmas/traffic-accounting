;;log_by_eproto_eip;	
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_eproto_eip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_EPROTO_EIP
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_eproto_eip
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_eproto_eip:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_log_by_eproto_eip
	call	add_to_timer_f	
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LOG_BY_EPROTO_EIP
	jz	.nex_1
	sub	al,(MAXPC_LOG_BY_EPROTO_EIP-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	call	NSkipIP
	call	NSkipProto
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
	call Qallow_ipN
	jc .ex
	call QallowSN
	test byte[QallowSN.fl],1
	jz .ex	
	call NSkipFile
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	.ex
	test	byte [Qallow_ipN.dst],1
	jz	.tsrc
	setz	byte[inc_by_eproto_eip.type]
	mov	eax,dword[packet.da]
	bswap	eax
	call	inc_by_eproto_eip
    .tsrc:	
		test	byte [Qallow_ipN.src],1
		jz	.ex		
		setnz	byte[inc_by_eproto_eip.type]
		mov	eax,dword[packet.sa]
		bswap	eax
		call	inc_by_eproto_eip
    .ex:
	;;;
	ret
.first		db	0
.protocol	db	0
.st	db	0
.tpsrc	db	0

inc_by_eproto_eip:
	mov	dword[.addr], eax
	mov	esi,dword[name_esi_tmp]
	call	NSkipIP
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LB_EPROTO_EIP
	call	find_in_db
	jc	.lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx
	    call to_zero	    
	    lodsb
	    cmp al,byte[packet.protocol]
	    jnz .nx	    
	    lodsd
	    cmp eax,dword[.addr]
	    jz	.do_inc
    .nx:
	mov	esi,ebx
	jmp short .lpf
    .do_inc:
	mov	al,byte[.type]
	call	inc_packet_by_type
	;;;
	ret
    .lpe:	;;ADD TO;
	mov	edi,main_buffer
	mov	eax,dword[current.nfunc]
	stosd
	mov	esi,packet.dev
	mov	edx,edi
	call	strcat_z
	 mov ecx,edi
	 sub ecx,edx
	 mov ebp,ecx
	mov	al,byte[packet.protocol]
	stosb
	mov	eax,dword[.addr]
	stosd
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	push	edi
	rep	movsb
	pop	esi
	mov	al,byte[.type]
	call	inc_packet_by_type
	mov	esi,main_buffer
	mov	dl,DB_ID_LB_EPROTO_EIP
	mov	ecx,pktypes_inc_l+1+4+4
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
.addr	 dd	0	    
.SvProto dd	0
.type	 db	0
on_timer_log_by_eproto_eip:
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_eproto_eip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_EPROTO_EIP
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lbp_each_timer_eproto
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret	
do_lbp_each_timer_eproto:
	mov	dword[.nfunc],ecx
	lodsb
	sub	al,MAXPC_LOG_BY_PROTO_IP_EACH
	je	.nx
	js	.nx
	mov	eax,err_sPC
	call	write
	call	@exit		
    .nx:	
	mov	dword[.ipSaddr],esi
	call	NSkipIP
	call	NSkipProto
	mov	dword[.flSaddr],esi
	mov	eax,93
	mov	esi,dword[.flSaddr]
	mov	ebx,dword[esi]
	sub	ecx,ecx
	int	0x80
	
	mov	esi,start_table
	mov	al,byte[packet.protocol]
	mov	byte[.tproto],al
    .lpf:
	mov	dl,DB_ID_LB_EPROTO_EIP
	call	find_in_db
	jc	near .lpe
	    push ebx
		lodsd
		sub eax,dword[.nfunc]
		jnz .do_nxI
		mov dword[.tmp_e],esi
		call to_zero
		lodsb
		mov byte[.protocol],al
		lodsd
		mov	dword[.tmp_b],eax
		bswap	eax
		mov	dword[.tmp_c],esi
		call	a_str_2lbp_eip_eproto
	.do_nxI:
	    pop	ebx
	mov	esi,ebx
	jmp .lpf
    .lpe:	;;exit;
	;;;
	ret
.ipSaddr	dd	0
.flSaddr	dd	0
.tmp_a		dd	0
.tmp_b		dd	0
.tmp_c		dd	0
.tmp_d		dd	0
.tmp_e		dd	0
.tmp_f		dd	0
.tproto		db	0
.protocol	db	0
.nfunc		dd	0

a_str_2lbp_eip_eproto:
	mov	esi,dword[do_lbp_each_timer_eproto.flSaddr]
	lodsd
	mov	dword[.fd], eax
	mov	edi,main_buffer
	mov	esi,dword[do_lbp_each_timer_eproto.tmp_e]
	call	strcat
	mov	al,byte[spec_ch]
	stosb
	mov	ebx,dword[do_lbp_each_timer_eproto.tmp_b]
	call 	ipn2s
	dec 	edi
	mov	al,byte[spec_ch]
	stosb
	 mov eax,"prot"
	 stosd
	 mov ax,"o:"
	 stosw
	movzx	eax,byte[do_lbp_each_timer_eproto.protocol]
	call	d2s
	dec edi
	mov	esi,dword[do_lbp_each_timer_eproto.tmp_c]
	call	generate_log2
	mov	ax,0x000A
	stosw
	mov	edi,main_buffer
	call	strlen
	mov	edx,ecx
	mov	eax,4
	mov	ebx,dword[.fd]
	mov	ecx,main_buffer
	int	0x80		
	;;;
	ret
.fd	dd	0
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>