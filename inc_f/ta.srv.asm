;;Protocol of the Traffic Accouting server;

		mov	dword[server_funcs + PTYPE_LOGIN*4], server_f_login
		mov	dword[server_funcs + PTYPE_ERROR*4], server_f_error
		mov	dword[server_funcs + PTYPE_LOGOUT*4], server_f_logout
		mov	dword[server_funcs + PTYPE_ENTRY*4], server_f_entry
		mov	dword[server_funcs + PTYPE_TIMEOUT*4], server_f_timeout
		mov	dword[server_funcs + PTYPE_ELOGN*4], server_f_elogn
		mov	dword[server_funcs + PTYPE_ERRTP*4], server_f_errtp
		mov	dword[server_funcs + PTYPE_CHKLOGIN*4], server_f_chklogin
						
main_recvfrom_server:		
		mov	edx,server_on_timer
		;call	add_to_timer_f
		;;CREATING SOCKET;
		mov	eax,SYS_SOCK
		mov	ebx,SYS_SOCKET
		mov	ecx,args_sock_srv_1
		int	0x80
		or 	eax,eax
		js	near @error
		push	eax
		mov	dword [args_opt.sock], eax
		;;SET OPTIONS TO SOCKET;
		mov	eax,SYS_SOCK
		mov	ebx,SYS_SETSOCKOPT
		mov	ecx,args_opt
		int	0x80
		pop	eax
		mov	dword [server_socket],  eax
		mov	dword [args_sock_srv_2.sock], eax
		mov	word [sockaddr_in.sin_family], AF_INET
		mov	ax,word[server_port]
		xchg	al,ah
		mov	word [sockaddr_in.sin_port], ax
		mov	dword [sockaddr_in.sin_addr], INADDR_ANY
		;;SOCKET BIND;
		mov	eax,SYS_SOCK
		mov	ebx,SYS_BIND
		mov	ecx,args_sock_srv_2
		int	0x80
		or 	eax,eax
		js	near @error
		mov	eax, dword [server_socket]
		mov	dword [args_sock_srv_3.sock], eax
		mov	dword [args_sock_srv_3.maxcon], 10
.server_listen:		
		mov	eax,SYS_SOCK
		mov	ebx,SYS_LISTEN
		mov	ecx,args_sock_srv_3
		int	0x80
		or 	eax,eax
		js	near @error
		mov	eax, dword [server_socket]
		mov	dword [args_sock_srv_4.sock], eax		
.server_accept:	
		mov	byte[server_login],0
		mov	eax,6
		mov	ebx,dword[server_sockcon]
		int	0x80
		mov	eax,SYS_SOCK
		mov	ebx,SYS_ACCEPT
		mov	ecx,args_sock_srv_4
		int	0x80
		or	eax,eax
		js	near @error
		mov	dword[server_sockcon],eax
    .read_sock:
		mov	eax,3
		mov	ebx,dword[server_sockcon]
		mov	ecx,server_packet
		mov	edx,MAXSRVPACKLEN
		int	0x80		
		or	eax,eax
		js	.server_accept
		jz	.server_accept
		cmp	eax,MAXSRVPACKLEN
		ja	.read_sock
		mov	esi,server_packet
		cld
		lodsd
	.show_er:
	.ok_length:
		xor	eax,eax
		lodsb
		or	al,al
		jz	.read_sock
		cmp	al,SCNT_TYPES
		jna	.ok_type
		jmp	short .read_sock
	.ok_type:	
		mov	byte[srv_typeP],al
		or	al,al
		jnz	.nnx
	.nnx	
		call	[server_funcs + eax*4]
		jnc	.countinue
		jmp	.read_sock
.countinue:
		cmp	byte[srv_typeP],PTYPE_ENTRY
		jnz	.read_sock
		;;;
		mov	esi,server_packet
		lodsd
		inc	esi
		lodsd
		mov	dword[packet.len], eax
		mov	dword[packet.flen], eax
		mov	edi,packet.dev
		call	strcat_z
		lodsw
		mov	word[packet.sll_hatype],ax
		lodsb
		mov	byte[packet.sll_pkttype],al
		push	esi
		call	another_header
		pop	esi
		add	esi,eax
		sub	dword[packet.len],eax
		mov	dword[packet.ipdata], esi
		mov	esi,dword[packet.ipdata]
		mov	edi,packet.iphdr
		mov	ecx,iphdL
		rep	movsb
		mov	edi,process.dev
		call	strlen
		mov	esi,packet.dev
		mov	edi,process.dev
		repe	cmpsb
		jecxz	.eq
		jmp	.read_sock
	    .eq:
		cmp	byte[dfuncs_stable.ex],1
		jne	.next1
		mov	dword[some_f_call_deny],0
		mov	esi,dfuncs_stable
		call	run_f
		cmp	dword[some_f_call_deny],1
		je	.read_sock
	    .next1:
		cmp	byte[run_funcs.ex],1
		jne	.next2
		mov	esi,run_funcs
		call	run_f
	    .next2:	    
		;;main_proc;
		jmp	.read_sock
save_eax	dd	0		
srv_typeP	db	0
server_f_login:
	cmp	byte[server_login],1
	jz	.sc
	mov	eax,esi
	mov	ebx,pfile
	call	check_user_login
	jnc	.lOK
	mov	eax,6
	mov	ebx,[server_sockcon]
	int	0x80
	stc
	;;;
	ret
    .lOK:
	mov	byte [server_login],1
	clc
	;;;
	ret
    .sc:
	stc
	;;;
	ret
server_f_error:
	stc
	;;;
	ret
server_f_logout:
	stc
	;;;
	ret
server_f_entry:
	cmp	byte[server_login],1
	jnz	.sc
	clc
	;;;
	ret
.sc:
	stc
	;;;
	ret
server_f_timeout:
	stc
	;;;
	ret
server_f_elogn:
	stc
	;;;
	ret
server_f_errtp:
	stc
	;;;
	ret
server_f_chklogin:
	stc
	;;;
	ret
closefd:
		mov	eax,6
		int	0x80
		;;;
		ret
server_on_timer:
		dec	dword[.tv]
		cmp	dword[.tv],0
		jnz	.nx
		mov	dword[.tv],SRVTIMEOUT
		cmp	byte[server_login],0
		jnz	.nx
		mov	ebx,dword[server_sockcon]
		mov	eax,6
		int	0x80
    .nx:
		;;;
		ret
.tv	dd	SRVTIMEOUT