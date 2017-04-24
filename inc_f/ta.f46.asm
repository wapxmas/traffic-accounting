;;log_by_each_port;
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_each_port_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_EACH_PORT
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_each_port
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_each_port:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_log_by_each_port
	call	add_to_timer_f
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LOG_BY_EACH_PORT
	jz	.nex_1
	sub	al,(MAXPC_LOG_BY_EACH_PORT-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	lodsd	;protocol	
	call	NSkipPort
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
	lodsd
	mov byte[.protocol],al
	cmp al,[packet.protocol]
	jnz .ex
	push esi
	  mov bl,al
	  call gp_by_proto
	pop esi	
	call QallowPortN
	test byte[QallowPortN.fl],1
	jz .ex
	call NSkipFile
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	.ex
	test	byte [QallowPortN.dst],1
	jz	.tsrc
	setz	byte[inc_by_port.type]
	mov	ax,word[gp_by_proto.dport]	
	call	inc_by_port
    .tsrc:	
		test	byte[QallowPortN.src],1
		jz	.ex
		setnz	byte[inc_by_port.type]
		mov	ax,word[gp_by_proto.sport]
		call	inc_by_port
    .ex:
	;;;
	ret
.first	db	0
.st	db	0
.tpsrc	db	0
.protocol	db	0
inc_by_port:
	mov	word[.port],ax
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBE_PORT
	call	find_in_db
	jc	.lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .do_next_part
	    call to_zero
	    inc esi
	    lodsw
	    cmp ax,word[.port]
	    jz	.do_inc
    .do_next_part:
	mov	esi,ebx
	jmp short .lpf
    .do_inc:
	mov	al,byte[.type]
	call	inc_port_packet_by_type
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
	mov	al,byte[do_log_by_each_port.protocol]
	stosb
	mov	ax,word[.port]
	stosw
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	push	edi
	rep	movsb
	pop	esi
	mov	al,byte[.type]
	call	inc_port_packet_by_type	
	mov	esi,main_buffer
	mov	dl,DB_ID_LBE_PORT
	mov	ecx,pktypes_inc_l+3+4
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
.port	dw	0
.type	db	0
on_timer_log_by_each_port:
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_each_port_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_EACH_PORT
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lbe_port_timer
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_lbe_port_timer:
	mov	dword[.nfunc],ecx
	lodsb
	sub	al,MAXPC_LOG_BY_EACH_PORT
	jz	.nx
	js	.nx
	mov	eax,err_sPC
	call	write
	call	@exit		
    .nx:
	lodsd
	mov	byte[.protocol],al
	call	NSkipPort
	mov	dword[.flSaddr], esi
	mov	eax,93
	mov	esi,dword[.flSaddr]
	mov	ebx,dword[esi]
	sub	ecx,ecx
	int	0x80
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBE_PORT
	call	find_in_db
	jc	.lpe
	    push ebx
		lodsd
		sub eax,dword[.nfunc]
		jnz .do_nxI
		mov dword[.tmp_e],esi
		call to_zero
		inc esi
		lodsw
		mov	dword[.tmp_c],esi
		mov	word[.tmp_b],ax
		call	a_str_2lbe_port
	.do_nxI:
	    pop	ebx
	mov	esi,ebx
	jmp short .lpf
    .lpe:	;;exit;
	;;;
	ret
.portSaddr	dd	0
.flSaddr	dd	0
.tmp_a		dd	0
.tmp_b		dw	0
.tmp_c		dd	0
.tmp_d		dd	0
.tmp_e		dd	0
.protocol	db	0
.nfunc		dd	0

a_str_2lbe_port:
	mov	esi,dword[do_lbe_port_timer.flSaddr]
	lodsd
	mov	dword[.fd], eax
	mov	edi,main_buffer
	mov	esi,dword[do_lbe_port_timer.tmp_e]
	call	strcat
	mov	al,byte[spec_ch]
	stosb
	movzx	eax,byte[do_lbe_port_timer.protocol]
	call	d2s
	dec	edi
	mov	al,'#'
	stosb
	movzx	eax,word[do_lbe_port_timer.tmp_b]
	call d2s
	dec edi
	mov	esi,dword[do_lbe_port_timer.tmp_c]
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