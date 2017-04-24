;;func_ls_by_proto_ip_each;
	sub	ecx,ecx
    .lp:
	mov	esi,ls_by_proto_ip_each_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LS_BY_PROTO_EIP
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_ls_by_proto_ip_each
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_ls_by_proto_ip_each:	
	test	byte[.first],1
	jnz	.next2
	setz	byte[.first]
	mov	edx,on_timer_ls_by_proto_ip_each
	call	add_to_timer_f
    .next2:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LS_BY_PROTO_EIP
	jz	.nex_1
	sub	al,(MAXPC_LS_BY_PROTO_EIP-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	call	to_zero
	call	NSkipIP
	call	NSkipProto
	call	to_zero
	call	NSkipEnum
	call	to_zero
	call	to_zero
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
	mov	esi,dword[name_esi_tmp]
	call	to_zero
	call Qallow_ipN
	jc .ex
	call QallowSN
	test byte[QallowSN.fl],1
	jz .ex	
	call to_zero
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	.ex
	test	byte [Qallow_ipN.dst],1
	jz	.tsrc
	setz	byte[inc_by_proto_ip_each_ls.type]
	mov	eax,dword[packet.da]
	bswap	eax
	call	inc_by_proto_ip_each_ls
    .tsrc:	
		test	byte [Qallow_ipN.src],1
		jz	.ex		
		setnz	byte[inc_by_proto_ip_each_ls.type]
		mov	eax,dword[packet.sa]
		bswap	eax
		call	inc_by_proto_ip_each_ls
    .ex:
	;;;
	ret
.first		db	0
.protocol	db	0
.st	db	0
.tpsrc	db	0
inc_by_proto_ip_each_ls:
	mov	byte[.table],DB_ID_LS_PROTO_EIP
	push	eax
	 call	.inc_by_proto_ip_each
	pop eax
	mov	byte[.table],DB_ID_LS_PROTO_EIP_JOINT
	call	.inc_by_proto_ip_each	
	;;;
	ret
.inc_by_proto_ip_each:
	mov	dword[.addr], eax
	mov	esi,start_table
    .lpf:
	mov	dl,byte[.table]
	call	find_in_db
	jc	.lpe
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .nx
	    call to_zero
	    lodsd
	    cmp eax,dword[.addr]
	    jz	.do_inc
    .nx:
	mov	esi,ebx
	jmp short .lpf
    .do_inc:
	call	to_zero
	mov	al,byte[.type]
	call	inc_packet_by_type
	;;;
	ret
    .lpe:	;;ADD TO;
	mov	edi,main_buffer
	mov	eax,dword[current.nfunc]
	stosd
	mov	esi,packet.dev
	mov	edx,edi
	call	strcat_z
	 mov ecx,edi
	 sub ecx,edx
	 mov ebp,ecx
	mov	eax,dword[.addr]
	stosd
	mov	esi,dword[name_esi_tmp]
	call	to_zero
	call	NSkipIP
	push	edi
	call	proto_ranges_to_str
	pop	eax
	 mov ecx,edi
	 sub ecx,eax
	 add ebp,ecx
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	push	edi
	rep	movsb
	pop	esi
	mov	al,byte[.type]
	call	inc_packet_by_type	
	mov	esi,main_buffer
	mov	dl,byte[.table]
	mov	ecx,pktypes_inc_l+4+4
	add	ecx,ebp
	call	add_to_db
	;;;
	ret
.addr	 dd	0	    
.SvProto dd	0
.type	 db	0
.table	db	0
.pad	dd	0
.first	db	0

on_timer_ls_by_proto_ip_each:
	sub	ecx,ecx
    .lp:
	mov	esi,ls_by_proto_ip_each_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LS_BY_PROTO_EIP
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_lbp_each_timer_proto_ls
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret	
	
do_lbp_each_timer_proto_ls:
	mov	dword[.nfunc],ecx
	lodsb
	mov	dword[name_esi_tmp_timer],esi
	cmp	al,MAXPC_LS_BY_PROTO_EIP
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit		
    .next:
	call	to_zero
	call	NSkipIP
	call	NSkipProto
	mov	dword[.fnm],esi
	call	to_zero
	call	NSkipEnum
	mov	edi,main_buffer
	call	dformat_str
	mov	dword[.ext],esi
	call	to_zero
	cmp	byte[esi],'t'
	setz	byte[.t_only]
	mov	edi,tm
	mov	esi,tzfilename
	call	date
	mov	eax,91
	mov	ebx,dword[mmap_addr]
	mov	ecx,dword[mmap_buf.len]
	int	0x80		
	mov	eax,6
	mov	ebx,dword[mmap_buf.fd]
	int	0x80
	call	chk_over_date
	mov	dword[allow_value],1	;allowed, default
	mov	esi,main_buffer
	mov	edi,tm
	mov	ecx,dword[.nfunc]
	add	ecx,TIME_ID_7
	mov	dword[time_vid],ecx
	call	QallowTIME
	test	dword[allow_value],1
	jnz	.time_allowed		
	;;;
	ret
.time_allowed:
	test	byte[.t_only],1
	jnz	near .text_only
	cmp	byte[skin_path],0
	jz	.nx
	mov	esi,skin_path
	mov	edi,main_buffer
	call	strcat_z
	mov	esi,dword[name_esi_tmp_timer]
	mov	edi,main_buffer
	call	split
    .nx:
	mov	ebx,main_buffer
	call	file_exists
	js	near do_ls_by_iface_timer.skin_err1
	;;flush skins;
	mov	edi,ip_skin_buffer
	xor	eax,eax
	mov	ecx,skin_buffers_length
	shr	ecx,2
	mov	ebx,ecx
	rep	stosd
	mov	ecx,ebx
	and	ecx,11b
	rep	stosb
	;;flush end;
	mov	ebx,main_buffer
	mov	dword[c_file],ebx
	call	mmap_file
	mov	dword[mem_start_file],eax
	mov	dword[begin_vars],skin_conf
	call	parse_config_file
	mov	eax,91
	mov	ebx,dword[mmap_addr]
	mov	ecx,dword[mmap_buf.len]
	int	0x80		
	mov	eax,6
	mov	ebx,dword[mmap_buf.fd]
	int	0x80
	mov	esi,dword[.fnm]
	mov	edi,main_buffer2
	call	strcat
	mov	esi,dword[.ext]
	call	made_ext
	mov	eax,5
	mov	ebx,main_buffer2
	mov	ecx,(O_WRONLY|O_CREAT)
	mov	edx,110100100b	;rw-r--r--
	int	0x80
	or	eax,eax
	js	near .ferr
	mov	dword[cwrite_buffer_html.fd],eax
	mov	dword[skin_boffset],S_BUFFER		
	call	out_head
	 ;;current;
	 call	out_cr_traf
	  call	out_table
	   mov	byte[show_ls_by_proto_ip_each.table],DB_ID_LS_PROTO_EIP
	  call	show_ls_by_proto_ip_each
	 call	out_table_end	 
	 ;;joint;
	 call	out_jt_traf
	  call	out_table
	   mov	byte[show_ls_by_proto_ip_each.table],DB_ID_LS_PROTO_EIP_JOINT
	  call	show_ls_by_proto_ip_each
	 call	out_table_end
	call	out_end
	test	byte[show_ls_by_proto_ip_each.empty],1
	jnz	near do_ls_by_each_ip_timer_local.unlink_html
	mov	ebx,dword[cwrite_buffer_html.fd]
	test	byte[cwrite_buffer_html.fl],1
	jnz	.ex_flush
	mov	edi,S_BUFFER
	call	strlen
	mov	edx,ecx
	mov	ecx,S_BUFFER
	mov	eax,4
	int	0x80
.ex_flush:
	mov	eax,6
	int	0x80
	mov	byte[flush_table_ls_proto_ip_each_ls.table],DB_ID_LS_PROTO_EIP
	call	flush_table_ls_proto_ip_each_ls
    .ex:
	;;;
	ret
.ferr:
	mov	eax,.err2
	call	write
	;;;
	ret
.err2:	db	"ERROR: ls_by_proto_ip_each: cannot create file",0xA,0
.ext	dd	0
.fnm	dd	0
.nfunc	dd	0
.t_only	db	0

.text_only:
	mov	esi,dword[name_esi_tmp_timer]
	mov	edi,main_buffer
	call	to_zero
	call	NSkipIP
	call	NSkipProto
	call	strcat
	mov	esi,dword[.ext]
	call	made_ext
	mov	eax,5
	mov	ebx,main_buffer
	mov	ecx,(O_WRONLY|O_CREAT)
	mov	edx,110100100b	;rw-r--r--
	int	0x80
	or	eax,eax
	js	.ferr
	mov 	dword[cwrite_buffer.fd],eax
	mov	byte[S_BUFFER],0
	mov	edi,S_BUFFER	
	mov	esi,t_cr
	call	split
	mov	byte[show_ls_by_proto_ip_each_text.table],DB_ID_LS_PROTO_EIP
	call	show_ls_by_proto_ip_each_text
	mov	edi,S_BUFFER
	mov	esi,t_jt
	call	split
	mov	byte[show_ls_by_proto_ip_each_text.table],DB_ID_LS_PROTO_EIP_JOINT
	call	show_ls_by_proto_ip_each_text
	test	byte[show_ls_by_proto_ip_each_text.empty],1
	jnz	near do_ls_by_each_ip_timer_local.unlink
	mov	ebx,dword[cwrite_buffer.fd]
	cmp	byte[S_BUFFER],0
	jz	.close_fd
	mov	edi,S_BUFFER
	call	strlen
	mov	edx,ecx
	mov	ecx,S_BUFFER
	mov	eax,4
	int	0x80
    .close_fd:
	mov	eax,6
	int	0x80
	mov	byte[flush_table_ls_proto_ip_each_ls.table],DB_ID_LS_PROTO_EIP
	call	flush_table_ls_proto_ip_each_ls
	;;;
	ret
show_ls_by_proto_ip_each_text:

	mov	esi,start_table
	mov	byte[.empty],1
    .lpf:
	mov	dl,[.table]
	call	find_in_db
	jc	near .lpe
	    push ebx
		lodsd
		sub eax,dword[do_lbp_each_timer_proto_ls.nfunc]
		jnz .do_nxI
		setnz byte[.empty]
		mov dword[.tmp_e],esi
		call to_zero
		lodsd
		mov	dword[.tmp_b],eax
		mov	dword[.tmp_f],esi
		call	to_zero
		mov	dword[.tmp_c],esi
		dec	edi
		call	.do_show
		mov	ax,0x000A
		stosw		
	.do_nxI:
	    pop	ebx
	mov	esi,ebx
	jmp .lpf
    .lpe:	;;exit;
	;;;
	ret
.empty		db	0	
.ipSaddr	dd	0
.flSaddr	dd	0
.tmp_a		dd	0
.tmp_b		dd	0
.tmp_c		dd	0
.tmp_d		dd	0
.tmp_e		dd	0
.tmp_f		dd	0
.table	db	0

.do_show:
	mov	esi,dword[.tmp_e]
	call	strcat
	mov	al,byte[spec_ch]
	stosb
	mov	ebx,dword[.tmp_b]
	call 	ipn2s
	dec 	edi
	mov	al,byte[spec_ch]
	stosb
	mov	esi,dword[.tmp_f]
	call	strcat
	mov	esi,dword[.tmp_c]
	call	generate_log2
	;;;
	ret

flush_table_ls_proto_ip_each_ls:
	mov	esi,start_table	
    .lpf:
	mov	dl,[.table]
	call	find_in_db
	jc	near .lpe
	    push ebx
		lodsd
		sub eax,dword[do_lbp_each_timer_proto_ls.nfunc]
		jnz .do_nxI		
		call 	to_zero
		add	esi,4
		call	to_zero
		call	flush_packets		
	.do_nxI:
	    pop	ebx
	mov	esi,ebx
	jmp .lpf
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
.tmp_f		dd	0
.table	db	0

show_ls_by_proto_ip_each:

	mov	esi,start_table
	mov	byte[.empty],1
    .lpf:
	mov	dl,[.table]
	call	find_in_db
	jc	near .lpe
	    push ebx
		lodsd
		sub eax,dword[do_lbp_each_timer_proto_ls.nfunc]
		jnz .do_nxI
		setnz byte[.empty]
		mov dword[.tmp_e],esi
		call to_zero
		lodsd
		mov	dword[.tmp_b],eax
		mov	dword[.tmp_f],esi
		call	to_zero
		mov	dword[.tmp_c],esi
		call	.do_show
		call 	cwrite_buffer_html
	.do_nxI:
	    pop	ebx
	mov	esi,ebx
	jmp .lpf
    .lpe:	;;exit;
	;;;
	ret
.empty		db	0	
.ipSaddr	dd	0
.flSaddr	dd	0
.tmp_a		dd	0
.tmp_b		dd	0
.tmp_c		dd	0
.tmp_d		dd	0
.tmp_e		dd	0
.tmp_f		dd	0
.table	db	0

.do_show:
	call out_trow
	call out_tcol
	mov edi,dword[skin_boffset]
	mov esi,dev_skin_default
	cmp dword[dev_skin_buffer],0
	jz .nx_show
	mov esi,dev_skin_buffer+5
.nx_show:
	mov eax,dword[.tmp_e]
	call out_dev
	mov dword[skin_boffset],edi
	call out_end_tcol
	call out_tcol
	mov dword[skin_boffset],edi
	mov esi,ip_skin_default
	cmp dword[ip_skin_buffer],0
	jz .nx_show1
	mov esi,ip_skin_buffer+5
.nx_show1:
	push edi
	 mov ebx,dword[.tmp_b]
	 mov edi,main_buffer
	 call ipn2s
	pop edi
	mov eax,main_buffer
	call out_ip
	mov dword[skin_boffset],edi
	call out_end_tcol
	call out_tcol
	mov dword[skin_boffset],edi
	mov esi,proto_skin_default
	cmp dword[proto_skin_buffer],0
	jz .nx_show2
	mov esi,proto_skin_buffer+5
.nx_show2:
	mov eax,dword[.tmp_f]
	call out_proto
	mov dword[skin_boffset],edi
	call out_end_tcol
	call out_tcol
	mov dword[skin_boffset],edi
	mov esi,io_skin_default
	cmp dword[io_skin_buffer],0
	jz .nx_show3
	mov esi,io_skin_buffer+5
.nx_show3:
	mov eax,dword[.tmp_c]
	call out_io
	mov dword[skin_boffset],edi
	call out_end_tcol
	call out_end_trow
	;;;
	ret
