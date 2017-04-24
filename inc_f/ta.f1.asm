;;log_file();
	sub	ecx,ecx
    .lp:
	mov	esi,log_file_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_FILE
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_iface
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_iface:
	test	byte[.first],1
	jnz	.next
	setz	byte[.first]
	mov	edx,update_log_file	
	call	add_to_timer_f	
.next:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LOG_FILE
	jz	.nex_1
	sub	al,(MAXPC_LOG_FILE-1)
	jz	.next1
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
	test	byte[dfuncs_ntable.ex],1
	jz	.next1
	call	NSkipFile
	call	NSkipEnum
	mov	dword[name_deny_addr],esi
	mov	dword[some_f_name_deny],0
	mov	esi,dfuncs_ntable
	call	run_f
	test	dword[some_f_name_deny],1
	jz	.next1
	;;;
	ret
    .next1:
	mov	esi,dword[name_esi_tmp]	
	call	NSkipFile
	movzx	ebx,byte[packet.ptype]
	call	typeexists
	or	bh,bh
	jz	.nx
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_LOG
	call	find_in_db
	jc	.lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx1
	push	ebx
	    mov	edi,packet.dev
	    push esi
		call strcmp
	    pop esi
	pop	ebx	
	jecxz	.innc
    .nx1:
	mov	esi,ebx
	jmp short .lpf
    .innc:	
	call	to_zero
	call	increment_packet
	;;;
	ret
    .lpe:
	mov	edi,packet.dev
	call	strlen
	inc	ecx
	push	ecx
	mov	esi,packet.dev
	mov	edi,main_buffer
	mov	eax,dword[current.nfunc]
	stosd
	rep	movsb
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	mov	edx,edi
	rep	movsb
	mov	esi,edx
	call	increment_packet
	pop	ecx
	add	ecx,pktypes_inc_l+4
	mov	esi,main_buffer
	mov	dl,DB_ID_LOG
	call	add_to_db
    .nx:
	;;;
	ret
.first	db	0
pkt_types:
	    db	"i"
	    db	"b"
	    db	"m"
	    db	"f"
	    db	"o"
increment_packet:
	    cld
	.lp:
	    lodsb
	    add	esi,8
	    cmp	al,byte[packet.ptype]
	    jnz	.lp
	    sub	esi,8
	    mov	eax,dword[esi+4]
	    add	eax,dword[packet.len]
	    mov	dword[esi+4],eax
	    mov	eax,dword[esi]
	    adc	eax,0
	    mov	dword[esi],eax
	    ;;;
	    ret
increment_packet_f:
	    cld
	.lp:
	    lodsb
	    add	esi,8
	    cmp	al,byte[packet.ptype]
	    jnz	.lp
	    sub	esi,8
	    mov	eax,dword[esi+4]
	    add	eax,dword[packet.flen]
	    mov	dword[esi+4],eax
	    mov	eax,dword[esi]
	    adc	eax,0
	    mov	dword[esi],eax
	    ;;;
	    ret
;;INPUT: dl=ID, esi=*start_table;
;;OUTPUT: esi=*buffer, ebx=*start_next_if_need;
find_in_db:
	cld
	clc
    .lp:
	lodsd
	or	eax,eax
	jz	.nf
	mov	ebx,eax
	lodsb
	sub	al,dl
	jz	.ex
	mov	esi,ebx
	jmp	short .lp
    .nf:
	stc
	;;;
	ret
    .ex:
	clc
	;;;
	ret
;;INPUT: esi=*buffer, ecx=buf_length, dl=ID;
;;OUTPUT: esi=*start_buffer;
add_to_db:
	mov	edi,dword[eodb]
	lea	ebx,[edi+ecx+5]
	mov	dword[eodb],ebx
	push	ebx
	mov	eax,45
	add	ebx,4	;dword[flag_table_end](0)
	int	0x80
	pop	ebx
	mov	eax,ebx
	stosd
	mov	al,dl
	stosb
	push	edi
	mov	eax,edx
	mov	edx,ecx
	shr	ecx,2
	rep	movsd
	mov	ecx,edx
	and	ecx,11b
	rep	movsb
	mov	edx,eax	
	sub	eax,eax
	stosd
	pop	esi
	;;;
	ret	    
pktypes_inc:
	db	PACKET_HOST
		dd	0
		dd	0
	db	PACKET_BROADCAST
		dd	0
		dd	0
	db	PACKET_MULTICAST
		dd	0
		dd	0
	db	PACKET_OTHERHOST
		dd	0
		dd	0
	db	PACKET_OUTGOING
		dd	0
		dd	0
pktypes_inc_l	equ	$-pktypes_inc
;;INPUT: esi=*types_pattern, ebx=pkttype;
typeexists:
	    lodsb
	    movzx ecx,al
	    sub	bh,bh
	    clc
	    cld
	.lp:
	    lodsb
	    cmp	al,'a'
	    jnz	.nx1
	    setz bh
	    inc esi
	    ;;;
	    ret
	.nx1:
	    cmp	al,byte[pkt_types+ebx]
	    jnz	.nx
	    setz bh
	.nx:
	    inc esi
	    dec	ecx
	    jnz	.lp
	    ;;;
	    ret
w2dbg:
	dd	packet.dev
	dd	txt4
    .n:	dd	0
	dd	txt4
	dd	0
update_log_file_ssig:
	mov	eax,67
	mov	ebx,SIGALRM
	mov	ecx,.sigstruct
	sub	edx,edx
	int	0x80
	mov	eax,104
	mov	ebx,ITIMER_REAL
	mov	ecx,.value
	sub	edx,edx
	int	0x80
	or	eax,eax
	js	.er
	;;;
	ret
.er:
	push eax
	    mov esi,error_m.s12
	    call write2
	pop eax
	jmp @error
.sigstruct:
	dd	start_on_timer
	dd	0
	dd	SA_RESTART|SA_NOCLDSTOP|SA_NOMASK
	dd	0
	dd	0
.value2:
.time_val12:
	dd	0
	dd	0
.time_val22:
	dd	0
	dd	0	
.value:
.time_val1:
	dd	1
	dd	0
.time_val2:
	dd	1
	dd	0
update_log_file:
	sub	ecx,ecx
    .lp:
	mov	esi,log_file_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LOG_FILE
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_log_by_iface_timer
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_log_by_iface_timer:
	mov	dword[.nfunc],ecx
	lodsb
	sub	al,MAXPC_LOG_FILE
	jz	.nx2
	js	.nx2
	mov	eax,err_sPC
	call	write
	call	@exit		
    .nx2:
	mov	dword[.flSaddr],esi
	mov	eax,93
	mov	esi,dword[.flSaddr]
	mov	ebx,dword[esi]
	sub	ecx,ecx
	int	0x80		    
	mov	esi,start_table
	
	    .lp:
		mov	dl,DB_ID_LOG
		call	find_in_db
		jc	.nx
		lodsd
		sub eax,dword[.nfunc]
		jnz .nx1		
		push	ebx
		    call .do_write
		pop	ebx
	    .nx1:
		mov	esi,ebx
		jmp	short .lp
    .do_write:
		mov	edi,main_buffer
		call generate_log
		mov	al,0xA
		stosb
		sub	al,al
		stosb
		mov	edi,main_buffer
		call	strlen
		mov	edx,ecx
		mov	esi,dword[.flSaddr]
		mov	ebx,dword[esi]		
		mov	eax,4
		mov	ecx,main_buffer
		int	0x80
		;;;
		ret
	.nx		
	;;;
	ret
.nfunc	dd	0
.flSaddr dd	0
generate_log:
	call	strcat
	inc	esi
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
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>