BITS 32
origin		equ 	0x08048000
		org	0x08048000
		db	0x7F, 'ELF'		; e_ident
		db	1, 1, 1
	times 9	db	0
		dw	2			; e_type
		dw	3			; e_machine
		dd	1			; e_version
		dd	START			; e_entry
		dd	phdr - $$		; e_phoff
		dd	0			; e_shoff
		dd	0			; e_flags
		dw	0x34			; e_ehsize
		dw	0x20			; e_phentsize
phdr:		dw	1			; e_phnum	; p_type
		dw	0			; e_shentsize
		dw	0			; e_shnum	; p_offset
		dw	0			; e_shstrndx
		dd	$$					; p_vaddr
		dd	$$					; p_paddr
		dd	_elf_filesz				; p_filesz
		dd	_elf_memsz				; p_memsz
		dd	_elf_phdr_flags
		dd	0x1000					; p_align
_text:

START:
;;;	sys_open		
%assign O_RDONLY	0
%assign O_WRONLY	1
%assign O_RDWR		2
%assign O_ACCMODE	3
%assign O_CREAT		100q
%assign O_EXCL		200q
%assign O_NOCTTY	400q
%assign O_TRUNC		1000q
%assign O_APPEND	2000q
%assign O_NONBLOCK	4000q  

;;;	Protections
%assign PROT_READ	0x1
%assign PROT_WRITE	0x2
%assign PROT_EXEC	0x4
%assign PROT_NONE	0x0

;;;	sys_mmap Flags
%assign MAP_SHARED	0x01
%assign MAP_PRIVATE	0x02
%assign MAP_TYPE	0x0f
%assign MAP_FIXED	0x10
%assign MAP_ANONYMOUS	0x20
%assign MAP_GROWSDOWN	0x0100
%assign MAP_DENYWRITE	0x0800
%assign MAP_EXECUTABLE	0x1000
%assign MAP_LOCKED	0x2000
%assign MAP_NORESERVE	0x4000

%define	MAX_PATH_LEN		0x1000
%define MAXPATHLEN		MAX_PATH_LEN
%define	BUFSIZE			0x2000

%assign SEEK_SET	0
%assign SEEK_CUR	1
%assign SEEK_END	2
%assign	BUFSIZE	0x2000
%define FBUFSIZE BUFSIZE 
%include	"inc/md5.h"
%include	"inc/rc6.h"
%include	"inc/term.h"
%include	"inc/others.h"

		pop	ecx
		pop	ebp
		dec	ecx
  		mov	esi,esp
		mov	edi,ps
		call	getarguments
		jnc	.nx
		mov	eax,4
		mov	ebx,1
		mov	edx,len_usage
		mov	ecx,usage
		int	0x80
		call	@exit		
    .nx:
		cmp	byte[ps.e5],1
		jnz	.next_args
		cmp	dword[ps.s5],0
		jnz	.pfile_nx
		mov	eax,usage
		call	write
		call	@exit
	.pfile_nx:
		mov	esi,dword[ps.s5]
		mov	edi,pfile
		call	strcat_z
		jmp	short .next_ps
    .next_args:
		mov	esi,pfileD
		mov	edi,pfile
		call	strcat_z
    .next_ps:
		cmp	byte[ps.e1],1
		jz	near useradd
		cmp	byte[ps.e2],1
		jz	userdel
		;cmp	byte[ps.e3],1
		;jz	urename
		cmp	byte[ps.e4],1
		jz	setpassword
		mov	eax,usage
		call	write
		call	@exit
setpassword:
		call	@exit
