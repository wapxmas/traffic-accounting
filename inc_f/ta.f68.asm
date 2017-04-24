;;func_ip_each_traf_limit;
	sub	ecx,ecx
    .lp:
	mov	esi,ipe_range_traf_limit_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_IPE_RANGE_TL
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_ip_each_limit
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_ip_each_limit:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_IPE_RANGE_TL
	jz	.nex_1
	sub	al,(MAXPC_IPE_RANGE_TL-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	call	NSkipLM
	call	NSkipIP	
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
	call Qallow_ipN
	jc	.ex
	mov dword[limit_def.sh],esi	
	call to_zero
	test	byte [Qallow_ipN.dst],1
	jz	.tsrc
	setz	byte[inc_by_eip_lim.type]
	mov	eax,dword[packet.da]
	bswap	eax
	call	inc_by_eip_lim
    .tsrc:	
		test	byte [Qallow_ipN.src],1
		jz	.ex
		setnz	byte[inc_by_eip_lim.type]
		mov	eax,dword[packet.sa]
		bswap	eax
		call	inc_by_eip_lim
    .ex:
	;;;
	ret
.first	db	0
.st	db	0
.tpsrc	db	0
.ipad	dd	0
.la	dd	0
.ca	dd	0

inc_by_eip_lim:
	mov	dword[.addr], eax
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_IPE_LIMIT
	call	find_in_db
	jc	.lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx1
	    mov	dword[.la],esi
	    call NSkipLM
	    mov	dword[limit_def.in],esi
	    call to_zero
	    lodsd
	    cmp eax,dword[.addr]
	    je	.do_inc
    .nx1:
	mov	esi,ebx
	jmp short .lpf
    .do_inc:
	mov edi,limit_buffer
	mov ebx,dword[.addr]
	call ipn2s
	mov	dword[limit_def.ip],limit_buffer
	mov	dword[.ca],esi
	mov	al,byte[.type]
	call	inc_packet_by_type
	mov	eax,dword[.ca]
	mov	ebx,dword[.la]
	mov	word[limit_def.lt],'IE'
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
	mov	eax,dword[.addr]
	stosd
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	push	edi
	rep	movsb
	pop	esi
	mov	al,byte[.type]
	call	inc_packet_by_type
	mov	esi,main_buffer
	mov	dl,DB_ID_IPE_LIMIT
	mov	ecx,pktypes_inc_l+4+4
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
.addr	dd	0
.type	db	0
.ipad	dd	0
.la	dd	0
.ca	dd	0
