;;log_by_proto_ip;
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_proto_ip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_PROTO_IP
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_proto_ip
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_proto_ip:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_log_by_proto_ip
	call	add_to_timer_f
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LOG_BY_PROTO_IP
	jz	.nex_1
	sub	al,(MAXPC_LOG_BY_PROTO_IP-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	call	NSkipIP
	call	NSkipProto
	call	NSkipFile
	call	NSkipEnum
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
	call Qallow_ipN
	jc .ex	
	call QallowSN
	test byte[QallowSN.fl],1
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
	mov	dl,DB_ID_LB_PROTO_IP
	call	find_in_db
	jc	.ad_2table
	lodsd
	sub	eax,dword[current.nfunc]
	jz 	.inc_4port	
	mov	esi,ebx
	jmp short .lpf
    .inc_4port:
	call	to_zero
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
	mov	ecx,ebp
	add	ecx,pktypes_inc_l+4	
	mov	esi,main_buffer
	mov	dl,DB_ID_LB_PROTO_IP
	call	add_to_db
	;;;
	ret
.first	db	0

on_timer_log_by_proto_ip:	
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_proto_ip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_PROTO_IP
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_proto_timer_ip
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_proto_timer_ip:
	mov	dword[.nfunc],ecx
	lodsb
	mov	dword[.esi_tmp],esi
	mov	esi,start_table
    .lpf:	
	mov	dl,DB_ID_LB_PROTO_IP
	call	find_in_db
	jc	near .lpe
	lodsd
	sub	eax,dword[.nfunc]
	jz	.innc
	mov	esi,ebx
	jmp .lpf
    .innc:
	mov	dword[.dev],esi
	mov	esi,dword[.esi_tmp]
	call	NSkipIP
	call	NSkipProto
	mov	eax,dword[esi]
	mov	dword[.fd],eax
	mov	edi,main_buffer
	mov	esi,dword[.dev];packet.dev
	call	strcat	
	mov	al,byte[spec_ch]
	stosb
	mov	esi,dword[.dev]
	call	to_zero
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
.tproto		db	0
.nfunc		dd	0
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>