;urename:
;		cmp	dword[ps.s3],0
;		jnz	.nx
;	.usage:
;		mov	eax,usage
;		call	write
;		call	@exit		
;	.nx:
;		cmp	dword[ps.s3+4],0
;		jz	.usage
;		mov	ebx,pfile
;		call	file_exists
;		jns	.nx_ren
;		mov	eax,err_fp
;		call	write
;		call	@exit
;	.nx_ren:
;		mov	ebx,pfile
;		call	mmap_file
;		mov	[.buf],eax
;		mov	esi,eax
;		mov	edi,[ps.s3]
;		call	check_user_exists
;		jc	.n_user
;		mov	eax,err_ue
;		call	write
;		call	@exit
;	.n_user:
;		push	eax
;		 mov	eax,19
;		 mov	ebx,dword[mmap_buf.fd]
;		 xor	ecx,ecx
;		 mov	edx,SEEK_SET
;		 int	0x80    
;		pop	eax		
;		mov	eax,dword[.buf]
;		dec	dword[eax]
;		mov	eax,ebp
;		sub	eax,dword[.buf]
;		mov	dword[.len],eax
;		mov	esi,dword[ps.s3 + 4]
;		mov	edi,buffer_input
;		call	strcat_z
;		mov	esi,ebp
;		call	to_zero
;		lodsd
;		push	esi
;		mov	ecx,eax
;		mov	esi,buffer_input
;		call	to_zero
;		mov	edi,esi
;		pop	esi
;		mov	eax,ecx
;		stosd
;		rep	movsb
;		call	get_len_entry		
;		push	edx
;		    mov	eax,4
;		    mov ebx,dword[mmap_buf.fd]
;		    mov	ecx,[.buf]
;		    mov edx,[.len]
;		    int	0x80
;		pop	edx
;		push	edx		 
;		 push	ebp
;		 mov	ebp,buffer_input
;		 call	get_len_entry
;		 pop	ebp
;		 mov	dword[.len_o],edx
;		 mov	eax,4
;		 mov	ecx,buffer_input
;		 int	0x80
;		pop	edx
;		mov	eax,dword[.len]
;		add	eax,edx
;		mov	ebx,dword[mmap_buf.len]
;		sub	ebx,eax
;		add	dword[.len],ebx
;		add	ebp,edx
;		mov	edx,ebx
;		push	edx
;		mov	eax,4
;		mov	ebx,dword[mmap_buf.fd]
;		mov	ecx,ebp
;		int	0x80
;		pop	edx
;		add	edx,dword[.len]
;		add	edx,dword[.len_o]
;		mov	eax,93
;		mov	ecx,edx
;		int	0x80		
;		call	@exit
.;buf		dd	0
;.len		dd	0		
;.len_o		dd	0
get_len_entry:
		xor	edx,edx
		mov	edi,ebp
		call	strlen_z
		add	edx,ecx
		mov	esi,ebp
		add	esi,edx
		lodsd
		add	edx,4
		add	edx,eax
		;;;
		ret
userdel:
		cmp	dword[ps.s2],0
		jnz	.nx
		mov	eax,usage
		call	write
		call	@exit
	.nx:
		mov	ebx,pfile
		call	file_exists
		jns	.nx_del
		mov	eax,err_fp
		call	write
		call	@exit
	.nx_del:
		mov	ebx,pfile
		call	mmap_file
		mov	[.buf],eax
		mov	esi,eax
		mov	edi,[ps.s2]
		call	check_user_exists
		jc	.n_user
		mov	eax,err_ue
		call	write
		call	@exit
	.n_user:
		push	eax
		 mov	eax,19
		 mov	ebx,dword[mmap_buf.fd]
		 xor	ecx,ecx
		 mov	edx,SEEK_SET
		 int	0x80    
		pop	eax		
		mov	eax,dword[.buf]
		dec	dword[eax]
		mov	eax,ebp
		sub	eax,dword[.buf]
		mov	dword[.len],eax
		xor	edx,edx
		mov	edi,ebp			
		call	strlen_z
		add	edx,ecx
		mov	esi,ebp
		add	esi,edx		
		lodsd
		add	edx,4
		add	edx,eax		
		push	edx
		    mov	eax,4
		    mov ebx,dword[mmap_buf.fd]
		    mov	ecx,[.buf]
		    mov edx,[.len]
		    int	0x80
		pop	edx
		mov	eax,dword[.len]
		add	eax,edx
		mov	ebx,dword[mmap_buf.len]
		sub	ebx,eax
		add	dword[.len],ebx
		add	ebp,edx
		mov	edx,ebx
		mov	eax,4
		mov	ebx,dword[mmap_buf.fd]
		mov	ecx,ebp
		int	0x80
		mov	eax,93
		mov	ecx,[.len]
		int	0x80
		call	@exit
