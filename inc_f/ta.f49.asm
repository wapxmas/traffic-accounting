;;log_by_port_ip;
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_port_ip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_PORT_IP
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_port_ip
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_port_ip:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_log_by_port_ip
	call	add_to_timer_f
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LOG_BY_PORT_IP
	jz	.nex_1
	sub	al,(MAXPC_LOG_BY_PORT_IP-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	lodsd	;protocol
	call	NSkipIP
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
	call NSkipFile
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	.ex
	mov	esi,dword[name_esi_tmp]
	lodsd
	call ciplp
	call cportlp
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBP_IP
	call	find_in_db
	jc	.ad_2table
	lodsd
	sub	eax,dword[current.nfunc]
	jnz	.nx_1
	call	to_zero
	lodsb
	cmp	al,byte[.protocol]
	jz	.inc_4port	
    .nx_1:
	mov	esi,ebx
	jmp short .lpf
    .inc_4port:
	call	to_zero
	call	to_zero
	call	set_packet_increment
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
	;;adding ip structure ;
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
	mov	dl,DB_ID_LBP_IP
	call	add_to_db
	;;;
	ret
.first	db	0	
.protocol db	0
on_timer_log_by_port_ip:
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_port_ip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_PORT_IP
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_port_ip_timer
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_port_ip_timer:
	mov	dword[.nfunc],ecx
	lodsb
	lodsd
	mov byte[.protocol],al
	mov	dword[.esi_tmp],esi
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBP_IP
	call	find_in_db
	jc	near .lpe
	lodsd
	sub	eax,dword[.nfunc]
	jnz	.nx1
	mov	dword[.dev],esi
	call	to_zero
	lodsb
	cmp	byte[.protocol],al
	jz	.innc	
    .nx1:
	mov	esi,ebx
	jmp short .lpf
    .innc:
	mov	esi,dword[.esi_tmp]
	call	NSkipIP
	call	NSkipPort
	mov	eax,dword[esi]
	mov	dword[.fd],eax
	mov	edi,main_buffer
	mov	esi,dword[.dev];packet.dev
	call	strcat	
	mov	al,byte[spec_ch]
	stosb
	mov	esi,dword[.dev]
	call	to_zero
	inc	esi
	call	strcat_z
	dec	edi
	mov	al,byte[spec_ch]
	stosb
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
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>