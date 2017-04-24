;;save_on_time;
	mov	esi,save_on_time_buffer
	lodsd
	lodsb
	cmp	al,MAXPC_SAVE_ON_TIME
	jz	.nx
	mov	eax,err_sPC
	call	write
	call	@exit	
    .nx:
	mov	edi,main_buffer
	call	strcat_z
	mov	esi,process.dev
	mov	edi,main_buffer
	call	split
	mov	ebx,main_buffer
	call	file_exists
	js	.next
	mov	ebx,main_buffer
	call	mmap_file
	cmp 	dword[mmap_buf.len],0
	jz	.unl
	push	eax
	 mov 	esi,eax	 
	 lodsd
	 mov	ebp,eax
    .lp:
	 lodsd
	 or  eax,eax
	 jz .nx_ex
	 mov 	ebx,eax
	 sub 	eax,ebp
	 mov	ecx,eax
	 sub	ecx,5
	 mov	ebp,ebx
	 lodsb	 
	 mov	dl,al
	 push ecx
	  push esi
	   call	add_to_db
	  pop esi
	 pop ecx	 
	 lea esi,[ecx + esi]
	 jmp short .lp
    .nx_ex:
	pop	ebx
	mov	eax,91
	mov	ecx,dword[mmap_buf.len]
	int	0x80	;munmap
	mov	eax,6
	mov	ebx,dword[mmap_buf.fd]
	int	0x80	;close
    .unl:
	mov	eax,10
	mov	ebx,main_buffer
	int	0x80	;unlink
    .next:	;;doesn`t exists;
	mov	eax,5
	mov	ebx,main_buffer
	mov	ecx,(O_RDWR|O_CREAT|O_APPEND)
	mov	edx,110100100b	;rw-r--r--
	int	0x80
	or	eax,eax
	js	@error_file_o
	mov	dword[.fd],eax
	mov	edx,sot_timer
	call	add_to_timer_f
	;;;
	ret
.fd	dd	0
;.tbl	db	DB_ID_LOG, DB_ID_LOG_BIP, DB_ID_LBE, DB_ID_LBP
;	db	DB_ID_LBE_PORT, DB_ID_LB_PROTO, DB_ID_LB_PROTO_EACH
;	db	DB_ID_LBP_IP, DB_ID_LBP_IP_EACH, DB_ID_LBEP_EIP
;	db	DB_ID_LBE_LOCAL, DB_ID_LOG_BIP_LOCAL, DB_ID_LB_PROTO_IP
;	db	DB_ID_LB_PROTO_IP_EACH, DB_ID_LB_EPROTO_EIP
;	db	DB_ID_LS_BY_IFACE, DB_ID_LS_BY_IFACE_JOINT
;	db	DB_ID_LBE_LS_EACH, DB_ID_LBE_LS_EACH_JOINT
;	db	DB_ID_IP_ENTRY_LIST, DB_ID_IP_LIMIT, DB_ID_IPE_LIMIT
;	db	DB_ID_PR_LIMIT, DB_ID_ECPR_LIMIT, DB_ID_PROTO_LIMIT
;	db	DB_ID_ECPROTO_LIMIT, DB_ID_PR_LIMIT_IP
;	db	DB_ID_PR_LIMIT_IP_EACH, DB_ID_EPR_LIMIT_EIP
;	db	DB_ID_PROTO_IP_LIMIT, DB_ID_PROTO_EIP_LIMIT
;	db	DB_ID_EPROTO_EIP_LIMIT, DB_ID_IFACE_LIMIT, DB_ID_LS_PORT_EIP
;	db	DB_ID_LS_PORT_EIP_JOINT, DB_ID_LS_EPORT_EIP, DB_ID_LS_EPORT_EIP_JOINT
;	db	DB_ID_LS_PROTO_EIP, DB_ID_LS_PROTO_EIP_JOINT, DB_ID_LS_EPROTO_EIP
;	db	DB_ID_LS_EPROTO_EIP_JOINT, DB_ID_FULL_LBEP_EIP
;	db	DB_ID_LS_FULL_BEP_EIP, DB_ID_LS_FULL_BEP_EIP_JT
;	db	DB_ID_LBE_LS_EACH_LOCAL, DB_ID_LBE_LS_EACH_JOINT_LOCAL
;	db	0
sot_timer:
	mov	ebx,dword[func_save_on_time.fd]
	mov	eax,93
	sub	ecx,ecx
	int	0x80	;ftruncate
	mov	dword[.addr_table],start_table
	mov	eax,4
	mov	ecx,.addr_table
	mov	edx,4
	int	0x80
	mov	eax,4
	mov	ecx,start_table
	mov	edx,dword[eodb]
	sub	edx,ecx
	add	edx,4
	int	0x80
	;;;
	ret
.addr_table	dd	0
;;INPUT: ebx=fd, dl=TYPE_TABLE;
;ftbl_to_file:
;	mov	dword[.fd], ebx
;	mov	byte[.type],dl
;	mov	esi,start_table
;    .lpf:
;	mov	dl,byte[.type]
;	call	find_in_db
;	jc	.lpe
;	    push ebx
;	     mov	edi,main_buffer
;	     mov	edx,ebx
;	     sub	edx,esi
;	     mov	al,byte[.type]
;	     stosb
;	     mov	eax,edx
;	     stosd
;	     mov	ecx,edx
;	     rep	movsb
;	     add	edx,5
;	     mov	eax,4
;	     mov	ebx,dword[.fd]
;	     mov	ecx,main_buffer
;	     int	0x80
;	    pop ebx
;	mov	esi,ebx
;	jmp short .lpf
;    .lpe:
;	;;;
;	ret
;.fd	dd	0
;.type	db	0
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>