.buf		dd	0
.len		dd	0
err_ue:	db	"*Err: User doesn`t exists",0xA,0
err_fp		db	"password db file is doesn`t exists",0xA,0
useradd:
		cmp	dword[ps.s1],0
		jnz	.nx
		mov	eax,usage
		call	write
		call	@exit
    .nx:
		mov	ebx,pfile
		call	file_exists
		js	near .newfile
		mov	ebx,pfile
		call	mmap_file
		mov	[.buf],eax
		mov	esi,eax
		mov	edi,[ps.s1]
		call	check_user_exists
		jnc	.n_user
		mov	eax,.u_ex
		call	write
		call	@exit
    .n_user:
		inc	dword[esi]
		mov	esi,dword[ps.s1]
		mov	edi,buffer
		call	do_adduser
		mov	eax,6
		mov	ebx,[mmap_buf.fd]
		int	0x80		
		mov	eax,5
		mov	ebx,pfile
		mov	ecx,(O_WRONLY)
		int	0x80
		xchg	eax,ebx
		mov	eax,4
		mov	ecx,dword[.buf]
		mov	edx,[mmap_buf.len]
		int	0x80	
		mov	eax,4
		lea	ecx,[buffer + 4]
		mov	edx,dword[do_adduser.len]
		int	0x80
		call	@exit
    .newfile:
		mov	eax,8
		mov	ebx,pfile
		mov	ecx,100000000b
		int	0x80
		or	eax,eax
		js	near @error
		mov	dword[.fd],eax
		mov	dword[count_entries],1
		mov	esi,dword[ps.s1]
		mov	edi,buffer
		call	do_adduser
		mov	eax,4
		mov	ebx,dword[.fd]
		mov	ecx,buffer
		mov	edx,dword[do_adduser.len]
		add	edx,4
		int	0x80
		call	@exit
.u_ex	db	"User already exists in db",0xA,0
.fd	dd	0
.buf	dd	0
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
;;INPUT: edi=buffer, esi=username;
;;OUTPUT: ecx=len of buffer;
do_adduser:
		cld
		mov	dword[.len],0
		mov	dword[.buf],edi
		mov	eax,[count_entries]
		stosd
		push	esi
		 call	strcat_z
		pop	esi
		mov	eax,4
		mov	ebx,1
		mov	ecx,.login
		mov	edx,len_login
		int	0x80
		;;term	echo off;
		call	term_echo_on
		mov	eax,3
		mov	ebx,0
		mov	ecx,buffer_input
		mov	edx,256
		int	0x80
		dec	eax
		jnz	.nx
		call	term_echo_off
		call	crlf
		mov	eax,.err_len
		call	write
		call	@exit
    .nx:	
		call	term_echo_off
		call	crlf		
		push	edi
		    mov edi,buffer_input
		    call strlen
		    xor al,al
		    push ecx
		    repnz scasb
		    pop ecx
		    mov byte[edi-1],0
		    push esi
			mov edi,buffer_input
			call split_z
		    pop esi
		pop	edi
		push edi
		 call	MD5_Init
		 mov	edi,buffer_input
		 push	ecx
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
		 xor al,al
		 stosb
		 pop ecx
		pop edi
		push	edi
		    xor edx,edx
		    mov edi,buffer_input
		    call strlen_z
		    add	edx,ecx
		    call strlen_z
		    add edx,ecx
		    add edx,34
		    mov ecx,edx
		pop	edi
		push	edi
		mov	eax,ecx
		stosd
	    	mov	esi,buffer_input
		mov	ebx,buffer_input	;offset of the e/d key
		call	rc6_encrypt
		pop	edi
		mov	eax,dword[rc6_encrypt.len]
		mov	dword[edi],eax
		mov	edi,dword[.buf]
		add	edi,4
		call	strlen_z
		add	ecx,4
		add	[.len],ecx
		mov	eax,dword[edi]
		add	[.len],eax
		;;;
		ret

.login	db	"Changing password for user",0xA
	db	"New password: "
len_login	equ	$-.login
.err_len:	db	"Wrong!: Password is too small",0xA,0
.len	dd	0
.buf	dd	0
crlf:
	mov eax,4
	mov ebx,1
	mov ecx,crlf_d
	mov edx,1
	int 0x80
	;;;
	ret
