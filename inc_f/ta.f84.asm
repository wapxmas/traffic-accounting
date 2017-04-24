;;func_full_log_by_each_ip;
	sub	ecx,ecx
    .lp:
	mov	esi,full_log_by_each_ip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_FULL_LOG_BY_EACH_IP
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_full_log_by_eip
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_full_log_by_eip:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_full_log_by_eip
	call	add_to_timer_f
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_FULL_LOG_BY_EACH_IP
	jz	.nex_1
	sub	al,(MAXPC_FULL_LOG_BY_EACH_IP-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	call	NSkipIP
	call	NSkipFile
	call	NSkipEnum
	mov	dword[name_deny_addr],esi
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
	jc near .ex
	call NSkipFile
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	near .ex
	setz	byte[full_inc_by_eip.type]
	test	byte [Qallow_ipN.dst],1
	jz	.do_inc_src
	call	full_inc_by_eip
    .do_inc_src:
	test	byte [Qallow_ipN.src],1
	jz	.ex
	setnz	byte[full_inc_by_eip.type]
	call	full_inc_by_eip
    .ex:
	;;;
	ret
.first		db	0
.protocol	db	0
.st	db	0
.tpsrc	db	0
full_inc_by_eip:	
	mov	dword[.addr],eax
	mov	word[.port],bx
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_FULL_LBEP_EIP
	call	find_in_db
	jc	.lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx
	    call to_zero
	    lodsd
	    cmp dword[packet.sa],eax
	    jnz .nx
	    lodsd
	    cmp dword[packet.da],eax
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
	mov	edx,edi
	call	strcat_z
	 mov ecx,edi
	 sub ecx,edx
	 mov ebp,ecx
	mov	eax,dword[packet.sa]
	stosd
	mov	eax,dword[packet.da]
	stosd
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	push	edi
	rep	movsb
	pop	esi
	mov	al,byte[.type]
	call	inc_port_packet_by_type
	mov	esi,main_buffer
	mov	dl,DB_ID_FULL_LBEP_EIP
	mov	ecx,pktypes_inc_l+4+4+4
	add	ecx,ebp
	call	add_to_db
	
	;;;
	ret
.addr	dd	0	    
.SvPort	dd	0
.port	dw	0
.type	db	0	    
on_timer_full_log_by_eip:
	sub	ecx,ecx
    .lp:
	mov	esi,full_log_by_each_ip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_FULL_LOG_BY_EACH_IP
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_full_lbep_eip_timer
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret	
do_full_lbep_eip_timer:
	mov	dword[.nfunc],ecx
	lodsb
	sub	al,MAXPC_FULL_LOG_BY_EACH_IP
	jz	.nx
	js	.nx
	mov	eax,err_sPC
	call	write
	call	@exit
    .nx:
	call	NSkipIP
	mov	dword[.flSaddr],esi
	mov	eax,93
	mov	esi,dword[.flSaddr]
	mov	ebx,dword[esi]
	sub	ecx,ecx
	int	0x80
	
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_FULL_LBEP_EIP
	call	find_in_db
	jc	near .lpe
	    push ebx
		lodsd
		sub eax,dword[.nfunc]
		jnz .do_nxI
		mov dword[.tmp_e],esi
		call to_zero
		lodsd
		bswap	eax
		mov	dword[.tmp_b],eax		
		lodsd
		bswap	eax
		mov	dword[.tmp_f],eax		
		mov	dword[.tmp_c],esi
		call	.full_a_str_2lbep_eip
	.do_nxI:
	    pop	ebx
	mov	esi,ebx
	jmp .lpf
    .lpe:	;;exit;
	;;;
	ret
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
.nfunc		dd	0

.full_a_str_2lbep_eip:
	mov	esi,dword[.flSaddr]
	lodsd
	mov	dword[.fd], eax
	mov	edi,main_buffer
	mov	esi,dword[.tmp_e]
	call	strcat
	mov	al,byte[spec_ch]
	stosb
	mov	ebx,dword[.tmp_b]
	call 	ipn2s
	dec 	edi
	mov	ax,'->'
	stosw
	mov	ebx,dword[.tmp_f]
	call 	ipn2s
	dec 	edi	
	;mov	al,byte[spec_ch]
	;stosb
	mov	esi,dword[.tmp_c]
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
