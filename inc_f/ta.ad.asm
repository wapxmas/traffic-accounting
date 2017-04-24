;;Addons to main program TA;
set_fd:
    mov	ecx,ebx
    and ecx,31	
    shr ebx,5
    bts dword [edi + ebx], ecx
    ;;;
    ret    
rc6_encrypt:
		mov	dword[.len],0
		push esi
		 push edi
		   push ecx
		    invoke	parsekey,ebx
		    invoke	RC6_Setkey,key,256
		   pop ecx
		 pop edi
		pop esi
		mov	ebx,ecx
		shr	ebx,4
		shl	ebx,4
		sub	ebx,ecx
		jz	.nx				
		neg	ebx
		mov	edx,16
		sub	edx,ebx
		add	ecx,edx
				
    .nx:
		shr	ecx,4
		jz	.crypt2
		mov	edx,ecx
		;esi, edi already have prepared
    .crypt:
		invoke	RC6_Encrypt,esi,edi
		add	esi,byte 16
		add	edi,byte 16		
		dec	ecx
		jnz	.crypt	
		shl	edx,4
		mov	dword[.len],edx
		;;;
		ret
.crypt2:
		mov	edx,16
		mov	dword[.len],edx
		invoke	RC6_Encrypt,esi,edi
		;;;
		ret
.len		dd	0

;;EDI=*string;
;;OUT: ECX=len;
strlen_z:
	    sub	al,al
	    sub	ecx,ecx
	    dec	ecx
	    cld
	    repnz	scasb
	    not	ecx
	    ret		    

strcat_z:
		push	edi
		    mov	edi,esi
		    call strlen
		pop	edi
		mov	eax,edx
		inc	ecx
		mov	edx,ecx
		shr	ecx,2
		rep	movsd
		mov	ecx,edx
		and	ecx,11b
		rep	movsb
		mov	edx,eax
		;;;
		ret				

;;INPUT: esi=*data;
;;OUPUT: edi=*data_md5_text(34 bytes);

out_MD5:
		mov	ecx,16
	.write:
		lodsb
		mov	edx,2	;printhex is here !
		mov	ah,al
	.ph1:	rol	ah,4
		mov	al,ah
		and	al,0x0f
		add	al,'0'
		cmp	al,'9'
		jle	.ph2
		add	al,0x27
	.ph2:	stosb
		dec	edx
		jnz	.ph1
		loop	.write
	;;;
	ret	    

check_user_exists:
		push	esi
		lodsd
		mov	ecx,eax
	.lp:
		mov	ebp,esi
		push	edi
		 push ecx
		    call strcmp
		    mov ebx,ecx
		 pop ecx
		pop	edi
		or	ebx,ebx
		jz	.found
		call	to_zero
		lodsd
		add	esi,eax		
		loop	.lp						
		pop	esi
		clc
		;;;
		ret
.found:
		pop	esi
		stc
		;;;
		ret
		