crlf_d	db	0xA
split:
		push	edi
		    mov	edi,esi
		    call strlen
		pop	edi
		push	ecx
		    sub	ecx,ecx
		    dec	ecx
		    sub	al,al
		    repnz scasb
		    dec	edi
		pop	ecx
		inc	ecx
		rep	movsb
		;;;
		ret
split_z:
		push	edi
		    mov	edi,esi
		    call strlen
		pop	edi
		push	ecx
		    sub	ecx,ecx
		    dec	ecx
		    sub	al,al
		    repnz scasb
		pop	ecx
		inc	ecx
		rep	movsb
		;;;
		ret		
term_echo_off:
	    or	dword [sattr+termios.c_lflag],(ECHO)
	    mov eax,54
	    sub ebx,ebx
	    mov ecx,TCSETS
	    mov edx,sattr
	    int 0x80	    
	    ;;;
	    ret
term_echo_on:
	    mov eax,54
	    sub ebx,ebx
	    mov ecx,TCGETS
	    mov edx,sattr
	    int 0x80
	    and	dword [sattr+termios.c_lflag],~(ECHO)
	    mov eax,54
	    sub ebx,ebx
	    mov ecx,TCSETS
	    mov edx,sattr
	    int 0x80	    
	    ;;;
	    ret	    	    
;;INPUT: ebx=*file_name			;
;;OUT: sf=1 error, otherwise - ok	;
file_exists:
	mov	eax,5
	mov	ecx,O_RDONLY
	int	0x80
	push	eax
	    or	eax,eax
	    js	.nx
	    xchg eax,ebx
	    mov eax,6
	    int	0x80
    .nx:
	pop	eax
	or	eax,eax
	;;;
	ret		
;;INPUT: esi=*user_table_addr, edi=*user_name	;
;;OUPUT: if cf=0 then esi=*user, otherwise cf=1	;
find_userdb:		
		;;;
		ret
@exit:
@error:
		xor	eax,eax
		inc	eax
		xor	ebx,ebx
		int	0x80
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
;ecx=buffer
;edx=len
debug:
	push	ecx
	push	edx
	mov	eax,5
	mov	ebx,debug_file
	mov	ecx,(O_RDWR|O_CREAT|O_APPEND)
	mov	edx,100100100b
	int	0x80
	pop	edx
	pop	ecx
	xchg	eax,ebx
	mov	eax,4
	int	0x80
	;;;
	ret
debug_file	db	"outdebug",0
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
;;INPUT: ebx=file_name		;
;;OUT: eax=address_of_mem	;
mmap_file:
	mov	eax,5
	;mov	ebx,file	;get from parameter
	mov	ecx,O_RDWR
	int	0x80
	or	eax,eax
	jns	.nx
	jmp	@error
    .nx:
	xchg	eax,ebx
	mov	eax,19
	xor	ecx,ecx
	mov	edx,SEEK_END
	int	0x80
	or	eax,eax
	jns	.nx1
	jmp	@error
    .nx1:	
	mov	dword [mmap_buf.len], eax
	xchg	eax,ecx
	mov	[mmap_buf.fd], ebx
	mov	eax,90
	mov	ebx,mmap_buf
	int	0x80
	or	eax,eax
	jns	.nx2
	jmp	@error
    .nx2:
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
to_zero:
    .lp:
	lodsb
	or al,al
	jnz .lp
	;;;
	ret	
;;EDI=*string;
;;OUT: ECX=len;
strlen:
	    push	edi
	    sub	al,al
	    sub	ecx,ecx
	    dec	ecx
	    cld
	    repnz	scasb
	    not	ecx
	    dec	ecx
	    pop	edi
	    ret
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
strcmp:		
		call	strlen
		push	edi
		mov	edi,esi
		push	ecx
		call	strlen
		mov	edx,ecx
		pop	ecx
		pop	edi
		cmp	edx,ecx
		jne	.ex
		inc	ecx
		repe	cmpsb
		or	ecx,ecx
	.ex:
		;;;
		ret
strcat:
		push	edi
		    mov	edi,esi
		    call strlen
		pop	edi
		rep	movsb
		;;;
		ret			    		
