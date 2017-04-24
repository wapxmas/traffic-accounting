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
%include "inc/client.h"
%include "inc/socket.h"
%include "inc/server.h"
%include "inc/protos.h"
%include "inc/defos.h"
%include "inc/term.h"
%include "inc/others.h"

%define BUFFERSIZE 0x1000
%define MAXNAME	256

		pop	ecx
		pop	ebp
		dec	ecx
		mov	esi,esp
		mov	edi,ps_argv
		call	getarguments
		jnc	.goto_nx
	.usage_p:
		mov	eax,usage
		call	write
		call	@exit		
	.goto_nx:
		cmp	byte[ps_argv.e1],0
		jz	.usage_p
		cmp	dword[ps_argv.s1],0
		jz	.usage_p
		mov	esi,dword[ps_argv.s1]
		mov	edi,esi
		xor	dl,dl
		call	chkIPsyntax
		jc	.usage_p
		mov	esi,edi
		call	sIPtoN
		mov	dword[server_ip],eax
		cmp	byte[ps_argv.e4],0
		jz	.usage_p
		cmp	dword[ps_argv.s4],0
		jz	.usage_p
		xor cl,cl
		mov	esi,dword[ps_argv.s4]
		call	strdec
		mov	word[server_port],bx
		cmp	byte[ps_argv.e2],0
		jz	.usage_p
		cmp	dword[ps_argv.s4],0
		jz	.usage_p
		cmp	byte[ps_argv.e3],0
		jnz	.pass_ok1
	.get_pass:
		;;get password procedure;
		call	term_echo_off
		    mov eax,pass_str
		    call write
		    mov eax,3
		    mov ebx,0
		    mov ecx,pass_buffer
		    mov edx,BUFFERSIZE
		    int 0x80
		    mov esi,pass_buffer
		    call to_zero
		    mov byte[esi-2],0
		    mov dword[ps_argv.s3],pass_buffer
		call	term_echo_on
		  call	crlf		
		jmp	short .pass_ok2
	.pass_ok1:
		cmp	dword[ps_argv.s3],0
		jz	.get_pass
	.pass_ok2:		
		mov	eax,SYS_SOCK
		mov	ebx,SYS_SOCKET
		mov	ecx,args_client_n1
		int	0x80
		or 	eax,eax
		js	near @error
		push	eax
		mov	dword [args_opt.sock], eax
		mov	eax,SYS_SOCK
		mov	ebx,SYS_SETSOCKOPT
		mov	ecx,args_opt
		int	0x80
		pop	eax		
		mov	dword [client_socket],  eax
		mov	dword [args_client_n2.sock], eax
		mov	word [sockaddr_in.sin_family], AF_INET
		mov	ax,word[server_port]
		xchg	al,ah
		mov	word [sockaddr_in.sin_port], ax
		mov	eax,dword[server_ip]
		bswap	eax
		mov	dword [sockaddr_in.sin_addr], eax;INADDR_ANY
		mov	eax,SYS_SOCK
		mov	ebx,SYS_CONNECT
		mov	ecx,args_client_n2
		int	0x80
		or	eax,eax
		js	near @error
		call	gen_loginp
		call	traf_init2
		mov	eax,4
		mov	ebx,[client_socket]
		mov	ecx,pack_login
		mov	edx,dword[gen_loginp.len]
		int	0x80
		mov	eax,SYS_SOCK
		mov	ebx,SYS_RECVFROM
		mov	ecx,recv_params
		int	0x80
		or	eax,eax
		js	near @error
		call	get_packet_p
		mov	eax,6
		mov	ebx,[recv_params.sock]
		int	0x80		
		call	traf_init
		mov	eax,48
		mov	ebx,SIGPIPE
		mov	ecx,SIGPIPE_handler
		int	0x80
		cmp	byte[ps_argv.e5],1
		jnz	.lp
		mov	eax,2
		int	0x80
		or	eax,eax
		jz	.lp
		call	@exit
.lp:
		call	recv_packs
		call	check_pack
		jc	.lp
		call	send_to_server
		jmp	short .lp		
@exit:		
		xor	eax,eax
		inc	eax
		xor	ebx,ebx
		int	0x80
				
server_ip	dd	0
server_port	dw	0

