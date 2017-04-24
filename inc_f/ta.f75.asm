;;func_lm_by_eport_eip;
	sub	ecx,ecx
    .lp:
	mov	esi,lm_by_eport_eip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LM_BY_EPORT_EIP
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lm_by_eport_eip
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_lm_by_eport_eip:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LM_BY_EPORT_EIP
	jz	.nex_1
	sub	al,(MAXPC_LM_BY_EPORT_EIP-1)
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
	mov dword[limit_def.sh],esi
	call to_zero
	mov	byte[inc_by_eport_eip_limit.type],0
	test	byte [QallowPortN.dst],1
	jz	.do_inc_src
	mov	bx,word[QallowPortN.dp]
	mov	eax,dword[packet.da]
	bswap	eax
	call	inc_by_eport_eip_limit
    .do_inc_src:
	test	byte [QallowPortN.src],1
	jz	.ex
	setnz	byte[inc_by_eport_eip_limit.type]
	mov	bx,word[QallowPortN.sp]
	mov	eax,dword[packet.da]
	bswap	eax
	call	inc_by_eport_eip_limit
    .ex:
	;;;
	ret
.first		db	0
.protocol	db	0
.st	db	0
.tpsrc	db	0

inc_by_eport_eip_limit:	
	mov	dword[.addr],eax
	mov	word[.port],bx
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_EPR_LIMIT_EIP
	call	find_in_db
	jc	near .lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx
	    mov	dword[.la],esi
	    call NSkipLM
	    mov	dword[limit_def.in],esi
	    call to_zero
	    lodsb ;;protocol
	    cmp al,byte[do_lm_by_eport_eip.protocol]
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
	mov edi,limit_buffer
	mov al,'S'
	stosb
	mov ebx,dword[packet.sa]
	bswap ebx
	call ipn2s
	dec edi
	mov ax,'-D'
	stosw
	mov ebx,dword[packet.da]
	bswap ebx
	call ipn2s
	mov	dword[limit_def.ip],limit_buffer
	movzx	eax,word[.port]
	mov	dword[limit_def.op],edi
	call	d2s
	movzx	eax,byte[do_lm_by_eport_eip.protocol]
	mov	dword[limit_def.pr],eax
	mov	al,byte[.type]
	mov	dword[.ca],esi
	call	inc_port_packet_by_type
	mov	eax,dword[.ca]
	mov	ebx,dword[.la]
	mov	word[limit_def.lt],'PC'
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
	mov 	edx,edi
	call	strcat_z
	 mov ecx,edi
	 sub ecx,edx
	 add ebp,ecx
	mov	al,byte[do_lm_by_eport_eip.protocol]
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
	mov	dl,DB_ID_EPR_LIMIT_EIP
	mov	ecx,pktypes_inc_l+1+4+2+4+4
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
.addr	dd	0	    
.SvPort	dd	0
.port	dw	0
.type	db	0	    
.la	dd	0
.ca	dd	0
