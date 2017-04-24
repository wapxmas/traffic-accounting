;;func_iface_limit;
	sub	ecx,ecx
    .lp:
	mov	esi,iface_limit_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_IFACE_TL
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lm_iface
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_lm_iface:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_IFACE_TL
	jz	.nex_1
	sub	al,(MAXPC_IFACE_TL-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
	test	byte[dfuncs_ntable.ex],1
	jz	.next
	call	NSkipLM
	call	NSkipEnum
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
	lodsb
	movzx	ebx,al
    .lp:
	mov	edi,packet.dev
	call	strcmp
	jecxz	.do_lim
	call	to_zero
	dec	ebx
	jnz	.lp
	;;;
	ret
    .do_lim:
	dec	ebx
	jz	.nxl
	    .lp2:
		call to_zero
		dec	ebx
		jnz	.lp2
    .nxl:    
	
	mov dword[limit_def.sh],esi
	
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_IFACE_LIMIT
	call	find_in_db
	jc	.lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx1
	push	ebx
	    mov	dword[.la],esi
	    call NSkipLM
	    mov	dword[limit_def.in],esi
	    mov	edi,packet.dev
	    call strcmp
	pop	ebx	
	jecxz	.innc
    .nx1:
	mov	esi,ebx
	jmp short .lpf
    .innc:
	mov	dword[.ca],esi
	call	increment_packet	
	mov	eax,dword[.ca]
	mov	ebx,dword[.la]
	mov	word[limit_def.lt],'IL'
	call	climit
	;;;
	ret
    .lpe:	
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
	push	edi
	mov	edi,packet.dev
	call	strlen
	pop	edi
	inc	ecx
	push	ecx
	mov	esi,packet.dev
	rep	movsb
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	mov	edx,edi
	rep	movsb
	pop	ecx	
	mov	esi,edx
	call	increment_packet
	add	ecx,pktypes_inc_l+4
	add	ecx,ebp
	mov	esi,main_buffer
	mov	dl,DB_ID_IFACE_LIMIT
	call	add_to_db
    .nx:
	;;;
	ret
.la	dd	0
.ca	dd	0
