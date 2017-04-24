;;func_each_pr_range_limit;
	sub	ecx,ecx
    .lp:
	mov	esi,each_pr_range_limit_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_EACH_PR_RANGE_TL
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_each_port_limit
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_each_port_limit:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_EACH_PR_RANGE_TL
	jz	.nex_1
	sub	al,(MAXPC_EACH_PR_RANGE_TL-1)
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
	lodsd
	mov byte[.protocol],al
	cmp al,[packet.protocol]
	jnz .ex
	push esi
	  mov bl,al
	  call gp_by_proto
	pop esi	
	mov dword[.pad],esi
	call QallowPortN
	test byte[QallowPortN.fl],1
	jz .ex
	mov dword[limit_def.sh],esi
	call to_zero
	test	byte [QallowPortN.dst],1
	jz	.tsrc
	setz	byte[inc_by_el_port.type]
	mov	ax,word[gp_by_proto.dport]	
	call	inc_by_el_port
    .tsrc:	
		test	byte[QallowPortN.src],1
		jz	.ex
		setnz	byte[inc_by_el_port.type]
		mov	ax,word[gp_by_proto.sport]
		call	inc_by_el_port
    .ex:
	;;;
	ret
.first	db	0
.st	db	0
.tpsrc	db	0
.protocol	db	0
.pad	dd	0

inc_by_el_port:
	mov	word[.port],ax
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_ECPR_LIMIT
	call	find_in_db
	jc	near .lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .do_next_part
	    mov	dword[.la],esi
	    call NSkipLM
	    mov	dword[limit_def.in],esi
	    call to_zero
	    inc esi
	    lodsw
	    cmp ax,word[.port]
	    jz	.do_inc
    .do_next_part:
	mov	esi,ebx
	jmp short .lpf
    .do_inc:
	movzx	eax,byte[do_each_port_limit.protocol]
	mov	dword[limit_def.pr],eax	
	mov	edi,limit_buffer
	movzx	eax,word[.port]
	call	d2s
	mov	dword[limit_def.po],limit_buffer
	mov	dword[.ca],esi
	mov	al,byte[.type]
	call	inc_port_packet_by_type
	mov	eax,dword[.ca]
	mov	ebx,dword[.la]
	mov	word[limit_def.lt],'PE'
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
	mov	al,byte[do_each_port_limit.protocol]
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
	mov	dl,DB_ID_ECPR_LIMIT
	mov	ecx,pktypes_inc_l+3+4
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
.port	dw	0
.type	db	0
.la	dd	0
.ca	dd	0