;;INPUT: eai=*struct_login, ebx=*pfile;
check_user_login:
		mov	dword[.userl],eax
		mov	dword[.pfile],ebx		
		mov	ebx,dword[.pfile]
		call	file_exists
		jns	.fOK
		mov	eax,err_fl
		call	write
		call	@exit
	.fOK:
		mov	ebx,dword[.pfile]
		call	mmap_file
		mov	[.buf],eax
		mov	esi,eax
		mov	edi,dword[.userl]
		call	check_user_exists
		jc	.n_user
		mov	eax,91
		mov	ebx,dword[.buf]
		mov	ecx,[mmap_buf.len]
		int	0x80
		mov	eax,6
		mov	ebx,dword[mmap_buf.fd]
		int	0x80
		stc
		;;;
		ret
    .n_user:
		mov	esi,ebp
		call	to_zero
		lodsd
		sub	esi,4
		add	eax,4
		mov	ecx,eax
		mov	edi,buffer_login
		rep	movsb
		mov	esi,dword[.userl]
		call	to_zero
		mov	edi,buffer_input
		call	strcat_z
		mov	esi,dword[.userl]
		call	strcat_z
		call	MD5_Init
		mov	edi,buffer_input
		call	strlen_z
		mov	ebx,ecx
		call	strlen_z
		add	ebx,ecx
		mov	ecx,ebx
		mov	esi,buffer_input
		call	MD5_Update	;calculate MD5 for data block
		mov	edi,digest_MD5
		call	MD5_Final	;finalize MD5 digest
		mov	esi,buffer_input
		call to_zero	;skip pass
		call to_zero	;skip user
		mov edi,esi
		mov esi,digest_MD5
		call out_MD5
		xor edx,edx
		mov edi,buffer_input
		call strlen_z
		add edx,ecx
		call strlen_z
		add edx,ecx
		add edx,34
		mov ecx,edx
		mov edi,buffer_ps
		mov	eax,ecx
		stosd
	    	mov	esi,buffer_input
		mov	ebx,buffer_input	;offset of the e/d key
		call	rc6_encrypt
		call	RC6_key_init
		mov	eax,dword[rc6_encrypt.len]
		mov	dword[buffer_ps],eax
		mov	esi,buffer_ps
		mov	edi,buffer_login
		call	strncmpass
		jnc	.pOK
		mov	eax,91
		mov	ebx,dword[.buf]
		mov	ecx,[mmap_buf.len]
		int	0x80
		mov	eax,6
		mov	ebx,dword[mmap_buf.fd]
		int	0x80
		stc
		;;;
		ret
	.pOK:
		mov	eax,91
		mov	ebx,dword[.buf]
		mov	ecx,[mmap_buf.len]
		int	0x80
		mov	eax,6
		mov	ebx,dword[mmap_buf.fd]
		int	0x80	
		clc
		;;;
		ret		
.pfile		dd	0
.userl		dd	0
.buf		dd	0
strncmpass:
		mov	eax,[edi]
		cmp	eax,dword[esi]
		jnz	.er
		lodsd
		mov ecx,eax
		stosd
		inc	ecx
		repe	cmpsb
		or	ecx,ecx
		jnz	.er
		clc
		;;;
		ret						
    .er:
		stc
		;;;
		ret


;;INPUT: ecx = count of args, 	;
;;esi = offet to argv struct	;
;;edi = struct wich you have to ;
;;be filled by args		;
getarguments:
		mov	word [.ok_f],0
		push	esi
		 call	argc
		pop	esi
		cmp	ecx,ebx
		setb	byte[.ps]
		cmp	ecx,1
		jbe	.er
		mov	ebp,ecx
    .lp:
		lodsd
		push	esi
		 push edi
		  call	find_argv
		 pop edi
		pop	esi
		or	ecx,ecx
		jns	.ok
		dec	ebp
		jnz	.lp
		jmp	short .ok_n
    .ok:
		dec	ebp
		jz	.ok_n    
		mov	byte [.ok_f],1
		push	edi
		 call	fill_argv
		pop	edi
		or	ebp,ebp
		jz	.ok_n
		jmp	short .lp
    .ok_n:
		clc
		;;;
		ret
    .er:	
		cmp	byte[.ok_f],0
		jne	.ok_n
		stc
		;;;
		ret
.ok_f		db	0
.ps		db	0
fill_argv:
		mov	edi,ebx
		mov	al,1
		stosb
	.lp:
		lodsd
		stosd
		dec ebp
		jz .ex
		dec ecx
		jnz .lp	
	.ex:
		;;;
		ret
find_argv:
		mov esi,edi
		mov edi,eax
    .lp:
		push edi
		 call strcmp
		pop edi
		or ecx,ecx
		jz .founded
		call to_zero
		xor	eax,eax
		lodsb
		lea	esi,[esi + eax*4 + 1]
		lodsb
		dec esi
		or al,al
		jnz .lp
		xor ecx,ecx
		dec ecx
		;;;
		ret
 .founded:
		lodsb
		movzx ecx,al
		mov ebx,esi		
		;;;
		ret
argc:
	mov	esi,edi
	xor	ebx,ebx
	xor	edx,edx
 .lp:
	lodsb
	or	al,al
	jz	.ex
	call	to_zero
	inc	ebx
	inc	edx
	xor	eax,eax
	lodsb
	add	ebx,eax
	lea	esi,[esi + eax*4 + 1]
	jmp	short .lp
 .ex:
	;;;
	ret
RC6_key_init:
		mov	edi,RC6_keys
		sub	eax,eax
		mov	ecx,len_key_data/4
		rep	stosd
		;;;
		ret	
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>		    	