;;ip_entry_list;
	test	byte[.first],1
	jnz	.next
	setz	byte[.first]
	mov	edx,ip_entry_list_timer
	call	add_to_timer_f
.next:
	mov	esi,ip_entry_list_buffer+5
	lodsd
	cmp eax,dword[add_ip_to_list.count]
	jnz .ex_full
	setbe byte[ip_list_table_full]
    .ex_full:
	mov eax,dword[packet.sa]
	cmp eax,dword[packet.da]
	jz .one
	call add_ip_to_list
    .one:
	mov eax,dword[packet.da]
	call add_ip_to_list
    .ex:
	;;;
	ret
.first	db	0
ip_list_table_full	db	0
;;INPUT: eax=ip;
add_ip_to_list:
	mov	dword[.addr],eax
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_IP_ENTRY_LIST
	call	find_in_db
	jc	.lpe	
	push	ebx
	    lodsd
	    cmp eax,dword[.addr]
	    jnz	.nx
	    mov	eax,13
	    sub	ebx,ebx
	    int	0x80
	    mov dword[esi],eax
	    add esp,4
	    ;;;
	    ret
	.nx:
	pop	ebx	
	mov	esi,ebx
	jmp short .lpf
    .lpe:
	test	byte[ip_list_table_full],1
	jnz	.ex
	mov	edi,main_buffer
	mov	eax,dword[.addr]
	stosd
	mov	eax,13
	sub	ebx,ebx
	int	0x80
	stosd
	stosd
	mov	ecx,12
	mov	esi,main_buffer
	mov	dl,DB_ID_IP_ENTRY_LIST
	call	add_to_db
	inc	dword[.count]
    .ex:
	;;;
	ret
.addr	dd	0
.count	dd	0
;;INPUT: eax=unix_time;
put_date_str:
	push edi
	 mov	edi,tm
	 mov	esi,tzfilename
	 call	date_diff
	 mov	eax,91
	 mov	ebx,dword[mmap_addr]
	 mov	ecx,dword[mmap_buf.len]
	 int	0x80		
	 mov	eax,6
	 mov	ebx,dword[mmap_buf.fd]
	 int	0x80
	pop edi
	mov	ebx,dword[tm + tmfmt.hr]
	call	put_chdate	
	mov al,':'
	stosb
	mov	ebx,dword[tm + tmfmt.mn]
	call	put_chdate	
	mov al,':'
	stosb
	mov	ebx,dword[tm + tmfmt.sc]
	call	put_chdate	
	mov al,','
	stosb
	mov	ebx,dword[tm + tmfmt.yr]
	call	put_chdate
	mov	al,'-'
	stosb
	mov	ebx,dword[tm + tmfmt.mo]
	call	put_chdate
	mov	al,'-'
	stosb
	mov	ebx,dword[tm + tmfmt.dy]
	call	put_chdate	
	;;;
	ret
ip_entry_list_timer:
	mov	eax,93
	mov	ebx,dword[ip_entry_list_buffer+9]
	sub	ecx,ecx
	int	0x80
	test	byte[ip_list_table_full],1
	jz	.n_full
	mov	eax,4
	mov	ebx,dword[ip_entry_list_buffer+9]
	mov	ecx,.full_ms
	mov	edx,len_full_ms-1
	int	0x80
.n_full:
	mov	esi,start_table
    .lpf:
	mov	dl,DB_ID_IP_ENTRY_LIST
	call	find_in_db
	jc	.lpe	
	push	ebx
	    mov edi,main_buffer
	    lodsd	    
	    mov ebx,eax
	    bswap ebx
	    call ipn2s
	    dec edi	    
	    mov eax,'|las'
	    stosd
	    mov ax,'t '
	    stosw
	    lodsd	;last date
	    push esi
	     call put_date_str
	    pop esi
	    mov eax,'|fir'
	    stosd
	    mov ax,'st'
	    stosw
	    mov al,' '
	    stosb
	    lodsd	;first date
	    push esi
	     call put_date_str
	    pop esi
	    mov ax,0x000A
	    stosw
	    mov edi,main_buffer
	    call strlen
	    mov edx,ecx
	    mov eax,4
	    mov ebx,dword[ip_entry_list_buffer+9]
	    mov ecx,main_buffer
	    int 0x80
	pop	ebx	
	mov	esi,ebx
	jmp short .lpf
    .lpe:
	;;;
	ret
.full_ms	db	"Maximum limit of ip entries has excessed",0xA,0
len_full_ms	equ	$-.full_ms
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	