strcat_z:
		push	edi
		    mov	edi,esi
		    call strlen
		pop	edi
		inc	ecx
		rep	movsb
		;;;
		ret				
;;EAX=*string,0;
write:
	    mov	edi,eax
	    mov	ecx,edi
	    push ecx
	    call strlen
	    mov	edx,ecx
	    pop	ecx
	    mov	eax,4
	    sub	ebx,ebx
	    inc	ebx
	    int	0x80
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
%include	"inc_f/md5.f.asm"
%include	"inc_f/rc6.f.asm"
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

rc6_decrypt:
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
		jz	.decrypt2
		mov	edx,ecx
		;esi, edi already have prepared
    .decrypt:
		invoke	RC6_Decrypt,esi,edi
		add	esi,byte 16
		add	edi,byte 16		
		dec	ecx
		jnz	.decrypt	
		shl	edx,4
		;;;
		ret
.decrypt2:
		mov	edx,16
		invoke	RC6_Decrypt,esi,edi
		;;;
		ret
.len		dd	0
RC6_key_init:
		mov	edi,RC6_keys
		sub	eax,eax
		mov	ecx,len_key_data/4
		rep	stosd
		;;;
		ret
usage:		db	"usage: tuseradd <-[a,d,p]> <name> [name]",0xA
		db	"-a: add new user",0xA
		db	"-d: delete existing user",0xA
;		db	"-r: rename existing user",0xA
		db	"-p: change password for user",0xA
		db	"--pfile: path to passwd file db",0xA
len_usage	equ	$-usage
		db	0
pfileD		db	"/etc/passwd.db",0
path_err	db	"password file path name is too long",0xA,0
count_entries	dd	0;
ps:
    .ps1:	db	"-a",0
		db	1		;count of parametres for ps1
		.e1: db	0		;1 if parameter exists
		.s1: dd	0		;offsets to params
    .ps2:	db	"-d",0
		db	1
		.e2: db	0
		.s2: dd	0
;    .ps3:	db	"-r",0
;		db	2
;		.e3: db	0
;		.s3: dd	0, 0
    .ps4:	db	"-p",0
		db	1
		.e4: db	0
		.s4: dd	0		
    .ps5:	db	"--pfile",0
		db	1
		.e5: db	0
		.s5: dd	0		
    .eop:	db	0		;zero must have be present to
					;specify end of arguments list.
mmap_buf:
		 dd	0
	    .len:dd	0
		 dd	PROT_READ|PROT_WRITE
		 dd	MAP_SHARED
	    .fd:
		dd	0
		dd	0					
    align	16
_elf_filesz	equ	$ - $$
[absolute 0x08048000 + _elf_filesz]
_data:
pfile	resb	MAXPATHLEN
buffer	resb	BUFSIZE
buffer_ps	resb	BUFSIZE
buffer_input	resb	BUFSIZE
;;MD5;
A_MD5	resd	1
B_MD5	resd	1
C_MD5	resd	1
D_MD5	resd	1
LoPart_MD5	resd	1
HiPart_MD5	resd	1
buff1_MD5	resd	16

;

digest_MD5	resd	4		;resulting 128 bit MD5 code
text2_MD5	resd	9		;ascii version of MD5 code

;;RC6;
;RMD-160 core registers & buffer
;don't change the order 'cause RMD engine is based on this order

A	resd	1
B	resd	1
C	resd	1
D	resd	1
E	resd	1
LoPart	resd	1
HiPart	resd	1
buff1	resd	16		;calculation buffer

Rounds	resb	(10*16*10)	;to store the expanded Round1 to Round8 tables

;
;internal RC6 key
;
RC6_keys:
l_key	resd	45			
ll	resd	9
len_key_data	equ	$-RC6_keys
;---------------------------------------------------------------------

ibuffer	resb	FBUFSIZE	;input file buffer

buffer_RC6	resd	BUFSIZE
action	resb	1		;encrypt/decrypt
flength	resd	1

    key1	resd	5
    key2	resd	5
    key	resd	8


obuffer	resb	FBUFSIZE	;output file buffer
sattr	resb	termios_size
_elf_phdr_flags	equ	7		
_elf_memsz	equ	$ - origin