usage:		db	0xA
		db	"Usage: tsclient -s IP -p PORT --user USER [--pass PASS] [-d]",0xA,0xA
		db	"   -s        <server>: ip of wich the talinux server is running",0xA
		db	"   -p          <port>: port on the talinux server",0xA
		db	"   -d                : daemonized mode",0xA
		db	"   --user <user_name>: user wich will be logged in",0xA
		db	"   --pass  <password>: password for user, if that has absent then password ",0xA
		db	"		       will to be reading from input",0xA,0xA
		db	0
ps_argv:
    .ps1:	db	"-s",0
		db	1		;count of parametres for ps1
		.e1: db	0		;1 if parameter exists
		.s1: dd	0		;offsets to params
    .ps2:	db	"--user",0
		db	1
		.e2: db	0
		.s2: dd	0
    .ps3:	db	"--pass",0
		db	1
		.e3: db	0
		.s3: dd	0			
    .ps4:	db	"-p",0
		db	1
		.e4: db	0
		.s4: dd	0				
    .ps5:	db	"-d",0
		db	1
		.e5: db	0
		.s5: dd	0			
    .eop:	db	0		;zero must have be present to
ifname	db	"lo",0
sockaddr1:
	.sll_family:	dw	0
	.sll_protocol:	dw	0
	.sll_ifindex:	dd	0
	.sll_hatype:	dw	0
      .ptype: 
	.sll_pkttype:	db	0
	.sll_halen:	db	0
	.sll_addr:	times  8 db	0
recv_params:
		.sock	dd	0
		.buf	dd	recv_buffer
		.len	dd	MAXIPPACKLEN
		.flags	dd	0
		.sockaddr	dd	sockaddr1
		.sock_len	dd	len_sock
len_sock:
		dd	16
param_sock1:
		.domain:	dd	AF_PACKET
		.type:		dd	SOCK_RAW
		.proto:		dd	0 ;IPPROTO_ICMP; ETH_P_ALL
param_sock2:
		.domain:	dd	AF_PACKET
		.type:		dd	SOCK_DGRAM
		.proto:		dd	0 ;IPPROTO_ICMP; ETH_P_ALL				
sockaddr_in:
		.sin_family:	dw	0
		.sin_port:	dw	0
		.sin_addr:	dd	0
.__pad:		
		times	__ASOCK_SIZE__	db	0		
args_opt:
	    .sock:	dd	0
	    .level:	dd	SOL_SOCKET
	    .optname:	dd	SO_REUSEADDR
	    .optval:	dd	setsockoptvals
	    .optlen:	dd	4
setsockoptvals:	dd	1
		

args_client_n4:
		.sock:		dd	0
		dd	sockaddr_in
		dd	ssize		
args_client_n3:
		.sock:		dd	0
		.maxcon:	dw	0		
args_client_n2:
		.sock:	dd	0
		dd	sockaddr_in
		.s_size:
		dd __STRUCT_S_SIZE__
args_client_n1:
		dd	PF_INET
		dd	SOCK_STREAM
		dd	IPPROTO_TCP
ssize: dd __STRUCT_S_SIZE__		
    
error_string:
    db	"ERROR:",0
pass_str:
    db	"Password :",0
t_long:
    db	"Error: phrase is too long",0xA,0
gen_loginp:
	mov	dword [.len],5
	mov	edi,pack_login+5
	mov	byte [edi - 1],PTYPE_LOGIN
	push	edi
	    mov	edi,dword[ps_argv.s2]
	    call strlen_z
	    cmp	ecx,MAXNAME
	    jb	.nx
	.ep:	    
	    mov eax,t_long
	    call write
	    call @exit
	.nx:
	    add dword[.len],ecx
	pop	edi
	    mov esi,dword[ps_argv.s2]
	    call strcat_z
	push	edi
	    mov edi,dword[ps_argv.s3]
	    call strlen_z
	    cmp ecx,MAXNAME
	    jae .ep
	    add dword[.len],ecx
	pop	edi
	    mov esi,dword[ps_argv.s3]
	    call strcat_z
	;;;
	ret
.len	dd	0
SIGPIPE_handler:
	mov eax,.str
	call write
	call @exit
	;;;
	ret
