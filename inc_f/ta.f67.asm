;;func_ip_range_traf_limit;
	sub	ecx,ecx
    .lp:
	mov	esi,ip_range_traf_limit_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_IP_RANGE_TL
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_ipr_tl
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_ipr_tl:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_IP_RANGE_TL
	jz	.nex_1
	sub	al,(MAXPC_IP_RANGE_TL-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	call	NSkipLM
	call	NSkipIP	
	call	to_zero	
	mov	dword[name_deny_addr],esi
	mov	dword[some_f_name_deny],0
	mov	esi,dfuncs_ntable
	call	run_f
	test	dword[some_f_name_deny],1
	jz	.next
	;;;
	ret	
    .next:
	mov esi,dword[name_esi_tmp]
	call NSkipLM
	mov dword[.ipad],esi
	call Qallow_ipN
	jc near	.ex
	mov dword[limit_def.sh],esi
	call to_zero
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_IP_LIMIT
	call	find_in_db
	jc	.lpe
	lodsd
	sub eax,dword[current.nfunc]
	jz .innc
	mov	esi,ebx
	jmp short .lpf
    .innc:
	mov	dword[.la],esi
	call NSkipLM
	mov	dword[limit_def.in],esi
	call to_zero    
	mov	dword[limit_def.ip],esi
	call	to_zero
	mov	dword[.ca],esi
	call	set_packet_increment
	mov	eax,dword[.ca]
	mov	ebx,dword[.la]
	mov	word[limit_def.lt],'IR'
	call	climit	
    .ex:
	;;;
	ret
    .lpe:	;;ADD TO;
		;pktypes_inc
	mov	edi,main_buffer
	mov	eax,dword[current.nfunc]
	stosd
	mov	esi,dword[name_esi_tmp]
	push esi
	  call	GlmLEN
	pop esi
	mov ebp,ecx
	cld
	rep	movsb
	mov	edx,edi
	mov	esi,process.dev
	call	strcat_z
	 mov	ecx,edi
	 sub	ecx,edx
	 add	ebp,ecx
	mov	esi,dword[.ipad]
	push	edi
	 call	ip_ranges_to_str
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
	mov	dl,DB_ID_IP_LIMIT
	call	add_to_db
	
	;;;
	ret	
.first	db	0
.st	db	0
.ipad	dd	0
.la	dd	0
.ca	dd	0

limit_def:
	.ip	dd	0
	.tp	dd	0
	.lm	dd	0
	.sh	dd	0
	.pr	dd	0
	.po	dd	0
	.in	dd	0
	.rp	dd	0
	.op	dd	0
	.lt	dw	0
		
sh_params:
	    dd	shell_name
	    dd	.p1
    .p2:    dd	0
	    dd	0
    .p1		db	"-c",0
    
shell_name	db	"/bin/bash",0

on_timer_ip_limit:
	;;;
	ret
run_shell:
	mov edi,main_buffer
	mov esi,dword[limit_def.sh]
	call fill_lm_sh
	mov dword[sh_params.p2],main_buffer	
	mov	eax,114
	mov	ebx,-1
	xor	ecx,ecx
        mov	edx,WUNTRACED
	xor	esi,esi
	int	0x80	;sys_wait4
	mov	eax,2
	int	0x80
	or	eax,eax
	jnz	.next
	  mov	eax,11
	  mov	ebx,shell_name
	  mov	ecx,sh_params		;ecx -- arguments (**)
	  mov	edx,dword[penv]		;edx -- environment (**)
	  int 	0x80
	 call	@exit
    .next:
	;;;
	ret
fill_lm_sh:
	lodsb
	cmp al,'%'
	jz	.perc
	or al,al
	jz .end
	stosb
	jmp short fill_lm_sh
    .end:
	sub al,al
	stosb
	;;;
	ret
.perc:
	lodsb
	or al,al
	jz .end
	mov ah,al
	lodsb
	or al,al
	jnz .nx_perc
	mov bl,al
	mov al,'%'	
	stosb
	mov al,bl
	xchg ah,al
	stosw
	;;;
	ret
.nx_perc:
	mov bx,ax
	push esi
	 mov esi,.table
    .lp_t:
	 lodsw
	 xchg ah,al
	 cmp ax,bx
	 jz .do_t
	 or ax,ax
	 jz .nf
	 lodsd
	 jmp short .lp_t
.nf:
	pop esi
	mov al,'%'
	stosb	
	mov ax,bx
	xchg ah,al
	stosw
	jmp short fill_lm_sh
.do_t:
	lodsd
	call eax
	pop esi
	jmp short fill_lm_sh
.put_ip:
	mov esi,dword[limit_def.ip]
	call strcat
	;;;
	ret
.put_tp:
	mov al,byte[packet.ptype]
	mov byte[.sv_pack],al
	mov eax,dword[limit_def.tp]
	mov byte[packet.ptype],al
	call ptype
	mov al,byte[.sv_pack]
	mov byte[packet.ptype],al
	;;;
	ret
.sv_pack	db	0
.put_lm:
	mov esi,dword[limit_def.lm]
	lodsd
	mov edx,eax
	lodsd
	call d64_2s
	dec edi
	;;;
	ret
.put_lt:
	mov ax,word[limit_def.lt]
	stosw
	;;;
	ret
.put_pr:
	mov eax,dword[limit_def.pr]
	call d2s
	dec edi	
	;;;
	ret
.put_po:
	mov esi,dword[limit_def.po]
	call strcat
	;;;
	ret
.put_in:
	mov esi,dword[limit_def.in]
	call strcat
	;;;
	ret
.put_rp:
	mov esi,dword[limit_def.rp]
	call strcat
	;;;
	ret
.put_op:
	mov esi,dword[limit_def.op]
	call strcat
	;;;
	ret
.table:
	db	"IP"
	    dd	.put_ip
	db	"TP"
	    dd	.put_tp
	db	"LM"
	    dd	.put_lm
	db	"LT"
	    dd	.put_lt
	db	"PR"
	    dd	.put_pr
	db	"PO"
	    dd	.put_po
	db	"IN"
	    dd	.put_in
	db	"RP"
	    dd	.put_rp
	db	"OP"
	    dd	.put_op
	dw	0
climit:
	mov dword[.ca],eax
	mov dword[.la],ebx
	mov esi,ebx
	lodsb	
	or al,al
	jz .ex
	movzx ecx,al
    .lp:
	lodsb
	;test al,1
	;jnz .nx
	lodsb
	call .chk_lim	
	jnc .nx
	push esi
	 push ecx
	  call run_shell
	 pop ecx
	pop esi
    .nx:
	add esi,8
	dec ecx
	jnz .lp
    .ex:
	;;;
	ret
.chk_lim:	
	push esi
	 mov edx,esi
	 movzx ebx,al
	 mov dword[limit_def.tp],ebx
	 mov esi,dword[.ca]
	 lea esi,[esi + ebx*8 + 1]
	 add esi,ebx
	 mov dword[limit_def.lm],edx
	 lodsd	 
	 cmp eax,dword[edx]
	 jz .c_1
	 ja .lm
	 jb .ex_nlm
    .c_1:
	 lodsd
	 cmp eax,dword[edx + 4]
	 jb .ex_nlm
    .lm:
	 mov dword[esi - 4],0
	 mov dword[esi - 8],0
	 pop esi
	 stc
	 ;;;
	 ret
    .ex_nlm:	 
	 pop esi
	 clc
	 ;;;
	 ret
.ca	dd	0
.la	dd	0
NSkipLM:
	lodsb
	movzx ecx,al
	imul ecx,ecx,10
	add esi,ecx		
	;;;
	ret
GlmLEN:
	push esi
	call NSkipLM
	pop ecx
	xchg ecx,esi
	sub ecx,esi
	;;;
	ret