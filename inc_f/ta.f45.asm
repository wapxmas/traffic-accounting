;;log_by_port();
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_port_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_PORT
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_port
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_port:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_log_by_port
	call	add_to_timer_f
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LOG_BY_PORT
	jz	.nex_1
	sub	al,(MAXPC_LOG_BY_PORT-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	lodsd	;protocol
	call	NSkipPort
	mov	dword[file_estart],esi
	call	NSkipFile
	call	NSkipEnum
	mov	dword[name_deny_addr],esi
	pop	esi
	mov	dword[some_f_name_deny],0
	mov	esi,dfuncs_ntable
	call	run_f
	test	dword[some_f_name_deny],1
	jz	.next
	;;;
	ret
    .next:
	mov	esi,dword[name_esi_tmp]
	lodsd	;protocol
	cmp al,byte[packet.protocol]
	jnz .ex
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
	call NSkipFile
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	.ex
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBP
	call	find_in_db
	jc	.ad_2table
	lodsd
	sub	eax,dword[current.nfunc]
	jz	.inc_4port
    .nx_1:
	mov	esi,ebx
	jmp short .lpf
    .inc_4port:
	call	to_zero
	inc	esi
	call	to_zero
	call	increment_packet
	;;;
	ret
    .ad_2table:
	mov	edi,main_buffer
	mov	eax,dword[current.nfunc]
	stosd
	mov	edx,edi
	mov	esi,process.dev
	call	strcat_z
	mov	ebp,edi
	sub	ebp,edx	
	mov	esi,dword[name_esi_tmp]
	add	esi,4
	mov	al,byte[.protocol]
	stosb	;protocol	
	push	edi
	call	port_ranges_to_str
	pop	eax
	push edi
	    mov edi,eax
	    call strlen
	    inc ecx
	    add ebp,ecx
	pop edi
	push	edi
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	rep	movsb
	pop	esi
	call	increment_packet
	mov	ecx,ebp
	add	ecx,pktypes_inc_l+4+1+4
	mov	esi,main_buffer
	mov	dl,DB_ID_LBP
	call	add_to_db
	;;;
	ret
.first	db	0	
.protocol db	0
on_timer_log_by_port:
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_port_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_PORT
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_port_timer
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_port_timer:
	mov	dword[.nfunc],ecx
	lodsb
	lodsd
	mov byte[.protocol],al
	mov	dword[.esi_tmp],esi
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBP
	call	find_in_db
	jc	near .lpe
	lodsd
	sub	eax,dword[.nfunc]
	jz	.innc
    .nx1:
	mov	esi,ebx
	jmp short .lpf
    .innc:
	mov	dword[.dev],esi
	call	to_zero
	inc	esi
	push	esi
	mov	esi,dword[.esi_tmp]
	call	NSkipPort
	mov	eax,dword[esi]
	mov	dword[.fd],eax
	mov	edi,main_buffer
	mov	esi,dword[.dev];packet.dev
	call	strcat	
	mov	al,byte[spec_ch]
	stosb
	pop	esi
	call	generate_log
	sub	al,al
	stosb
	mov	eax,93
	mov	ebx,dword[.fd]
	sub	ecx,ecx
	int	0x80	
	mov	edi,main_buffer
	call	strlen
	mov	edx,ecx
	mov	eax,4
	mov	ebx,dword[.fd]
	mov	ecx,main_buffer
	int	0x80	
    .ex:
	;;;
	ret
    .lpe:	;;ADD TO;
	;;;
	ret
.esi_tmp	dd	0
.fd		dd	0
.dev		dd	0
.protocol	db	0
.nfunc		dd	0

port_ranges_to_str:
	lodsb
	movzx ecx,al
    .lp:
	lodsb
	push dword .next
	test al,PTYPE_DST
	jz  .try_src
	mov bl,'d'
	;;;
	ret
    .try_src:
	test al,PTYPE_SRC
	jz  .try_all
	mov bl,'s'
	;;;
	ret
    .try_all:
	mov bl,'a'
	add esp,4
    .next:
	mov byte[.type],al
	mov al,bl	
	stosb
	lodsd
	push ecx
	 call d2s
	pop ecx
	dec edi
	test byte[.type],PTYPE_RANGE
	jz .next_loop
	mov al,'-'
	stosb
	lodsd
	push ecx
	 call d2s
	pop ecx
	dec edi	
    .next_loop:
	mov al,','
	stosb
	dec ecx
	jnz .lp
	dec edi
	sub al,al
	stosb
	;;;
	ret
.type	db	0	
;;INPUT: esi=*port_struct;
;;OUTPUT: .len=struct_length;
cportlp:
	mov edx,esi
	push edx
	call NSkipPort
	pop edx
	mov ebx,esi
	sub esi,edx
	mov dword[.len],esi
	mov esi,ebx
	;;;
	ret
.len	dd	0	
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	