;;stat_by_ip_global();
	sub	ecx,ecx
    .lp:
	mov	esi,stat_by_ip_global_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_STAT_BY_IP_GLOBAL
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_stat_big
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_stat_big:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_STAT_BY_IP_GLOBAL
	jz	.nex_1
	sub	al,(MAXPC_STAT_BY_IP_GLOBAL-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	    
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	call	NSkipIP
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
	lodsb
	movzx	ecx,al
	mov	byte[.st],0
    .lp:
	push	ecx
	call	Qallow_ip
	jc	.ce
	setnc	byte[.st]
    .ce:
	pop	ecx
	dec	ecx
	jnz	.lp
	test	byte[.st],1
	jnz	.ipa
	;;;
	ret
.st	db	0
    .ipa:
	lodsd
	mov	dword[.fd],eax
	call	to_zero
	movzx	ebx,byte[packet.ptype]
	call	typeexists
	or	bh,bh
	jz	.ex
	mov	edi,stat_buffer.s3
	call	add_gstat
	mov	edi,stat_buffer.s3
	call	strlen
	mov	edx,ecx
	mov	ebx,dword[.fd]
	mov	ecx,stat_buffer.s3
	call	add_traffic
    .ex:	
	;;;
	ret
.fd	dd	0
Qallow_ip:
	lodsb
	push	dword .chk
	test	al,IPTYPE_SRC
	jz	.nx
	mov	ecx,[packet.sa]
	bswap	ecx
	;;;
	ret
    .nx:
	test	al,IPTYPE_DST
	jz	.nx1
	mov	ecx,[packet.da]
	bswap	ecx
	;;;
	ret
    .nx1:
	test	al,IPTYPE_ALL
	jz	.nx2
	mov	ecx,[packet.sa]
	mov	edx,[packet.da]
	bswap	ecx
	bswap	edx
	;;;
	ret
    .nx2:
	mov	eax,err_ip_range
	call	write
	call	@exit
    .chk:
	test	al,IPTYPE_MASK
	jnz	.mask
	test	al,IPTYPE_RANGE
	jz	.ch
	    ;;RANGE;	
		push eax
		mov dword[.tmp_esi],esi
		or byte[.types],IPTYPE_SRC
		call do_range
		jc .chk_na
		pop eax
		clc
		;;;
		ret
    .mask:
	mov byte[.tal],al
	lodsd
	mov ebx,eax
	lodsd
	and ebx,eax
	and ecx,eax
	or byte[.types],IPTYPE_SRC
	cmp ebx,ecx
	jz .ok_chk
	and byte[.types],~IPTYPE_SRC
	test byte[.tal],IPTYPE_ALL
	jz .chk_er
	or	byte[.types],IPTYPE_DST
	and edx,eax
	cmp ebx,edx
	jz .ok_chk
	stc
	;;;
	ret
    .chk_na:
	pop eax
	and byte[.types],~IPTYPE_SRC
	test al,IPTYPE_ALL
	jz .chk_er
	or byte[.types],IPTYPE_DST
	mov ecx,edx
	mov esi,dword[.tmp_esi]
	call do_range
	jc .chk_er
	;clc
	;;;
	ret
	    ;;END RANGE;
    .ch:
	mov	byte[.tal],al
	lodsd
	or	byte[.types],IPTYPE_SRC
	cmp	eax,ecx
	jz	.ok_chk
	and	byte[.types],~IPTYPE_SRC	
	mov	ebx,eax
	mov	al,byte[.tal]
	test	al,IPTYPE_ALL
	jnz	.chk2
    .chk_er:
	stc
	;;;
	ret
    .chk2:
	or	byte[.types],IPTYPE_DST
	cmp	ebx,edx
	jz	.ok_chk
	jnz	.chk_er
    .ok_chk:
	clc
	;;;
	ret
.tal		dd	0
.tmp_esi	dd	0
.types		db	0
do_range:
	lodsb
	movzx ebx,al
	mov bh,3
	setz byte[.flg]
	bswap ecx
    .lp:
	lodsb
	push ecx
	    movzx ecx,bh
	    bt ebx,ecx
	    jnc	.schk
	    pop ecx
	    mov ah,al
	    lodsb
	    cmp cl,al
	    ja	.ee
	    cmp cl,ah
	    jb	.ee
	    jmp short .nx
    .schk:
	pop ecx
	cmp al,cl
	jnz .ee
    .nx:
	ror ecx,8
	dec bh
	jns .lp
	test byte[.flg],1
	jz .ok
	stc
	;;;
	ret
    .ok:
	clc
	;;;
	ret
.ee:
    mov byte[.flg],1
    jmp short .nx
.flg	db	0
err_ip_range:	db	"Error: ip range is wrong",0xA,0
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	