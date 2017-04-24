;;func_lm_by_port_ip_each;
	sub	ecx,ecx
    .lp:
	mov	esi,lm_by_port_ip_each_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LM_BY_PORT_IP_EACH
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lm_by_port_ip_each
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_lm_by_port_ip_each:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LM_BY_PORT_IP_EACH
	jz	.nex_1
	sub	al,(MAXPC_LM_BY_PORT_IP_EACH-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	call	NSkipLM
	lodsd	;protocol
	call	NSkipIP
	call	NSkipPort
	call	to_zero
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
	call NSkipLM
	lodsd
	mov dword[.pad],esi
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
	mov dword[limit_def.sh],esi
	call to_zero
	test	byte [Qallow_ipN.dst],1
	jz	.tsrc
	setz	byte[inc_by_port_ip_each_limit.type]
	mov	eax,dword[packet.da]
	bswap	eax
	call	inc_by_port_ip_each_limit
    .tsrc:	
		test	byte [Qallow_ipN.src],1
		jz	.ex
		setnz	byte[inc_by_port_ip_each_limit.type]
		mov	eax,dword[packet.sa]
		bswap	eax
		call	inc_by_port_ip_each_limit
    .ex:
	;;;
	ret
.pad 	dd	0
.protocol	db	0
.st	db	0
.tpsrc	db	0

inc_by_port_ip_each_limit:
	mov	dword[.addr], eax
	mov	esi,dword[do_lm_by_port_ip_each.pad]
	call	NSkipIP
	mov	dword[.SvPort],esi
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_PR_LIMIT_IP_EACH
	call	find_in_db
	jc	near .lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx
	    mov	dword[.la],esi
	    call NSkipLM
	    mov	dword[limit_def.in],esi
	    call to_zero
	    inc esi
	    lodsd
	    cmp eax,dword[.addr]
	    jz	.do_inc
    .nx:
	mov	esi,ebx
	jmp short .lpf
    .do_inc:
	mov	dword[limit_def.po],esi
	call	to_zero	
	mov edi,limit_buffer
	mov ebx,dword[.addr]
	call ipn2s
	mov	dword[limit_def.ip],limit_buffer
	movzx	eax,byte[do_lm_by_port_ip_each.protocol]
	mov	dword[limit_def.pr],eax	
	mov	dword[.ca],esi
	mov	al,byte[.type]
	call	inc_port_packet_by_type
	mov	eax,dword[.ca]
	mov	ebx,dword[.la]
	mov	word[limit_def.lt],'PB'
	call	climit
	;;;
	ret
    .lpe:	;;ADD TO;
	mov	edi,main_buffer
	mov	eax,dword[current.nfunc]
	stosd
	mov	esi,dword[name_esi_tmp]
	push esi
	  call	GlmLEN
	pop esi
	mov ebp,ecx
	cld
	rep	movsb	
	mov	esi,packet.dev
	mov	edx,edi
	call	strcat_z
	 mov ecx,edi
	 sub ecx,edx
	 add ebp,ecx
	mov	al,byte[do_lm_by_port_ip_each.protocol]
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
	mov	dl,DB_ID_PR_LIMIT_IP_EACH
	mov	ecx,pktypes_inc_l+4+4+1
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
.addr	dd	0	    
.SvPort	dd	0
.type	db	0
.la	dd	0
.ca	dd	0
