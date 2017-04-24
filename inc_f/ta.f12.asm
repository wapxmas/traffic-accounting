;;log_by_ip;
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_ip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_IP
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_ip
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_ip:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_log_by_ip
	call	add_to_timer_f
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LOG_BY_IP
	jz	.nex_1
	sub	al,(MAXPC_LOG_BY_IP-1)
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
	jc near	.ex
	call NSkipFile
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	.ex
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LOG_BIP
	call	find_in_db
	jc	.lpe
	lodsd
	sub	eax,dword[current.nfunc]
	jz	.innc
    .nx1:
	mov	esi,ebx
	jmp short .lpf
    .innc:
	call	to_zero
	call	to_zero
	call	set_packet_increment
    .ex:
	;;;
	ret
    .lpe:	;;ADD TO;
		;pktypes_inc
	mov	edi,main_buffer
	mov	eax,dword[current.nfunc]
	stosd
	mov	edx,edi
	mov	esi,process.dev
	call	strcat_z
	mov	ebp,edi
	sub	ebp,edx
	mov	esi,dword[name_esi_tmp]
	push	edi
	 call	ip_ranges_to_str
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
	call	set_packet_increment
	mov	ecx,ebp
	add	ecx,pktypes_inc_l+4+4
	mov	esi,main_buffer
	mov	dl,DB_ID_LOG_BIP
	call	add_to_db
	;;;
	ret
.first	db	0
.st	db	0
set_packet_increment_dst:
	cmp	byte[packet.ptype],PACKET_OUTGOING
	jz	.cnt
	test	byte[packet.ptype],0xff
	jnz	.ex
    .cnt:
	movzx	eax,byte[packet.ptype]
	push	eax
	mov	byte[packet.ptype],PACKET_HOST
	call	increment_packet
	pop	eax
	mov	byte[packet.ptype],al
	;;;
	ret
    .ex:
	call	increment_packet
	;;;
	ret
	
set_packet_increment_src:
	cmp	byte[packet.ptype],PACKET_OUTGOING
	je	.cnt
	test	byte[packet.ptype],0xff
	jnz	.ex	
    .cnt:    
	movzx	eax,byte[packet.ptype]
	push	eax
	mov	byte[packet.ptype],PACKET_OUTGOING
	call	increment_packet
	pop	eax
	mov	byte[packet.ptype],al
	;;;
	ret
    .ex:
	call	increment_packet
	;;;
	ret
	
set_packet_increment:
	cmp	byte[packet.ptype],PACKET_OUTGOING
	jz	.cnt
	test	byte[packet.ptype],0xff
	jnz	.f_ex
    .cnt:
	movzx	eax,byte[packet.ptype]
	push	eax
	test	byte[Qallow_ipN.dst],1
	jz	.tsrc
	setz	byte[packet.ptype]	;0=PACKET_HOST
	push	esi
	call	increment_packet
	pop	esi
    .tsrc:
	test	byte[Qallow_ipN.src],1
	jz	.ex
	mov	byte[packet.ptype],PACKET_OUTGOING
	call	increment_packet
    .ex:
	pop	eax
	mov	byte[packet.ptype],al
	;;;
	ret
    .f_ex:
	call	increment_packet
	;;;
	ret
	
;;INPUT: esi=*buffer_ip_range;
ip_ranges_to_str:
	    lodsb
	    movzx edx,al
    .lp:
	    push	dword .chk	    
	    lodsb
	    mov	ah,al
	    test	al,IPTYPE_ALL
	    jz	.nx
	    mov	al,'a'
	    ;;;
	    ret
    .nx:
	    test	al,IPTYPE_SRC
	    jz	.nx1
	    mov	al,'s'
	    ;;;
	    ret
    .nx1:
	    test	al,IPTYPE_DST
	    jz		.nx2
	    mov	al,'d'
	    ;;;
	    ret
    .nx2:
	    mov	eax,error_ips
	    call write
	    call @exit
    .chk:
	    stosb
	    test	ah,IPTYPE_MASK
	    jnz	.mask
	    test	ah,IPTYPE_RANGE
	    jz	.simply
		lodsb
		mov bl,al
		mov bh,3
		push edx
	    .lp_r:
		    movzx ecx,bh
		    bt ebx,ecx
		    jnc	.r_simply
		    lodsb
		    and eax,0xff
		    push ebx
			call d2s
			dec edi
		    pop ebx
		    mov al,'-'
		    stosb
		    lodsb
		    and eax,0xff
		    push ebx
			call d2s
			dec edi
		    pop ebx
		    jmp short .r_dot		    
	    .r_simply:
		lodsb
		and eax,0xff
		push ebx
		    call d2s
		    dec edi
		pop ebx
	    .r_dot:
		or bh,bh
		jz .r_nx
		mov al,'.'
		stosb
	.r_nx:
		dec bh
		jns .lp_r
		pop edx
		mov al,','
		stosb
		jmp short .nxIP
    .mask:
	    lodsd
	    push edx
	      push esi
	        call ip_to_str
	      pop esi
	    pop edx
	    mov	al,'/'
	    stosb
    .simply:
	    lodsd
	    push edx
	      push esi
	        call ip_to_str
	      pop esi
	    pop edx
	    mov al,','
	    stosb	    
    .nxIP:
	    dec	edx
	    jnz	.lp
	    dec edi
	    sub al,al
	    stosb
	    ;;;
	    ret