.str:	db	"Error: Server access denied!",0xA,0
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
recv_packs:
		mov	eax,SYS_SOCK
		mov	ebx,SYS_RECVFROM
		mov	ecx,recv_params
		int	0x80
		or	eax,eax
		js	near @error
		push	eax
		mov	eax,dword[sockaddr1.sll_ifindex]
		mov	dword[ifreq.flags], eax
		mov	eax,54
		mov	ebx,dword[sock_traf]
		mov	ecx,SIOCGIFNAME
		mov	edx,ifreq
		int	0x80
		or	eax,eax
		js	near @error
		mov	edi,ifreq.ifrn_name
		call	strlen
		inc	ecx
		add	ecx,(iphdr_size+tcphdr_size+0x100+4+1+4+2+1)
		mov	dword[pack_alen],ecx
		mov	edi,packet_buffer
		mov	eax,ecx
		cld
		stosd
		mov	al,PTYPE_ENTRY
		stosb
		pop	eax
		stosd
		mov	esi,ifreq.ifrn_name
		call	strcat_z
		mov	ax,word[sockaddr1.sll_hatype]
		stosw
		mov	al,byte[sockaddr1.sll_pkttype]
		stosb
		mov	esi,recv_buffer
		mov	ecx,0x100/4
		rep	movsd
		;;;
		ret
pack_alen	dd	0

get_packet_p:
		cld
		mov	esi,recv_buffer+iphdr.saddr
		mov	edi,diff_pack
		mov	ecx,2
		rep	movsd
		mov	ecx,2
		rep	movsw
		mov	al,byte [recv_buffer+iphdr.protocol]
		mov	byte[diff_pack.proto],al
		;;;
		ret
send_to_server:
		mov	eax,4
		mov	ebx,[client_socket]
		mov	edx,dword[pack_alen]
		mov	ecx,packet_buffer
		int	0x80
		or	eax,eax
		js	near @error
		;;;
		ret

check_pack:
		call	another_header
		mov	esi,recv_buffer
		add	esi,eax
		mov	edi,esi
		add	esi,iphdr.saddr
		mov	edx,esi
		cld
		mov	al,byte [edi+iphdr.protocol]
		cmp	al,[diff_pack.proto]
		jnz	.ok
		lodsd
		cmp	eax,dword[diff_pack.sip]
		jnz	.ok
		lodsd
		cmp	eax,dword[diff_pack.dip]
		jnz	.ok
		lodsw
		mov	cx,ax
		cmp	ax,word[diff_pack.sp]
		jnz	.cp
		lodsw
		cmp	ax,word[diff_pack.dp]
		jnz	.ok
		stc
		;;;
		ret	
	.ok:
		clc
		;;;
		ret
	.cp:
		cmp	cx,word[diff_pack.dp]
		jnz	.ok
		stc
		;;;
		ret
sprt	times	100 	db	0
another_header:
		mov	esi,link_types
		cld
		movzx	ebx,word[sockaddr1.sll_hatype]
	    .lp
		lodsd
		or	eax,eax
		jz	.ex
		cmp	ax,bx
		je	.add
		jmp	short	.lp
	    .add:
		shr	eax,16
	    .ex
		;;;
		ret		
link_types:		
		dw	ARPHRD_ETHER
		dw	ETH_HLEN
		
		dw	ARPHRD_LOOPBACK
		dw	ETH_HLEN
		
		dw	ARPHRD_FDDI
		dw	21		
				
		dd	0		

strcat:
		push	edi
		    mov	edi,esi
		    call strlen
		pop	edi
		rep	movsb
		;;;
		ret
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
		inc	ecx
		rep	movsb
		;;;
		ret    
traf_init:
		mov	eax,ETH_P_ALL		
		xchg	ah,al
		mov	dword [param_sock1.proto], eax
		mov	eax,SYS_SOCK
		mov	ebx,SYS_SOCKET
		mov	ecx,param_sock1
		int	0x80
		or	eax,eax
		js	near @error
		mov	dword [sock_traf], eax
		push	eax
		mov	esi,ifname
		mov	edi,ifreq
		call	strcat
		pop	ebx
		mov	eax,54
		mov	ecx,SIOCGIFFLAGS
		mov	edx,ifreq
		int	0x80
		or	eax,eax
		js	near @error
		or	word [ifreq.flags], IFF_PROMISC
		mov	eax,54
		mov	ecx,SIOCSIFFLAGS
		mov	edx,ifreq
		int	0x80
		or	eax,eax
		js	near @error		
		mov	[recv_params.sock],ebx
		;;;
		ret    
