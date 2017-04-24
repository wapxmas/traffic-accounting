;;log_by_each_ip;
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_each_ip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_EACH_IP
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_each_ip
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_each_ip:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_log_by_each_ip
	call	add_to_timer_f	
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LOG_BY_EACH_IP
	jz	.nex_1
	sub	al,(MAXPC_LOG_BY_EACH_IP-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	call	NSkipIP
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
	call Qallow_ipN
	jc	.ex	
	call NSkipFile
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	.ex
	test	byte [Qallow_ipN.dst],1
	jz	.tsrc
	setz	byte[inc_by_ip.type]
	mov	eax,dword[packet.da]
	bswap	eax
	call	inc_by_ip
    .tsrc:	
		test	byte [Qallow_ipN.src],1
		jz	.ex
		setnz	byte[inc_by_ip.type]
		mov	eax,dword[packet.sa]
		bswap	eax
		call	inc_by_ip
    .ex:
	;;;
	ret
.first	db	0
.st	db	0
.tpsrc	db	0
inc_packet_by_type:
	test	al,1
	jnz .inc_src
	 call	set_packet_increment_dst
	 ;;;
	 ret
    .inc_src:
	 call	set_packet_increment_src
	 ;;;
	 ret
;;INPUT: eax=IPnum;
inc_by_ip:
	mov	dword[.addr], eax
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBE
	call	find_in_db
	jc	.lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz	.nx_f
	    call to_zero
	    lodsd
	    sub eax,dword[.addr]
	    jz	.do_inc
	.nx_f:
	mov	esi,ebx
	jmp short .lpf
    .do_inc:
	mov	al,byte[.type]
	call	inc_packet_by_type
	;;;
	ret
    .lpe:	;;ADD TO;
	mov	edi,main_buffer
	mov	eax,dword[current.nfunc]
	stosd
	mov	esi,packet.dev
	call	strcat_z
	push	edi
	    mov edi,packet.dev
	    call strlen_z
	    mov ebp,ecx
	pop	edi
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
	mov	dl,DB_ID_LBE
	mov	ecx,pktypes_inc_l+4+4
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
.addr	dd	0
.type	db	0
on_timer_log_by_each_ip:
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_each_ip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_EACH_IP
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lbe_timer
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_lbe_timer:
	mov	dword[.nfunc],ecx
	lodsb
	sub	al,MAXPC_LOG_BY_EACH_IP
	je	.nx
	js	.nx
	mov	eax,err_sPC
	call	write
	call	@exit		
    .nx:
	call	NSkipIP
	mov	dword[.flSaddr], esi
	mov	eax,93
	mov	esi,dword[.flSaddr]
	mov	ebx,dword[esi]
	sub	ecx,ecx
	int	0x80
	
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LBE
	call	find_in_db
	jc	.lpe
	    push ebx
		lodsd
		sub eax,dword[.nfunc]
		jnz .do_nxI
		mov dword[.tmp_e],esi
		call to_zero
		lodsd
		mov	dword[.tmp_c],esi
		mov	dword[.tmp_b],eax
		call	a_str_2lbe
	.do_nxI:
	    pop	ebx
	mov	esi,ebx
	jmp short .lpf
    .lpe:	;;exit;
	;;;
	ret
.ipSaddr	dd	0
.flSaddr	dd	0
.tmp_a		dd	0
.tmp_b		dd	0
.tmp_c		dd	0
.tmp_d		dd	0
.tmp_e		dd	0
.nfunc		dd	0
a_str_2lbe:
	mov	esi,dword[do_lbe_timer.flSaddr]
	lodsd
	mov	dword[.fd], eax
	mov	edi,main_buffer
	mov	esi,dword[do_lbe_timer.tmp_e]
	call	strcat
	mov	al,byte[spec_ch]
	stosb
	mov	ebx,dword[do_lbe_timer.tmp_b]
	call ipn2s
	dec edi
	mov	esi,dword[do_lbe_timer.tmp_c]
	call	generate_log2
	mov	ax,0x000A
	stosw
	mov	edi,main_buffer
	call	strlen
	mov	edx,ecx
	mov	eax,4
	mov	ebx,dword[.fd]
	mov	ecx,main_buffer
	int	0x80		
	;;;
	ret
.fd	dd	0
generate_log2:
	mov	ecx,5
    .lp:	
	movzx	eax,byte[spec_ch]
	stosb	
	lodsb	;eax=type
	mov	al,[pkt_types+eax]
	stosb
	mov	al,[spec_ch2]
	stosb
	lodsd
	mov	edx,eax
	lodsd
	push	esi
	    push ecx
	call d64_2s
	    pop	ecx
	pop	esi
	dec	edi
	dec	ecx
	jnz	.lp
	;;;
	ret
;;INPUT: esi=*ipstruct;
;;OUT: cf=0 then OK, otherwise isn`t;
cIPcheck:
	lodsb
	movzx	ecx,al
	mov	byte[.st],0
    .lp_ip:
	push ecx
	call Qallow_ip
	jc	.ce
	setnc	byte[.st]
    .ce:
	pop ecx
	dec ecx
	jnz .lp_ip
	test byte[.st],1
	jz .ex_e
	clc
	;;;
	ret
.ex_e:	stc
	;;;
	ret
.st	db	0

;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	