;;rs_by_proto_global();
	sub	ecx,ecx
    .lp:
	mov	esi,rs_by_proto_global_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_RS_BY_PROTO_GLOBAL
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_rs_by_proto_global
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
    ;;;
    ret
do_rs_by_proto_global:
	lodsb
	cmp	al,MAXPC_RS_BY_PROTO_GLOBAL
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	    
    .next:
	call QallowSN
	test byte[QallowSN.fl],1
	jz .nx
	setnz byte[some_f_call_deny]
    .nx:
	;;;
	ret
QallowSN:
	mov byte[.fl],0
	lodsb
	movzx ecx,al
	mov dl,byte[packet.ipproto]
    .lp:
	call chk_proto
	jc .nx
	setnc byte[.fl]
    .nx:
	dec ecx
	jnz .lp
	;;;
        ret
.fl	db	0
;;INPUT:dl=PROTOnum;
;;OUT: cf=1 if error, otherwise OK;
chk_proto:
	lodsb
	test al,PPT_NORMAL
	jnz .chkn
	lodsd
	mov ebx,eax
	lodsd
	cmp dl,bl
	jb .nxE
	cmp dl,al
	ja .nxE
	clc
	;;;
	ret
 .chkn:
	lodsd
	cmp al,dl
	jne .nxE
	clc
	;;;
	ret
 .nxE:
	stc
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>		