;;rs_by_port_global;
	sub	ecx,ecx
    .lp:
	mov	esi,rs_by_port_global_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_RS_BY_PORT_GLOBAL
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_rs_by_port_global
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_rs_by_port_global:
	lodsb
	cmp	al,MAXPC_RS_BY_PORT_GLOBAL
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	
    .next:
	lodsd
	cmp al,byte[packet.ipproto]
	jz .nx
	;;;
	ret
    .nx:
	push esi
	  mov bl,al
	  call gp_by_proto
	pop esi
	call QallowPort
	test byte[QallowPort.fl],1
	jz .ex
	setnz byte[some_f_call_deny]
    .ex:
	;;;
	ret
NSkipPort:
	lodsb
	movzx ecx,al
    .lp:
	lodsb
	test al,PTYPE_RANGE
	jz .nr
	lodsd
    .nr: lodsd
	dec ecx
	jnz .lp
	;;;
	ret
NSkipSynum:
	lodsb
	movzx ecx,al
    .lp:
	lodsb
	test al,PPT_RANGE
	jz .nr
	lodsd
    .nr: lodsd
	dec ecx
	jnz .lp
	;;;
	ret
QallowPortN:
	mov	dword[.src],0
	mov	word[.sp],ax
	mov	word[.dp],dx
	mov	dx,ax
	push	esi
	 call QallowPort
	pop	esi
	test byte[QallowPort.fl],1
	jz .nx
	setnz byte[.src]
    .nx:
	mov ax,word[.dp]
	mov dx,ax
	call QallowPort
	test byte[QallowPort.fl],1
	jz .nx1
	setnz byte[.dst]
    .nx1:
	test word[.src],0xffff
	jz .er
	setnz byte[.fl]
	;;;
	ret
    .er:
	setnz byte[.fl]
	;;;
	ret
.sp	dw	0
.dp	dw	0
.src	db	0
.dst	db	0
.fl	db	0
.t	db	0
QallowPort:
	mov word[.sp],ax
	mov word[.dp],dx
	mov dword[.fl],0	
	lodsb
	movzx ecx,al
    .lp:
	push ecx
	mov byte[.types],0
	call .chk_port
	jc .nx
	setnc byte[.fl]
	test byte [.types],PTYPE_SRC
	jz .t_dst
	setnz byte[.src]
      .t_dst:
        test byte [.types],PTYPE_DST
	jz .nx
	setnz byte[.dst]
    .nx:    
	pop ecx
	dec ecx
	jnz .lp
	;;;
	ret
.sp	dw	0
.dp	dw	0
.fl	db	0
.src	db	0
.dst	db	0
.tmp	db	0
.chk_port:
	push dword .chk
	lodsb
	mov byte[.type],al
	test al,PTYPE_SRC
	jz .tdst
	mov bx,word[.sp]
	;;;
	ret
    .tdst:
	test al,PTYPE_DST
	jz .tall
	mov bx,word[.dp]
	;;;
	ret
    .tall:
	test al,PTYPE_ALL
	jz .er_p
	mov bx,word[.sp]
	mov dx,word[.dp]
	;;;
	ret
    .er_p:
	mov eax,err_port
	call write
	call @exit
    .chk:
	test al,PTYPE_RANGE
	jz .normal
	lodsd
	mov cx,ax
	lodsd
	or byte[.types],PTYPE_SRC
	cmp bx,cx
	jb .c_all	
	cmp bx,ax
	ja .c_all
	clc
	;;;
	ret
    .c_all:
	and byte[.types],~PTYPE_SRC
	or byte[.types],PTYPE_DST
	test byte[.type],PTYPE_ALL
	jz .er
	cmp dx,cx
	jb .er
	cmp dx,ax
	ja .er
	clc
	;;;
	ret
    .normal:
	lodsd
	or byte[.types],PTYPE_SRC
	cmp ax,bx
	jz .ok
	and byte[.types],~PTYPE_SRC
	test byte[.type],PTYPE_ALL
	jz .er
	or byte[.types],PTYPE_DST
	cmp ax,dx
	jz .ok
    .er:
	stc
	;;;
	ret
    .ok:
	clc
	;;;
	ret
.type	db	0
.types	db	0
;;get ports by proto;
;;INPUT: ebx=proto;
;;OUT: .sport, .dport;
gp_by_proto:
	mov dword[.sport],0
	mov esi,protoP_table
	lodsb
	movzx ecx,al
    .lp:
	lodsb
	cmp al,bl
	jz .founded
	lodsd
	dec ecx
	jnz .lp
	;;;
	ret
.founded:
	lodsd
	call eax
	mov word[.sport],ax
	mov word[.dport],dx
	;;;
	ret
.sport	dw	0
.dport	dw	0
protoP_table:
	    db	2	;COUNT
		db	6	;TCP
		    dd	g_tcp_ports
		db	17	;UDP
		    dd	g_udp_ports
g_tcp_ports:
    mov edi,dword[packet.ipdata]
    movzx edx,byte[edi + iphdr.ihl]
    and edx,0x0f
    imul edx,edx,4
    add edi,edx
    mov ax,word[edi + tcphdr.source]
    xchg ah,al
    mov dx,word[edi + tcphdr.dest]
    xchg dh,dl
    ;;;
    ret
g_udp_ports:
    mov edi,dword[packet.ipdata]
    movzx edx,byte[edi + iphdr.ihl]
    and edx,0x0f
    imul edx,edx,4
    add edi,edx
    mov ax,word[edi + udphdr.source]
    xchg ah,al
    mov dx,word[edi + udphdr.dest]
    xchg dh,dl    
    ;;;
    ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	    