traf_init2:
		mov	eax,ETH_P_ALL
		xchg	ah,al
		mov	dword [param_sock2.proto], eax
		mov	eax,SYS_SOCK
		mov	ebx,SYS_SOCKET
		mov	ecx,param_sock2
		int	0x80
		or	eax,eax
		js	near @error
		mov	dword [sock_traf], eax
		push	eax
		mov	esi,ifname
		mov	edi,ifreq
		call	strcat
		pop	ebx
		mov	eax,54
		mov	ecx,SIOCGIFFLAGS
		mov	edx,ifreq
		int	0x80
		or	eax,eax
		js	near @error
		or	word [ifreq.flags], IFF_PROMISC
		mov	eax,54
		mov	ecx,SIOCSIFFLAGS
		mov	edx,ifreq
		int	0x80
		or	eax,eax
		js	near @error
		mov	[recv_params.sock],ebx
		;;;
		ret    
crlf:
	mov eax,4
	mov ebx,1
	mov ecx,crlf_d
	mov edx,1
	int 0x80
	;;;
	ret
crlf_d	db	0xA
term_echo_on:
	    or	dword [sattr+termios.c_lflag],(ECHO)
	    mov eax,54
	    sub ebx,ebx
	    mov ecx,TCSETS
	    mov edx,sattr
	    int 0x80	    
	    ;;;
	    ret
term_echo_off:
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

;;INPUT: esi=*ip_str;
;;OUT: eax=ip;
sIPtoN:
		sub	eax,eax
		;mov	ch,4
		;mov	cl,'.'
		mov	cx,0x042e
	.lp:
		    push	eax
			call	strdec
		    pop		eax
		    and	ebx,0x000000ff
		    mov	al,bl
		dec	ch
		jz	.ex
		    shl	eax,8
		jmp	short .lp
	.ex:
		;;;
		ret
;;INPUT: dl='symbol_eos', esi=*ip_str		;
;;OUT: Carry=1 if error, otherwise syntax ok	;
chkIPsyntax:
		sub	dh,dh
		sub	bl,bl
		clc
		cld
	    .lp:
		lodsb
		or	al,dl
		jz	.eos
		cmp	al,'.'
		je	.nxp
		cmp	al,'0'
		jb	.eeos
		cmp	al,'9'
		ja	.eeos
		inc	bl
	    jmp	short	.lp
	    .nxp:
		or	bl,bl
		jz	.eeos
		sub	bl,bl
		inc	dh
		jmp	short .lp
	    .eos:
		cmp dh,3
		je .nxeos
	    .eeos:
		stc
	    .nxeos:
		;;;
		ret
