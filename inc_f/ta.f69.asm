;;func_port_range_limit;
	sub	ecx,ecx
    .lp:
	mov	esi,pr_range_limit_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_PR_RANGE_TL
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_pr_range_tl
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_pr_range_tl:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_PR_RANGE_TL
	jz	.nex_1
	sub	al,(MAXPC_PR_RANGE_TL-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	call	NSkipLM
	lodsd
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
	mov byte[.protocol],al
	cmp al,byte[packet.protocol]
	jnz .ex
	push esi
	  mov bl,al
	  call gp_by_proto
	pop esi
	mov dword[.pad],esi
	call QallowPort
	test byte[QallowPort.fl],1
	jnz .nx_port
    .ex:
	;;;
	ret
    .nx_port:
	mov dword[limit_def.sh],esi
	call to_zero
	mov	esi,dword[name_esi_tmp]
	call NSkipLM
	lodsd
	push esi
	    call cportlp
	pop esi	
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_PR_LIMIT
	call	find_in_db
	jc	near .ad_2table
	lodsd
	sub eax,dword[current.nfunc]
	jz .inc_4port
	mov	esi,ebx
	jmp short .lpf
    .inc_4port:
	mov	dword[.la],esi
	call	NSkipLM	
	mov	dword[limit_def.in],esi
	call	to_zero
	inc esi    
	movzx	eax,byte[.protocol]
	mov	dword[limit_def.pr],eax
	mov	dword[limit_def.po],esi
	call	to_zero
	mov	dword[.ca],esi
	call	increment_packet
	mov	eax,dword[.ca]
	mov	ebx,dword[.la]
	mov	word[limit_def.lt],'PR'	
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
	add	ebp,ebx	;add devivce name length
	mov	esi,dword[.pad]
	mov	al,byte[.protocol]
	stosb	;protocol
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
	call	increment_packet
	mov	ecx,dword[cportlp.len]
	add	ecx,pktypes_inc_l+4+1
	add	ecx,ebp
	mov	esi,main_buffer
	mov	dl,DB_ID_PR_LIMIT
	call	add_to_db
	;;;
	ret
.first	db	0	
.protocol db	0
.pad	dd	0
.la	dd	0
.ca	dd	0
