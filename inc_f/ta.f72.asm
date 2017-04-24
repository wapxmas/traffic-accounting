;;func_proto_each_limit;
	sub	ecx,ecx
    .lp:
	mov	esi,proto_each_limit_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_PROTO_EACH_TL
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_each_proto_limit
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_each_proto_limit:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_PROTO_EACH_TL
	jz	.nex_1
	sub	al,(MAXPC_PROTO_EACH_TL-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	call	NSkipLM
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
	call QallowSN
	test byte[QallowSN.fl],1
	jz .ex
	mov dword[limit_def.sh],esi
	call to_zero
	call inc_by_proto_limit
    .ex:
	;;;
	ret
inc_by_proto_limit:
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_ECPROTO_LIMIT
	call	find_in_db
	jc	.lpe	
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx1
	    mov	dword[.la],esi
	    call NSkipLM
	    mov	dword[limit_def.in],esi
	    call to_zero
	    lodsb ;protocol
	    cmp al,byte[packet.protocol]
	    jz .do_inc
    .nx1:
	mov	esi,ebx
	jmp short .lpf
    .do_inc:	
	movzx	eax,byte[packet.protocol]
	mov	dword[limit_def.pr],eax
	mov	dword[.ca],esi
	call	increment_packet
	mov	eax,dword[.ca]
	mov	ebx,dword[.la]
	mov	word[limit_def.lt],'RE'	
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
	mov	al,byte[packet.protocol]
	stosb
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	push	edi
	rep	movsb
	pop	esi
	call	increment_packet
	mov	esi,main_buffer
	mov	dl,DB_ID_ECPROTO_LIMIT
	mov	ecx,pktypes_inc_l+1+4
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
.la	dd	0
.ca	dd	0
