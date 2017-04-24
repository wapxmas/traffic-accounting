;;func_proto_ip_limit;
	sub	ecx,ecx
    .lp:
	mov	esi,proto_ip_limit_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_PROTO_IP_TL
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lm_proto_ip
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_lm_proto_ip:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_PROTO_IP_TL
	jz	.nex_1
	sub	al,(MAXPC_PROTO_IP_TL-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
	test	byte[dfuncs_ntable.ex],1
	jz	.next
	call	NSkipLM
	call	NSkipIP
	call	NSkipProto
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
	mov dword[.pad],esi
	call Qallow_ipN
	jc .ex	
	call QallowSN
	test byte[QallowSN.fl],1
	jnz .nx_port
    .ex:
	;;;
	ret
    .nx_port:
	mov dword[limit_def.sh],esi
	mov  esi,dword[.pad]
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_PROTO_IP_LIMIT
	call	find_in_db
	jc	near .ad_2table	
	lodsd
	sub eax,dword[current.nfunc]
	jz .inc_4port
	mov	esi,ebx
	jmp short .lpf
    .inc_4port:
	mov	dword[.la],esi
	call 	NSkipLM
	mov	dword[limit_def.in],esi
	call	to_zero
	mov	dword[limit_def.ip],esi
	call	to_zero
	mov	dword[limit_def.rp],esi
	call	to_zero
	mov	dword[.ca],esi
	call	set_packet_increment
	mov	eax,dword[.ca]
	mov	ebx,dword[.la]
	mov	word[limit_def.lt],'PD'
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
	mov	esi,process.dev
	mov	edx,edi
	call	strcat_z
	mov	ebx,edi
	sub	ebx,edx
	add	ebp,ebx
	mov	esi,dword[.pad]
	;;adding ip structure ;
	push	edi
	call	ip_ranges_to_str
	pop	eax	
	 mov ecx,edi
	 sub ecx,eax
	 add ebp,ecx
	;;adding proto structure ;
	push	edi
	call	proto_ranges_to_str
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
	mov	ecx,pktypes_inc_l+4
	add	ecx,ebp
	mov	esi,main_buffer
	mov	dl,DB_ID_PROTO_IP_LIMIT
	call	add_to_db
	;;;
	ret
.first	db	0
.la	dd	0
.ca	dd	0
.pad	dd	0
.svProto dd	0