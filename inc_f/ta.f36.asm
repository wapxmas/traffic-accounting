;;full_stat_global;
	sub	ecx,ecx
    .lp:
	mov	esi,full_stat_global_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_FULL_STAT_GLOBAL
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_stat_fgb
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_stat_fgb:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_FULL_STAT_GLOBAL
	jz	.nex_1	
	sub	al,(MAXPC_FULL_STAT_GLOBAL-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	mov	dword[file_estart], esi
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
	lodsd
	mov dword[.fd],eax
	call to_zero
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	.ex
	mov	edi,stat_buffer.s1
	 call	add_fgstat
	mov	edi,stat_buffer.s1
	call	strlen
	mov	edx,ecx
	mov	ebx,dword[.fd]
	mov	ecx,stat_buffer.s1
	call	add_traffic
    .ex:
	;;;
	ret
.fd	dd	0
;;INPUT: ebx=fd, edx=length, ecx=*data;
add_traffic:
	cld
	mov	dword[.fd],ebx
	mov	edi,traffic_buffer
	cmp	dword[edi],0
	jz	near .zero
	cmp	dword[edi],TRAFFIC_PCOUNT
	jz	.flush
	inc	dword[edi]
	add	edi,4
	lea	eax,[edx + 8]
	mov	ebx,dword[edi]
	add	dword[edi],eax
	lea	edi,[edi + ebx + 4]
	mov	esi,ecx
	stosd	;len
	mov	eax,dword[.fd]
	stosd	;fd
	mov	ecx,edx
	shr	ecx,2	
	rep	movsd
	mov	ecx,edx
	and	ecx,3
	rep	movsb	
	;;;
	ret
.flush:	
	mov	esi,traffic_buffer
	mov	ebp,dword[esi]
	or	ebp,ebp
	jz	.ex
	mov	dword[esi],0
	add	esi,8
    .lp:
	lodsd
	mov edx,eax	
	lodsd	
	mov ebx,eax	
	mov ecx,esi
	sub edx,8
	add esi,edx
	mov eax,4
	int 0x80
	dec ebp
	jnz .lp
    .ex:
	;;;
	ret
.zero:
	mov	eax,1
	stosd	;count
	lea	eax,[edx + 8] ;len
	stosd	;offset for the next entry
	stosd	;len
	mov	eax,ebx
	stosd	;fd
	mov	esi,ecx	
	mov	ecx,edx
	shr	ecx,2	
	rep	movsd
	mov	ecx,edx
	and	ecx,3
	rep	movsb
	;;;
	ret
.fd	dd	0
add_fgstat:
	;push	esi	    
	    mov	esi,packet.dev
	    call strcat
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"s:"
	     stosw	    
	    mov	ebx,dword[packet.sa]
	    bswap ebx
	    call ipn2s
	    dec	edi
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"d:"
	     stosw	    
	    mov	ebx,dword[packet.da]
	    bswap ebx
	    call ipn2s
	    dec edi
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"l:"
	     stosw	    
	    mov	eax,dword[packet.len]
	    call d2s
	    dec edi
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"t:"
	     stosw	    
	    call ptype
	    mov al,byte[spec_ch]
	    stosb
	     mov eax,"ttl:"
	     stosd	    
	    movzx eax,byte[packet.ttl]
	    call d2s
	    dec edi
	    mov al,byte[spec_ch]
	    stosb
	     mov eax,"prot"
	     stosd
	     mov ax,"o:"
	     stosw	    
	    movzx eax,byte[packet.proto]
	    call d2s
	    dec edi
	    call tports
	    jc	.nx
	    mov bl,byte[packet.proto]
	    push edi
		call gp_by_proto
	    pop edi
	    mov al,[spec_ch]
	    stosb
	     mov ax,"sp"
	     stosw
	     mov al,":"
	     stosb	    
	    movzx eax,word[gp_by_proto.sport]
	    call d2s
	    dec edi
	    mov al,[spec_ch]
	    stosb
	     mov ax,"dp"
	     stosw
	     mov al,":"
	     stosb	    
	    movzx eax,word[gp_by_proto.dport]
	    call d2s
	    dec edi
	.nx:
	    cmp dword[use_time_stamp],0
	    je	.nxti
	    mov al,byte[spec_ch]
	    stosb
	    mov	eax,13
	    sub	ebx,ebx
	    int	0x80
	    call d2s
	    dec	edi
	.nxti:
	    mov al,0xA
	    stosb
	    sub	al,al
	    stosb
	;pop	esi
	;;;
	ret
tports:
	xchg ecx,edx
	mov esi,.types
	lodsd
	mov ecx,eax
	cld
    .lp:
	lodsb
	sub al,[packet.proto]
	jz .ok
	dec ecx
	jnz .lp
	xchg ecx,edx
	stc
	;;;
	ret
    .ok:
	xchg ecx,edx
	clc
	;;;
	ret
.types	dd	2
	db	17	;TCP
	db	6	;UDP
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>		