;;INPUT: eax=ipnum;
;;OUTPUT: edi=output;
ip_to_str:
	    mov ebx,eax
	    bswap ebx
	    mov ecx,4
    .lp:
	    mov eax,ebx
	    and	eax,0xff
	    push ecx
		push ebx
		    call d2s
		pop ebx
	    pop ecx
		    cmp ecx,1
		    jz .nx
		    mov al,'.'
		    dec edi
		    stosb
		.nx:
	    ror ebx,8
	    dec	ecx
	    jnz	.lp
	    dec edi
	;;;
	ret
;;INPUT: esi=str1, edi=str2, ecx=number			;
;;OUTPUT: ecx=0 then str`s are equal, otherwise ain`t	;
strncmp:
    inc	ecx
    rep cmpsb
    ;;;
    ret
;;INPUT: esi=*ip_struct	;
;;OUTPUT: ecx=len	;
ciplp:
	lodsb
	movzx edx,al
	mov dword[.len],1
    .lp:
	lodsb
	inc dword[.len]
	test al,IPTYPE_RANGE
	jz .nx1
		lodsb
		inc dword[.len]
		movzx ebx,al
		mov ecx,8
		sub eax,eax
	    .cbits: rcr ebx,1
		    jnc	.nxc
		    inc eax		    
	    .nxc:
		    dec ecx
		    jnz .cbits
	    lea	ecx,[eax+4]
	    add	dword[.len],ecx
	    lea esi,[esi+eax+4]
	    jmp short .nx
    .nx1:
	lodsd
	add dword[.len],4
    .nx:
	dec edx
	jnz .lp
    mov ecx,dword[.len]
    ;;;
    ret
.len	dd	0
;;RUNS IN TIMER;
on_timer_log_by_ip:
	sub	ecx,ecx
    .lp:
	mov	esi,log_by_ip_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_BY_IP
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_ip_timer
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_ip_timer:
	mov	dword[.nfunc],ecx
	lodsb
	mov	dword[.esi_tmp],esi
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LOG_BIP
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
	push	esi
	mov	esi,dword[.esi_tmp]
	call	NSkipIP
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
	xchg	ecx,edx
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
.nfunc		dd	0

Qallow_ipN:
	mov	word[.dst],0
	mov	eax,dword[packet.sa]
	push	eax
	mov	dword[.tmp],eax
	mov	eax,dword[packet.da]
	push	eax
	mov	dword[packet.sa],eax
	push	esi
	call	cIPcheck
	jc	.chk_src
	setnc	byte[.dst]
    .chk_src:
	pop	esi
	mov	eax,dword[.tmp]
	mov	dword[packet.sa],eax
	mov	dword[packet.da],eax
	call	cIPcheck
	jc	.chk_src_nx
	setnc	byte[.src]
    .chk_src_nx:
	pop	eax
	mov	dword[packet.da],eax
	pop	eax
	mov	dword[packet.sa],eax
	test	word[.dst],0xffff
	jz	.er
	mov	eax,dword[packet.sa]
	cmp	eax,dword[packet.da]
	jnz	.nx
	cmp	byte[packet.ptype],PACKET_HOST
	jnz	.t_out
	setnz	byte[.src]
	clc
	;;;
	ret
    .t_out:
	cmp	byte[packet.ptype],PACKET_OUTGOING
	jnz	.nx
	setnz	byte[.dst]
    .nx:
	clc
	;;;
	ret
    .er:
	stc
	;;;
	ret
.dst	db	0
.src	db	0
.tmp	dd	0
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>