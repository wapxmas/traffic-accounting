;;ls_by_iface;
	sub	ecx,ecx
    .lp:
	mov	esi,ls_by_iface_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LS_BY_IFACE
	mov	dword[current.nfunc],ecx
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_ls_by_iface
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_ls_by_iface:
	test	byte[.first],1
	jnz	.nx
	setz	byte[.first]
	mov	edx,on_timer_ls_by_iface
	call	add_to_timer_f	
    .nx:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_LS_BY_IFACE
	jz	.nex_1
	sub	al,(MAXPC_LS_BY_IFACE-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .nex_1:
	test	byte[dfuncs_ntable.ex],1
	jz	.next
	call	to_zero
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
	call to_zero
	call to_zero
	movzx ebx,byte[packet.ptype]
	push	esi
	call typeexists
	pop	esi
	or	bh,bh
	jz	.ex
	call	do_ls_by_iface_table	
    .ex:
	;;;
	ret
.first		db	0
do_ls_by_iface_table:
	mov	byte[.table],DB_ID_LS_BY_IFACE
	call .process_db	
	mov	byte[.table],DB_ID_LS_BY_IFACE_JOINT
	call .process_db
	;;;
	ret
.process_db:
	mov	esi,start_table
    .lpf:
	mov	dl,byte[.table]
	call	find_in_db
	jc	.lpe	
	push	ebx
	    lodsd
	    sub eax,dword[current.nfunc]
	    jnz .do_rep
	    mov	edi,packet.dev
	    call strcmp
	    jecxz .innc
    .do_rep:
	pop	ebx	
	mov	esi,ebx
	jmp short .lpf
    .innc:	
	add	esp,4
	call	increment_packet	
	;;;
	ret
    .lpe:	
	mov	edi,packet.dev
	call	strlen
	inc	ecx
	push	ecx
	mov	edi,main_buffer
	mov	eax,dword[current.nfunc]
	stosd
	mov	esi,packet.dev	
	rep	movsb
	mov	esi,pktypes_inc
	mov	ecx,pktypes_inc_l
	push 	edi
	rep	movsb
	pop	esi
	call	increment_packet
	pop	ecx
	add	ecx,pktypes_inc_l+4
	mov	esi,main_buffer
	mov	dl,byte[.table]
	call	add_to_db
	;;;
	ret
.tmp	dd	0
.table	db	0	
.first	db	0
;DB_ID_LS_BY_IFACE	
;DB_ID_LS_BY_IFACE_JOINT
cenumlp:
	mov edx,esi
	push edx
	call NSkipEnum
	pop edx
	mov eax,esi
	sub esi,edx
	mov dword[.len],esi
	mov esi,eax
	;;;
	ret
.len	dd	0
on_timer_ls_by_iface:
	sub	ecx,ecx
    .lp:
	mov	esi,ls_by_iface_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_LS_BY_IFACE
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_ls_by_iface_timer
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
name_esi_tmp_timer	dd	0
do_ls_by_iface_timer:
	mov	dword[.nfunc],ecx
	lodsb
	mov	dword[name_esi_tmp_timer],esi
	sub	al,MAXPC_LS_BY_IFACE
	je	.next
	js	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .next:
	call	to_zero
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
	add	ecx,TIME_ID_4
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
	js	near .skin_err1
	
	;;flush skins	;
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
	mov	esi,dword[name_esi_tmp_timer]
	mov	edi,main_buffer2
	call	to_zero
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
	  mov	byte[show_ls_by_iface.table],DB_ID_LS_BY_IFACE	
	  call	show_ls_by_iface
	 call	out_table_end
	 ;;joint;
	 call	out_jt_traf
	  call	out_table
	  mov	byte[show_ls_by_iface.table],DB_ID_LS_BY_IFACE_JOINT
	  call	show_ls_by_iface
	 call	out_table_end
	call	out_end
	test	byte[show_ls_by_iface.empty],1
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
	mov	byte[flush_table_ls_ifname.table],DB_ID_LS_BY_IFACE
	call	flush_table_ls_ifname
    .ex:
	;;;
	ret
.ext	dd	0
.t_only	db	0
.ferr:
	mov	eax,.err2
	call	write
	;;;
	ret
.skin_err1:
	mov	eax,.err1
	call	write	
	;;;
	ret
.err1:	db	"ERROR: Skin file doesn`t exists",0xA,0
.err2:	db	"ERROR: ls_by_iface: cannot create file",0xA,0
.nfunc	dd	0
.text_only:
	mov	esi,dword[name_esi_tmp_timer]
	mov	edi,main_buffer
	call	to_zero
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
	mov	byte[show_ls_by_iface_text.table],DB_ID_LS_BY_IFACE
	call	show_ls_by_iface_text
	mov	edi,S_BUFFER
	mov	esi,t_jt
	call	split	
	mov	byte[show_ls_by_iface_text.table],DB_ID_LS_BY_IFACE_JOINT
	call	show_ls_by_iface_text
	test	byte[show_ls_by_iface_text.empty],1
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
	mov	byte[flush_table_ls_ifname.table],DB_ID_LS_BY_IFACE
	call	flush_table_ls_ifname
	;;;
	ret
show_ls_by_iface_text:
	mov	byte[.empty],1
	mov	esi,start_table
    .lpf:
	mov	dl,byte[.table]
	call	find_in_db
	jc	.lpe	
	push	ebx
	    lodsd	    
	    sub eax,dword[do_ls_by_iface_timer.nfunc]
	    jnz .do_rep	    
	    setnz byte[.empty]
	    dec edi
	    call generate_log	    
	    mov	ax,0x000A
	    stosw	    
    .do_rep:
	pop	ebx	
	mov	esi,ebx
	jmp short .lpf
    .lpe:	
	;;;
	ret
.empty	db	0
.table	db	0

skin_boffset	dd	0
flush_table_ls_ifname:
	mov	esi,start_table
    .lpf:
	mov	dl,byte[.table]
	call	find_in_db
	jc	.lpe
	push	ebx
	    lodsd	    
	    sub eax,dword[do_ls_by_iface_timer.nfunc]
	    jnz .do_rep
	    call to_zero
	    call flush_packets
    .do_rep:
	pop	ebx	
	mov	esi,ebx
	jmp short .lpf
    .lpe:	
	;;;
	ret
.table	db	0
.tmp	dd	0
flush_packets:
	mov	ecx,5
	mov	edi,esi
    .lp:
	inc	edi
	xor	eax,eax
	stosd
	stosd	
	dec	ecx
	jnz	.lp	
	;;;
	ret
made_ext:
    .lp:
	lodsb
	cmp al,'%'
	jz .found
	or al,al
	jz .nx
	stosb
	jmp short .lp
.nx:	
	sub	al,al
	stosb
	;;;
	ret
.found:
	lodsb
	cmp al,'%'
	jz near .out_ch
	or al,al
	jz .nx
	mov ah,al
	lodsb
	or al,al
	jz .nx
	mov bx,ax
	cmp ax,'SS'
	jz .pf_SS
	cmp ax,'MM'
	jz .pf_MM
	cmp ax,'HH'
	jz .pf_HH
	cmp ax,'DD'
	jz .pf_DD
	cmp ax,'OM'
	jz .pf_MO
	cmp ax,'RY'
	jz .pf_YR
	cmp ax,'WW'
	jz .pf_WW
	cmp ax,'TU'
	jz .pf_UT
	mov al,'%'
	stosb
	mov ax,bx
	xchg ah,al
	stosw
	jmp short .lp	
.pf_UT:
	mov	ebx,dword[tm + tmfmt.ct]
	call	put_chdate
	jmp short .lp
.pf_SS:
	mov	ebx,dword[tm + tmfmt.sc]
	call	put_chdate
	jmp short .lp
.pf_MM:
	mov	ebx,dword[tm + tmfmt.mn]
	call	put_chdate
	jmp .lp
.pf_HH:
	mov	ebx,dword[tm + tmfmt.hr]
	call	put_chdate
	jmp .lp
.pf_DD:
	mov	ebx,dword[tm + tmfmt.dy]
	call	put_chdate
	jmp .lp
.pf_MO:
	mov	ebx,dword[tm + tmfmt.mo]
	call	put_chdate
	jmp .lp
.pf_YR:
	mov	ebx,dword[tm + tmfmt.yr]
	call	put_chdate
	jmp .lp
.pf_WW:
	mov	ebx,dword[tm + tmfmt.w1]
	call	put_chdate
	jmp .lp
.out_ch:
	or al,al
	jz .nx
	stosb
	jmp .lp
	;;;
	ret
out_jt_traf:
	cmp	dword[jt_traf_skin_buffer],0
	jz	.ex
	mov	esi,jt_traf_skin_buffer+5
	call out_head.do_out    
    .ex:
	;;;
	ret
out_cr_traf:
	cmp	dword[cr_traf_skin_buffer],0
	jz	.ex
	mov	esi,cr_traf_skin_buffer+5
	call out_head.do_out    
    .ex:
	;;;
	ret
out_table:
	mov	esi,table_skin_default
	cmp	dword[table_skin_buffer],0
	jz	.nx
	mov	esi,table_skin_buffer+5
    .nx:
	call out_head.do_out
	;;;
	ret
out_table_end:
	mov	esi,table_end_skin_default
	cmp	dword[table_end_skin_buffer],0
	jz	.nx
	mov	esi,table_end_skin_buffer+5
    .nx:
	call out_head.do_out
	;;;
	ret
out_trow:
	mov	esi,trow_skin_default
	cmp	dword[trow_skin_buffer],0
	jz	.nx
	mov	esi,trow_skin_buffer+5
    .nx:
	call out_head.do_out
	;;;
	ret
out_tcol:
	mov	esi,tcol_skin_default
	cmp	dword[tcol_skin_buffer],0
	jz	.nx
	mov	esi,tcol_skin_buffer+5
    .nx:
	call out_head.do_out
	;;;
	ret
out_end_trow:
	mov	esi,end_trow_skin_default
	cmp	dword[end_trow_skin_buffer],0
	jz	.nx
	mov	esi,end_trow_skin_buffer+5
    .nx:
	call out_head.do_out
	;;;
	ret
out_end_tcol:
	mov	esi,end_tcol_skin_default
	cmp	dword[end_tcol_skin_buffer],0
	jz	.nx
	mov	esi,end_tcol_skin_buffer+5
    .nx:
	call out_head.do_out
	;;;
	ret	
out_head:
	mov	esi,head_skin_default
	cmp	dword[head_skin_buffer],0
	jz .do_out
	sub	ecx,ecx
    .lp:
	mov	esi,head_skin_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_HEAD_SKIN
	add	esi,ebx
	    push ecx
		push	eax
		    lodsb
	    	    call .do_out
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
.do_out:	
	mov edi,dword[skin_boffset]
	call strcat
	mov al,0xA
	stosb
	mov dword[skin_boffset],edi
	call cwrite_buffer_html
	;;;
	ret	
out_end:
	mov	esi,end_skin_default
	cmp	dword[end_skin_buffer],0
	jz 	out_head.do_out
	sub	ecx,ecx
    .lp:
	mov	esi,end_skin_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_END_SKIN
	add	esi,ebx
	    push ecx
		push	eax
		    inc esi
	    	    call out_head.do_out
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	sub	al,al
	stosb
	mov dword[skin_boffset],edi
	;;;
	ret
show_ls_by_iface:
	mov	byte[.empty],1
	mov	esi,start_table
    .lpf:
	mov	dl,byte[.table]
	call	find_in_db
	jc	.lpe	
	push	ebx
	    lodsd
	    sub eax,dword[do_ls_by_iface_timer.nfunc]
	    jnz .do_rep
	    setnz byte[.empty]
	    mov	dword[.dev],esi
	    call to_zero
	    mov	dword[.io],esi
	    call .do_show
	    call cwrite_buffer_html
    .do_rep:
	pop	ebx	
	mov	esi,ebx
	jmp short .lpf
    .lpe:	
	;;;
	ret
.empty	db	0
.do_show:
	call out_trow
	call out_tcol
	mov edi,dword[skin_boffset]
	mov esi,dev_skin_default
	cmp dword[dev_skin_buffer],0
	jz .nx_show
	mov esi,dev_skin_buffer+5
.nx_show:
	mov eax,dword[.dev]
	call out_dev
	mov dword[skin_boffset],edi
	call out_end_tcol
	call out_tcol
	mov dword[skin_boffset],edi
	mov esi,io_skin_default
	cmp dword[io_skin_buffer],0
	jz .nx_show1
	mov esi,io_skin_buffer+5
.nx_show1:
	mov eax,dword[.io]
	call out_io
	mov dword[skin_boffset],edi
	call out_end_tcol
	call out_end_trow
	;;;
	ret
.table	db	0
.dev	dd	0
.io	dd	0
.tmp	dd	0
;;INPUT: esi=*string_skin, eax=*io_string;
out_io:
	mov	dword[.io],eax
    .lp:
	lodsb
	cmp al,'%'
	jz .found
	or al,al
	jz .nx
	stosb
	jmp short .lp
.nx:	
	mov al,0xA
	stosb	
	;;;
	ret
.found:
	lodsb
	cmp al,'%'
	jz near .out_ch
	or al,al
	jz .nx
	cmp al,'I'
	jz .show_i
	cmp al,'B'
	jz .show_b
	cmp al,'M'
	jz .show_m
	cmp al,'F'
	jz .show_f
	cmp al,'O'
	jz .show_o
	mov ah,'%'
	xchg ah,al
	stosw
	jmp short .lp
.show_o:
	push esi
	 mov eax,4
	 mov esi,dword[.io]	 
	 call .show_xx
	pop esi
	jmp short .lp
.show_f:
	push esi
	 mov eax,3
	 mov esi,dword[.io]
	 call .show_xx
	pop esi	
	jmp short .lp
.show_m:
	push esi
	 mov eax,2
	 mov esi,dword[.io]
	 call .show_xx
	pop esi
	jmp .lp
.show_b:
	push esi
	 mov eax,1
	 mov esi,dword[.io]
	 call .show_xx
	pop esi		
	jmp .lp
.show_i:
	push esi
	 mov eax,0
	 mov esi,dword[.io]
	 call .show_xx
	pop esi	
	jmp .lp
.out_ch:
	or al,al
	jz .nx
	stosb
	jmp .lp
;;INPUT: eax=number, esi=*io;
.show_xx:
	imul eax,eax,9
	add esi,eax
	lodsb
	lodsd
	mov edx,eax
	lodsd
	call d64_2s
	dec edi
	;;;
	ret
.io	dd	0
;;INPUT: esi=*string_skin, eax=*dev_string;
out_dev:
	mov dword[.dev],eax
    .lp:
	lodsb
	cmp al,'%'
	jz .found
	or al,al
	jz .nx
	stosb
	jmp short .lp
.nx:	
	mov al,0xA
	stosb	
	;;;
	ret
.found:
	lodsb
	cmp al,'%'
	jz .out_ch
	or al,al
	jz .nx
	mov ah,al
	lodsb
	or al,al
	jz .nx
	mov bx,ax
	sub ax,'VD'
	jz .ok_dev
	mov al,'%'
	stosb
	mov ax,bx
	xchg ah,al
	stosw
	jmp short .lp	
.ok_dev:
	push esi
	mov esi,dword[.dev]
	call strcat
	pop esi	
	jmp short .lp
.out_ch:
	or al,al
	jz .nx
	stosb
	jmp short .lp
.dev	dd	0
;;INPUT: esi=*string_skin, eax=*ip_string;
out_ip:
	mov dword[.ip],eax
    .lp:
	lodsb
	cmp al,'%'
	jz .found
	or al,al
	jz .nx
	stosb
	jmp short .lp
.nx:	
	mov al,0xA
	stosb	
	;;;
	ret
.found:
	lodsb
	cmp al,'%'
	jz .out_ch
	or al,al
	jz .nx
	mov ah,al
	lodsb
	or al,al
	jz .nx
	mov bx,ax
	sub ax,'PI'
	jz .ok_ip
	mov al,'%'
	stosb
	mov ax,bx
	xchg ah,al
	stosw
	jmp short .lp	
.ok_ip:
	push esi
	mov esi,dword[.ip]
	call strcat
	pop esi	
	jmp short .lp
.out_ch:
	or al,al
	jz .nx
	stosb
	jmp short .lp
	;;;
	ret
.ip	dd	0

out_port:
	mov dword[.port],eax
    .lp:
	lodsb
	cmp al,'%'
	jz .found
	or al,al
	jz .nx
	stosb
	jmp short .lp
.nx:	
	mov al,0xA
	stosb	
	;;;
	ret
.found:
	lodsb
	cmp al,'%'
	jz .out_ch
	or al,al
	jz .nx
	mov ah,al
	lodsb
	or al,al
	jz .nx
	mov bx,ax
	sub ax,'OP'
	jz .ok_ip
	mov al,'%'
	stosb
	mov ax,bx
	xchg ah,al
	stosw
	jmp short .lp	
.ok_ip:
	push esi
	mov esi,dword[.port]
	call strcat
	pop esi	
	jmp short .lp
.out_ch:
	or al,al
	jz .nx
	stosb
	jmp short .lp
	;;;
	ret
.port	dd	0

out_proto:
	mov dword[.proto],eax
    .lp:
	lodsb
	cmp al,'%'
	jz .found
	or al,al
	jz .nx
	stosb
	jmp short .lp
.nx:	
	mov al,0xA
	stosb	
	;;;
	ret
.found:
	lodsb
	cmp al,'%'
	jz .out_ch
	or al,al
	jz .nx
	mov ah,al
	lodsb
	or al,al
	jz .nx
	mov bx,ax
	sub ax,'RP'
	jz .ok_ip
	mov al,'%'
	stosb
	mov ax,bx
	xchg ah,al
	stosw
	jmp short .lp	
.ok_ip:
	push esi
	mov esi,dword[.proto]
	call strcat
	pop esi	
	jmp short .lp
.out_ch:
	or al,al
	jz .nx
	stosb
	jmp short .lp
	;;;
	ret
.proto	dd	0

ip_skin_default		db	"<font color=red size=+2><b>%IP</font></b>",0
dev_skin_default	db	"<font color=blue size=+2><b>%DV</font></b>",0
io_skin_default:	db	"<font color=blue size=+2><b>i:%I,o:%O,b:%B,m:%M,f:%F</font></b>",0
head_skin_default	db	'<html><head><title>Traffic Accounting</title></head><body bgcolor="#cccc99">',0
end_skin_default	db	"</body></html>",0
table_skin_default	db	'<table border="2" align="center">',0
table_end_skin_default	db	"</table>",0
trow_skin_default	db	"<tr>",0
tcol_skin_default	db	"<td>",0
end_trow_skin_default	db	"</tr>",0
end_tcol_skin_default	db	"</td>",0
cr_traf_skin_default:	db	"<b>Current Traffic:</b><br>",0
jt_traf_skin_default:	db	"<br><b>Joint Traffic:</b><br>",0
port_skin_default	db	"<font color=red size=+1><b>%PO</font></b>",0
proto_skin_default	db	"<font color=red size=+1><b>%PR</font></b>",0

;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>