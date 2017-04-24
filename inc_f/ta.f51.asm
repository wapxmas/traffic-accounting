;;log_by_eport_eip;
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_eport_eip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_EPORT_EIP
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_eport_eip
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_eport_eip:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_log_by_eport_eip
	call	add_to_timer_f
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LOG_BY_PORT_IP_EACH
	jz	.nex_1
	sub	al,(MAXPC_LOG_BY_PORT_IP_EACH-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	lodsd
	call	NSkipIP
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
	jnz near .ex
	call Qallow_ipN
	jc near .ex	
	mov bl,[packet.protocol]
	push esi
	  call gp_by_proto
	pop esi
	call QallowPortN
	test byte[QallowPortN.fl],1
	jz near .ex	
	call NSkipFile
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	near .ex
	setz	byte[inc_by_eport_eip.type]
	test	byte [QallowPortN.dst],1
	jz	.do_inc_src
	mov	bx,word[QallowPortN.dp]
	mov	eax,dword[packet.da]
	bswap	eax
	call	inc_by_eport_eip
    .do_inc_src:
	test	byte [QallowPortN.src],1
	jz	.ex
	setnz	byte[inc_by_eport_eip.type]
	mov	bx,word[QallowPortN.sp]
	mov	eax,dword[packet.da]
	bswap	eax
	call	inc_by_eport_eip
    .ex:
	;;;
	ret
.first		db	0
.protocol	db	0
.st	db	0
.tpsrc	db	0
inc_port_packet_by_type:
	dec al
	js .dst
	mov al,byte[packet.ptype]
	push eax
	mov byte[packet.ptype],PACKET_OUTGOING
	call increment_packet
	pop eax
	mov byte[packet.ptype],al
	;;;
	ret
    .dst:
	mov al,byte[packet.ptype]
	push eax
	mov byte[packet.ptype],PACKET_HOST
	call increment_packet
	pop eax
	mov byte[packet.ptype],al	
	;;;
	ret
inc_by_eport_eip:	
	mov	dword[.addr],eax
	mov	word[.port],bx
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBEP_EIP
	call	find_in_db
	jc	.lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx
	    call to_zero
	    lodsb ;;protocol
	    cmp al,byte[do_log_by_eport_eip.protocol]
	    jnz .nx
	    lodsd
	    cmp dword[packet.sa],eax
	    jnz .nx
	    lodsd
	    cmp dword[packet.da],eax
	    jnz .nx
	    lodsw
	    cmp ax,word[.port]
	    jz .do_inc	    
    .nx:
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
	push	edi
	 call	strcat_z
	pop	eax
	 mov ecx,edi
	 sub ecx,eax
	 mov ebp,ecx
	mov	al,byte[do_log_by_eport_eip.protocol]
	stosb
	mov	eax,dword[packet.sa]
	stosd
	mov	eax,dword[packet.da]
	stosd
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
	mov	dl,DB_ID_LBEP_EIP
	mov	ecx,pktypes_inc_l+1+4+2+4+4
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
.addr	dd	0	    
.SvPort	dd	0
.port	dw	0
.type	db	0	    
on_timer_log_by_eport_eip:
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_eport_eip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_EPORT_EIP
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lbep_eip_timer
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret	
do_lbep_eip_timer:
	mov	dword[.nfunc],ecx
	lodsb
	sub	al,MAXPC_LOG_BY_EPORT_EIP
	jz	.nx
	js	.nx
	mov	eax,err_sPC
	call	write
	call	@exit
    .nx:    			
	lodsd
	mov	byte[.protocol],al
	mov	dword[.ipSaddr], esi
	 call	NSkipIP
	mov	dword[.ptSaddr], esi
	 call	NSkipPort
	mov	dword[.flSaddr],esi
	mov	eax,93
	mov	esi,dword[.flSaddr]
	mov	ebx,dword[esi]
	sub	ecx,ecx
	int	0x80
	
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBEP_EIP
	call	find_in_db
	jc	near .lpe
	    push ebx
		lodsd
		sub eax,dword[.nfunc]
		jnz .do_nxI
		mov dword[.tmp_e],esi
		call to_zero
		lodsb
		cmp	al,byte[.protocol]
		jnz	.do_nxI
		lodsd
		bswap	eax
		mov	dword[.tmp_b],eax		
		lodsd
		bswap	eax
		mov	dword[.tmp_f],eax		
		lodsw
		mov	word[.port],ax
		mov	dword[.tmp_c],esi
		call	a_str_2lbep_eip
	.do_nxI:
	    pop	ebx
	mov	esi,ebx
	jmp .lpf
    .lpe:	;;exit;
	;;;
	ret
.nfunc		dd	0
.ipSaddr	dd	0
.flSaddr	dd	0
.ptSaddr	dd	0
.tmp_a		dd	0
.tmp_b		dd	0
.tmp_c		dd	0
.tmp_d		dd	0
.tmp_e		dd	0
.tmp_f		dd	0
.protocol	db	0
.port		dw	0

a_str_2lbep_eip:
	mov	esi,dword[do_lbep_eip_timer.flSaddr]
	lodsd
	mov	dword[.fd], eax
	mov	edi,main_buffer
	mov	esi,dword[do_lbep_eip_timer.tmp_e]
	call	strcat
	mov	al,byte[spec_ch]
	stosb
	mov	ebx,dword[do_lbep_eip_timer.tmp_b]
	call 	ipn2s
	dec 	edi
	mov	ax,'->'
	stosw
	mov	ebx,dword[do_lbep_eip_timer.tmp_f]
	call 	ipn2s
	dec 	edi	
	mov	al,byte[spec_ch]
	stosb
	movzx	eax,byte[do_lbep_eip_timer.protocol]
	call	d2s
	dec	edi
	mov	al,'#'	
	stosb
	movzx	eax,word[do_lbep_eip_timer.port]
	call	d2s
	dec	edi
	mov	esi,dword[do_lbep_eip_timer.tmp_c]
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