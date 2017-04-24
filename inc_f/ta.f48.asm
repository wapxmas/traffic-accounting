;;log_by_each_proto;
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_each_proto_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_EACH_PROTO
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_each_proto
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_each_proto:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_log_by_each_proto
	call	add_to_timer_f
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LOG_BY_EACH_PROTO
	jz	.nex_1
	sub	al,(MAXPC_LOG_BY_EACH_PROTO-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
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
	call	inc_by_proto
    .ex:
	;;;
	ret
.first	db	0
inc_by_proto:
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LB_PROTO_EACH
	call	find_in_db
	jc	.lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx_1
	    call to_zero
	    lodsb ;protocol
	    cmp al,byte[packet.protocol]
	    jz .do_inc
    .nx_1:
	mov	esi,ebx
	jmp short .lpf
    .do_inc:
	call	increment_packet
	;;;
	ret
    .lpe:	;;ADD TO;
	mov	edi,main_buffer
	mov	eax,dword[current.nfunc]
	stosd
	mov	esi,packet.dev
	call	strcat_z
	push	edi
	    mov edi,packet.dev
	    call strlen_z
	    mov ebp,ecx
	pop	edi
	mov	al,byte[packet.protocol]
	stosb
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	push	edi
	rep	movsb
	pop	esi
	call	increment_packet
	mov	esi,main_buffer
	mov	dl,DB_ID_LB_PROTO_EACH
	mov	ecx,pktypes_inc_l+1+4
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
	
on_timer_log_by_each_proto:
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_each_proto_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_EACH_PROTO
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lbe_proto_timer
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_lbe_proto_timer:
	mov	dword[.nfunc],ecx
	lodsb
	sub	al,MAXPC_LOG_BY_EACH_PORT
	jz	.nx
	js	.nx
	mov	eax,err_sPC
	call	write
	call	@exit		
    .nx:
	mov	dword[.protoSaddr], esi
	call	NSkipProto
	mov	dword[.flSaddr], esi
	mov	eax,93
	mov	esi,dword[.flSaddr]
	mov	ebx,dword[esi]
	sub	ecx,ecx
	int	0x80
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LB_PROTO_EACH
	call	find_in_db
	jc	.lpe
	    push ebx
		lodsd
		sub eax,dword[.nfunc]
		jnz .do_nxI
		mov dword[.tmp_e],esi
		call to_zero
		lodsb
		mov	byte[.protocol],al
		mov	dword[.tmp_c],esi
		call	a_str_2lbe_protocol
	.do_nxI:
	    pop	ebx
	mov	esi,ebx
	jmp short .lpf
    .lpe:	;;exit;
	;;;
	ret
.protoSaddr	dd	0
.flSaddr	dd	0
.protocol	db	0
.tmp_e		dd	0
.tmp_c		dd	0
.nfunc		dd	0

a_str_2lbe_protocol:
	mov	esi,dword[do_lbe_proto_timer.flSaddr]
	lodsd
	mov	dword[.fd], eax
	mov	edi,main_buffer
	mov	esi,dword[do_lbe_proto_timer.tmp_e]
	call	strcat
	mov	al,byte[spec_ch]
	stosb
	 mov eax,"prot"
	 stosd
	 mov ax,"o:"
	 stosw	
	movzx	eax,byte[do_lbe_proto_timer.protocol]
	call	d2s
	dec	edi
	mov	esi,dword[do_lbe_proto_timer.tmp_c]
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