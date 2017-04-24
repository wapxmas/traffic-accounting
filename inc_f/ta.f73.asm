;;func_lm_by_port_ip;
	sub	ecx,ecx
    .lp:
	mov	esi,lm_by_port_ip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_PORT_IP
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lm_port_ip
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_lm_port_ip:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LM_BY_PORT_IP
	jz	.nex_1
	sub	al,(MAXPC_LM_BY_PORT_IP-1)
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
	lodsd	;protocol
	mov dword[.pad],esi
	mov byte[.protocol],al
	cmp al,byte[packet.protocol]
	jnz .ex
	call Qallow_ipN
	jc .ex	
	mov al,byte[packet.protocol]
	push esi
	  mov bl,al
	  call gp_by_proto
	pop esi
	call QallowPort
	test byte[QallowPort.fl],1
	jnz .nx_port
    .ex:
	;;;
	ret
    .nx_port:	
	mov dword[limit_def.sh],esi
	call to_zero
	mov esi,dword[.pad]
	call ciplp
	call cportlp
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_PR_LIMIT_IP
	call	find_in_db
	jc	near .ad_2table
	lodsd
	sub eax,dword[current.nfunc]
	jz .inc_4port
	mov	esi,ebx
	jmp .lpf
    .inc_4port:
	mov	dword[.la],esi
	call NSkipLM
	mov	dword[limit_def.in],esi
	call	to_zero
	inc esi
	mov	dword[limit_def.ip],esi
	call	to_zero
	mov	dword[limit_def.po],esi
	call	to_zero
	movzx	eax,byte[.protocol]
	mov	dword[limit_def.pr],eax
	mov	dword[.ca],esi	
	call	set_packet_increment
	mov	eax,dword[.ca]
	mov	ebx,dword[.la]
	mov	word[limit_def.lt],'PA'
	call	climit	
	;;;
	ret
    .ad_2table:
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
	mov	edx,edi
	mov	esi,process.dev
	call	strcat_z
	mov	ebx,edi
	sub	ebx,edx
	add	ebp,ebx
	mov	esi,dword[.pad]
	mov	al,byte[.protocol]
	stosb	;protocol
	push	edi
	call	ip_ranges_to_str
	pop	eax
	 mov ecx,edi
	 sub ecx,eax
	 add ebp,ecx
	;;adding port structure ;
	push	edi
	call	port_ranges_to_str
	pop	eax
	 mov ecx,edi
	 sub ecx,eax
	 add ebp,ecx
	push	edi
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	rep	movsb
	pop	esi
	call	set_packet_increment
	mov	ecx,ebp
	add	ecx,pktypes_inc_l+4+1	
	mov	esi,main_buffer
	mov	dl,DB_ID_PR_LIMIT_IP
	call	add_to_db
	;;;
	ret
.first	db	0	
.protocol db	0
.la	dd	0
.pad	dd	0
.ca	dd	0
