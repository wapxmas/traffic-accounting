;;log_by_port_ip_each;
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_port_ip_each_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_PORT_IP_EACH
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_port_ip_each
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_port_ip_each:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_log_by_port_ip_each
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
	jc .ex
	mov bl,[packet.protocol]
	push esi
	  call gp_by_proto
	pop esi	
	call QallowPort
	test byte[QallowPort.fl],1
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
	setz	byte[inc_by_port_ip_each.type]
	mov	eax,dword[packet.da]
	bswap	eax
	call	inc_by_port_ip_each
    .tsrc:	
		test	byte [Qallow_ipN.src],1
		jz	.ex		
		setnz	byte[inc_by_port_ip_each.type]
		mov	eax,dword[packet.sa]
		bswap	eax
		call	inc_by_port_ip_each
    .ex:
	;;;
	ret
.first		db	0
.protocol	db	0
.st	db	0
.tpsrc	db	0

inc_by_port_ip_each:
	mov	dword[.addr], eax
	mov	esi,dword[name_esi_tmp]
	lodsd
	call	NSkipIP
	mov	dword[.SvPort],esi	
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBP_IP_EACH
	call	find_in_db
	jc	.lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx
	    call to_zero
	    lodsb ;;protocol
	    cmp al,byte[do_log_by_port_ip_each.protocol]
	    jnz .nx
	    lodsd
	    cmp eax,dword[.addr]
	    jz	.do_inc	    
    .nx:
	mov	esi,ebx
	jmp short .lpf
    .do_inc:
	call	to_zero
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
	pop 	eax
	 mov	ecx,edi
	 sub ecx,eax
	 mov ebp,ecx
	mov	al,byte[do_log_by_port_ip_each.protocol]
	stosb
	mov	eax,dword[.addr]
	stosd
	mov	esi,dword[.SvPort]
	push	edi
	call	port_ranges_to_str
	pop	eax
	 mov ecx,edi
	 sub ecx,eax
	 add ebp,ecx
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	push	edi
	rep	movsb
	pop	esi
	mov	al,byte[.type]
	call	inc_port_packet_by_type	
	mov	esi,main_buffer
	mov	dl,DB_ID_LBP_IP_EACH
	mov	ecx,pktypes_inc_l+4+4+1
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
.addr	dd	0	    
.SvPort	dd	0
.type	db	0
on_timer_log_by_port_ip_each:
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_port_ip_each_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_PORT_IP_EACH
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lbp_each_timer
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret	
do_lbp_each_timer:
	mov	dword[.nfunc],ecx
	lodsb
	sub	al,MAXPC_LOG_BY_PORT_IP_EACH
	je	.nx
	js	.nx
	mov	eax,err_sPC
	call	write
	call	@exit		
    .nx:    		        
	mov	dword[.ipSaddr], esi
	lodsd
	mov	byte[.protocol],al
	call	NSkipIP
	call	NSkipPort
	mov	dword[.flSaddr],esi
	mov	eax,93
	mov	esi,dword[.flSaddr]
	mov	ebx,dword[esi]
	sub	ecx,ecx
	int	0x80
	
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBP_IP_EACH
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
		mov	dword[.tmp_b],eax		
		mov	dword[.tmp_f],esi
		call	to_zero
		mov	dword[.tmp_c],esi
		call	a_str_2lbp_ip_each
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
.nfunc		dd	0
.protocol	db	0

a_str_2lbp_ip_each:
	mov	esi,dword[do_lbp_each_timer.flSaddr]
	lodsd
	mov	dword[.fd], eax
	mov	edi,main_buffer
	mov	esi,dword[do_lbp_each_timer.tmp_e]
	call	strcat
	mov	al,byte[spec_ch]
	stosb
	mov	ebx,dword[do_lbp_each_timer.tmp_b]
	call 	ipn2s
	dec 	edi
	mov	al,byte[spec_ch]
	stosb
	mov	esi,dword[do_lbp_each_timer.tmp_f]
	call	strcat
	mov	esi,dword[do_lbp_each_timer.tmp_c]
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