;;INPUT: esi=*string, cl='symbol_eos'	;
;;OUT: ebx=NUM				;
strdec:
		sub	edx,edx
		sub	eax,eax
		sub	ebx,ebx
		cld
	.lp
		lodsb
		cmp	al,cl
		je	.ex
		or	al,al
		jz	.ex
		and	al,1111b
		add	edx,eax
		mov	ebx,edx
		imul	edx,edx,10
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
@error:
		neg	eax
		push	eax
		    mov	eax,error_string
		    call write
		pop	eax
		mov	esi,errno
		call	show_errno
		call	@exit    
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
;;ESI = *errno`s;
;;EAX = NUMBER_OF_ERROR;
show_errno:
	    dec	eax
	    or	eax,eax
	    jz	show_e1
	    js	show_e1
	    mov	ebx,eax
	    sub	al,al
	    mov	edi,esi
	    cld
    lp:	    
	    mov	ecx,-1
	    repnz scasb
	    cmp byte [edi], 0
	    jne	.nx
	    inc	edi
	    jmp	short .sh
	.nx:
	    dec	ebx
	    jnz	lp
	.sh:
	    mov	esi,edi
show_e1:
	    mov	edi,esi
	    sub	al,al
	    sub	ecx,ecx
	    dec	ecx
	    cld
	    repnz scasb
	    not	ecx
	    mov	byte [edi-1],0xA
	    xchg edx,ecx
	    mov	eax,4
	    mov ebx,1
	    mov ecx,esi
	    int	0x80
	    mov	byte [edi-1],0
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
		
;;INPUT: ecx = count of args, 	;
;;esi = offset to argv struct	;
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
		mov byte[esi],1
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
errno:
db " Operation not permitted ",0
db " No such file or directory ",0
db " No such process ",0
db " Interrupted system call ",0
db " I/O error ",0
db " No such device or address ",0
db " Arg list too long ",0
db " Exec format error ",0
db " Bad file number ",0
db " No child processes ",0
db " Try again ",0
db " Out of memory ",0
db " Permission denied ",0
db " Bad address ",0
db " Block device required ",0
db " Device or resource busy ",0
db " File exists ",0
db " Cross-device link ",0
db " No such device ",0
db " Not a directory ",0
db " Is a directory ",0
db " Invalid argument ",0
db " File table overflow ",0
db " Too many open files ",0
db " Not a typewriter ",0
db " Text file busy ",0
db " File too large ",0
db " No space left on device ",0
db " Illegal seek ",0
db " Read-only file system ",0
db " Too many links ",0
db " Broken pipe ",0
db " Math argument out of domain of func ",0
db " Math result not representable ",0
db " Resource deadlock would occur ",0
db " File name too long ",0
db " No record locks available ",0
db " Function not implemented ",0
db " Directory not empty ",0
db " Too many symbolic links encountered ",0
db " Operation would block ",0
db " No message of desired type ",0
db " Identifier removed ",0
db " Channel number out of range ",0
db " Level 2 not synchronized ",0
db " Level 3 halted ",0
db " Level 3 reset ",0
db " Link number out of range ",0
db " Protocol driver not attached ",0
db " No CSI structure available ",0
db " Level 2 halted ",0
db " Invalid exchange ",0
db " Invalid request descriptor ",0
db " Exchange full ",0
db " No anode ",0
db " Invalid request code ",0
db " Invalid slot ",0
db " Bad font file format ",0
db " Device not a stream ",0
db " No data available ",0
db " Timer expired ",0
db " Out of streams resources ",0
db " Machine is not on the network ",0
db " Package not installed ",0
db " Object is remote ",0
db " Link has been severed ",0
db " Advertise error ",0
db " Srmount error ",0
db " Communication error on send ",0
db " Protocol error ",0
db " Multihop attempted ",0
db " RFS specific error ",0
db " Not a data message ",0
db " Value too large for defined data type ",0
db " Name not unique on network ",0
db " File descriptor in bad state ",0
db " Remote address changed ",0
db " Can not access a needed shared library ",0
db " Accessing a corrupted shared library ",0
db " .lib section in a.out corrupted ",0
db " Attempting to link in too many shared libraries ",0
db " Cannot exec a shared library directly ",0
db " Illegal byte sequence ",0
db " Interrupted system call should be restarted ",0
db " Streams pipe error ",0
db " Too many users ",0
db " Socket operation on non-socket ",0
db " Destination address required ",0
db " Message too long ",0
db " Protocol wrong type for socket ",0
db " Protocol not available ",0
db " Protocol not supported ",0
db " Socket type not supported ",0
db " Operation not supported on transport endpoint ",0
db " Protocol family not supported ",0
db " Address family not supported by protocol ",0
db " Address already in use ",0
db " Cannot assign requested address ",0
db " Network is down ",0
db " Network is unreachable ",0
db " Network dropped connection because of reset ",0
db " Software caused connection abort ",0
db " Connection reset by peer ",0
db " No buffer space available ",0
db " Transport endpoint is already connected ",0
db " Transport endpoint is not connected ",0
db " Cannot send after transport endpoint shutdown ",0
s1:  db " Too many references: cannot splice ",0
db " Connection timed out ",0
db " Connection refused ",0
db " Host is down ",0
db " No route to host ",0
db " Operation already in progress ",0
db " Operation now in progress ",0
db " Stale NFS file handle ",0
db " Structure needs cleaning ",0
db " Not a XENIX named type file ",0
db " No XENIX semaphores available ",0
db " Is a named type file ",0
db " Remote I/O error ",0
db " Quota exceeded ",0
db " No medium found ",0
db " Wrong medium type ",0,0
db	" Unknown error",0		
	
    align	16
_elf_filesz	equ	$ - $$
[absolute 0x08048000 + _elf_filesz]
_data:
sock_traf	resd	1
client_socket:	resd	1
diff_pack:
	.sip	resd	1
	.dip	resd	1
	.sp	resw	1
	.dp	resw	1
	.proto	resb	1
ifreq:
	.ifrn_name: resb 16
	.flags:	resw	1
	.port:	resw	1
	.addr:	resd	1
	.unused: resb	8
sattr		resb	termios_size
pass_buffer	resb	BUFFERSIZE
packet_buffer	resb	BUFFERSIZE
pack_login	resb	MAXNAME*3
recv_buffer	resb	BUFFERSIZE*5
_elf_phdr_flags	equ	7		
_elf_memsz	equ	$ - origin
