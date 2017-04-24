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
%include "inc/defos.h"

%define BUFFERSIZE 0x1000

%define	DB_ID_LOG		1
%define	DB_ID_LOG_BIP		2
%define DB_ID_STO		3
%define	DB_ID_LBE		4
%define DB_ID_LBP		5
%define DB_ID_LBE_PORT		6
%define DB_ID_LB_PROTO		7
%define DB_ID_LB_PROTO_EACH	8
%define DB_ID_LBP_IP		9
%define DB_ID_LBP_IP_EACH	10
%define	DB_ID_LBEP_EIP		11
%define	DB_ID_LBE_LOCAL		12
%define	DB_ID_LOG_BIP_LOCAL	13
%define DB_ID_LB_PROTO_IP	14
%define DB_ID_LB_PROTO_IP_EACH	15
%define DB_ID_LB_EPROTO_EIP	16
%define	DB_ID_LS_BY_IFACE	17
%define	DB_ID_LS_BY_IFACE_JOINT	18
%define DB_ID_LBE_LS_EACH	19
%define DB_ID_LBE_LS_EACH_JOINT	20
%define DB_ID_IP_ENTRY_LIST	21
%define DB_ID_IP_LIMIT		22
%define DB_ID_IPE_LIMIT		23
%define DB_ID_PR_LIMIT		24
%define DB_ID_ECPR_LIMIT	25
%define DB_ID_PROTO_LIMIT	26
%define DB_ID_ECPROTO_LIMIT	27
%define DB_ID_PR_LIMIT_IP	28
%define DB_ID_PR_LIMIT_IP_EACH	29
%define DB_ID_EPR_LIMIT_EIP	30
%define DB_ID_PROTO_IP_LIMIT	31
%define DB_ID_PROTO_EIP_LIMIT 	32
%define DB_ID_EPROTO_EIP_LIMIT 	33
%define	DB_ID_IFACE_LIMIT	34
%define	DB_ID_LS_PORT_EIP	35
%define	DB_ID_LS_PORT_EIP_JOINT	36
%define	DB_ID_LS_EPORT_EIP	  37
%define	DB_ID_LS_EPORT_EIP_JOINT  38
%define	DB_ID_LS_PROTO_EIP	  39
%define	DB_ID_LS_PROTO_EIP_JOINT  40
%define	DB_ID_LS_EPROTO_EIP	  41
%define	DB_ID_LS_EPROTO_EIP_JOINT 42
%define	DB_ID_FULL_LBEP_EIP	  43
%define	DB_ID_LS_FULL_BEP_EIP	  44
%define	DB_ID_LS_FULL_BEP_EIP_JT  45

		pop	ecx
		sub	ecx,3
		jns	.next
		call	show_usage
		call	@exit
	.next:
		pop	eax
		pop	eax
		mov	dword[file_name],eax
		inc	ecx		
		mov	dword[count_nm],ecx
	.lp_names:
		pop	eax
		mov	dword[name_addr],eax
		call	cut_db
		test	byte[cut_db.tentry],1
		jz	.do_next
		mov	eax,10 ;unlink
		mov	ebx,dword[file_name]
		int	0x80	
		mov	eax,38 ;rename
		mov	ebx,tmp_name
		mov	ecx,dword[file_name]
		int	0x80
	.do_next:
		dec	dword[count_nm]
		jnz	.lp_names
			    
@exit:
		xor	eax,eax
		inc	eax
		xor	ebx,ebx
		int	0x80
usage:		db	"Usage: cutdb <file_db> <function_names [...]>",0xA,0xA
		db	"function names list:",0xA,0xA
		db	0
cut_db:
	mov	byte[.tentry],0
	mov	edi,dword[file_name]
	call	strlen
	cmp	ecx,BUFFERSIZE-1
	jae	near .er1
	mov	edi,tmp_name
	mov	esi,dword[file_name]
	call	strcat_z
	mov	esi,.tmp_ext
	mov	edi,tmp_name
	call	split
	mov	eax,5
	mov	ebx,tmp_name
	mov	ecx,O_WRONLY|O_CREAT
	int	0x80
	or	eax,eax
	js	near .er2
	mov	dword[.tmp_fd],eax
	mov	ebx,dword[file_name]
	call	mmap_file
	mov	dword[.mem_addr],eax
	mov	edi,dword[name_addr]
	call	find_db_by_name
	mov	byte[.table],al
	
	mov	esi,dword[.mem_addr]
	lodsd
	mov dword[.addr_table],start_table
	mov ebp,eax
    .lp:
	lodsd
	or eax,eax
	jz .finish
	 mov 	ebx,eax
	 sub 	eax,ebp
	 mov	ecx,eax
	 sub	ecx,5
	 mov	ebp,ebx
	 lodsb	 
	 mov	dl,al
	 cmp	al,[.table]
	 jz	.nx_table
	 push ecx
	  push esi
	   call	add_to_db
	  pop esi
	 pop ecx
	lea esi,[ecx + esi]
	jmp short .lp
    .nx_table:
	mov byte[.tentry],1
	lea esi,[ecx + esi]	
	jmp short .lp
.addr_table	dd	0
.finish:
	mov	ebx,dword[.tmp_fd]
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
	test	byte[.tentry],1
	jnz	.next
	mov	esi,.tmess
	mov	edi,buffer
	call	strcat_z
	mov	esi,dword[name_addr]
	mov	edi,buffer
	call	split
	mov	esi,.tmess1
	mov	edi,buffer
	call	split
	mov	eax,buffer
	call	write
	mov	eax,6
	mov	ebx,dword[.tmp_fd]
	int	0x80
	mov	eax,10
	mov	ebx,tmp_name
	int	0x80	
	jmp	short .next2
.next:
	mov	esi,.smess
	mov	edi,buffer
	call	strcat_z
	mov	esi,dword[name_addr]
	mov	edi,buffer
	call	split
	mov	esi,.smess1
	mov	edi,buffer
	call	split
	mov	eax,buffer
	call	write
	mov	eax,6
	mov	ebx,dword[.tmp_fd]
	int	0x80
.next2:	
	mov	eax,91
	mov	ebx,dword[.mem_addr]
	mov	ecx,dword[mmap_buf.len]
	int	0x80		
	mov	eax,6
	mov	ebx,dword[mmap_buf.fd]
	int	0x80
	;;;
	ret
.er2:
	mov eax,.err_o
	jmp short .er_ex
.er1:
	mov eax,.too_long
.er_ex:
	call write
	call @exit
	
.err_o		db	"Error while opening file",0xA,0
.too_long	db	"file name is too long",0xA,0
.tmp_ext	db	".temp",0
.mem_addr	dd	0
.tmp_fd		dd	0
.table		db	0
.tentry		db	0
.tmess		db	"Table entry for ",0
.tmess1		db	" function is absent",0xA,0
.smess		db	"Table entry for ",0
.smess1		db	" function is succefully deleted",0xA,0
.zero		db	0

;;INPUT: esi=*buffer, ecx=buf_length, dl=ID;
;;OUTPUT: esi=*start_buffer;
add_to_db:
	mov	edi,dword[eodb]
	lea	ebx,[edi+ecx+5]
	mov	dword[eodb],ebx
	push	ebx
	mov	eax,45
	add	ebx,4	;dword[flag_table_end](0)
	int	0x80
	pop	ebx
	mov	eax,ebx
	stosd
	mov	al,dl
	stosb
	push	edi
	mov	eax,edx
	mov	edx,ecx
	shr	ecx,2
	rep	movsd
	mov	ecx,edx
	and	ecx,11b
	rep	movsb
	mov	edx,eax	
	sub	eax,eax
	stosd
	pop	esi
	;;;
	ret	    
eodb		dd	start_table
;;OUTPUT: al=db_name;
find_db_by_name:
	    mov	esi,functions
	    cld
	.lp:
	    push edi
	     call strcmp
	    pop edi	    	    
	    jecxz .founded
	    call to_zero
	    lodsw
	    dec esi
	    or ah,ah
	    jnz .lp
	    
	    mov	eax,.nf_ms
	    call write
	    call @exit
.founded:
	    lodsb
	    ;;;
	    ret
.nf_ms	db	"ERROR, function name is wrong !",0xA,0

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

show_usage:
		mov eax,usage
		call write
		mov esi,functions
		cld
	.lp:
		mov eax,esi
		call write
		mov eax,4
		mov ebx,1
		mov ecx,.br
		mov edx,1
		int 0x80
		call to_zero
		lodsw
		dec esi		
		or ah,ah
		jnz .lp
		mov eax,4
		mov ebx,1
		mov ecx,.br
		mov edx,1
		int 0x80		
		;;;
		ret
		
.br	db	0xA

to_zero:
    .lp:
	lodsb
	or al,al
	jnz .lp
	;;;
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
		jnz	.ex
		inc	ecx
		repe	cmpsb
	.ex:
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
	;esi=from
	;edi=to
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
		mov	edx,ecx
		shr	ecx,2
		rep	movsd
		mov	ecx,edx
		and	ecx,11b
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
	    mov ebx,1
	    int	0x80
	    ret	    
	    
;;INPUT: ebx=file_name		;
;;OUT: eax=address_of_mem	;
mmap_file:
	mov	eax,5
	mov	ecx,O_RDWR
	int	0x80
	or	eax,eax
	js	.er
	mov	dword[file_fd], eax
	xchg	eax,ebx
	mov	eax,19
	sub	ecx,ecx
	mov	edx,SEEK_END
	int	0x80
	or	eax,eax
	js	.er1
	mov	dword[file_size], eax
	mov	dword [mmap_buf.len], eax
	xchg	eax,ecx
	mov	[mmap_buf.fd], ebx
	mov	eax,90
	mov	ebx,mmap_buf
	int	0x80
	or	eax,eax
	js	.er2
	;;;
	ret
.er:
	mov	eax,.er0_ms
	jmp	short .er_ex
.er2:
	mov	eax,.er2_ms
	jmp	short .er_ex
.er1:
	mov	eax,.er1_ms
.er_ex:
	call	write
	call	@exit
	
.er0_ms:	db	"Error while open file!",0xA,0
.er1_ms:	db	"Error while seek file!",0xA,0
.er2_ms:	db	"Error while mmap file!",0xA,0

mmap_buf:
		dd	0
	    .len:
		dd	0
		dd	PROT_READ|PROT_WRITE
		dd	MAP_SHARED
	    .fd:
		dd	0
		dd	0

functions:
	db	"log_file",0
	    db	DB_ID_LOG
	    
	db	"log_by_ip",0
	    db	DB_ID_LOG_BIP
	    
	db	"log_by_each_ip",0
	    db	DB_ID_LBE
	    
	db	"log_by_port",0
	    db	DB_ID_LBP
	
	db	"log_by_each_port",0
	    db	DB_ID_LBE_PORT
	    
	db	"log_by_proto",0
	    db	DB_ID_LB_PROTO
	    
	db	"log_by_each_proto",0
	    db	DB_ID_LB_PROTO_EACH
	    
	db	"log_by_port_ip",0
	    db	DB_ID_LBP_IP
	
	db	"log_by_port_ip_each",0
	    db	DB_ID_LBP_IP_EACH
	
	db	"log_by_eport_eip",0
	    db	DB_ID_LBEP_EIP
	    
	db	"log_by_each_ip_local",0
	    db	DB_ID_LBE_LOCAL
	    
	db	"log_by_ip_local",0
	    db	DB_ID_LOG_BIP_LOCAL
	    
	db	"log_by_proto_ip",0
	    db	DB_ID_LB_PROTO_IP
	
	db	"log_by_proto_ip_each",0
	    db	DB_ID_LB_PROTO_IP_EACH
	    
	db	"log_by_eproto_eip",0
	    db	DB_ID_LB_EPROTO_EIP
	    
	db	"ls_by_iface",0
	    db	DB_ID_LS_BY_IFACE
	
	db	"ls_by_iface-joint",0
	    db	DB_ID_LS_BY_IFACE_JOINT
	    
	db	"ls_by_each_ip",0
	    db	DB_ID_LBE_LS_EACH
	    
	db	"ls_by_each_ip-joint",0
	    db	DB_ID_LBE_LS_EACH_JOINT
	
	db	"ip_entry_list",0
	    db	DB_ID_IP_ENTRY_LIST
	    
	db	"ip_range_traf_limit",0
	    db	DB_ID_IP_LIMIT
	    
	db	"ip_each_traf_limit",0
	    db	DB_ID_IPE_LIMIT
	    
	db	"port_range_limit",0
	    db	DB_ID_PR_LIMIT
	
	db	"each_port_limit",0
	    db	DB_ID_ECPR_LIMIT
	    
	db	"proto_range_limit",0
	    db	DB_ID_PROTO_LIMIT
	    
	db	"proto_each_limit",0
	    db	DB_ID_ECPROTO_LIMIT
	    
	db	"port_ip_limit",0
	    db	DB_ID_PR_LIMIT_IP
	
	db	"port_ip_each_limit",0
	    db	DB_ID_PR_LIMIT_IP_EACH
	    
	db	"eport_eip_limit",0
	    db	DB_ID_EPR_LIMIT_EIP
	    
	db	"proto_ip_limit",0
	    db	DB_ID_PROTO_IP_LIMIT
	    
	db	"proto_ip_each_limit",0
	    db	DB_ID_PROTO_EIP_LIMIT
	    
	db	"eproto_eip_limit",0
	    db	DB_ID_EPROTO_EIP_LIMIT
	    
	db	"iface_limit",0
	    db	DB_ID_IFACE_LIMIT
	    
	db	"ls_by_port_ip_each",0
	    db	DB_ID_LS_PORT_EIP
	    
	db	"ls_by_port_ip_each-joint",0
	    db	DB_ID_LS_PORT_EIP_JOINT
	    
	db	"ls_by_eport_eip",0
	    db	DB_ID_LS_EPORT_EIP
	
	db	"ls_by_eport_eip-joint",0
	    db	DB_ID_LS_EPORT_EIP_JOINT
	    
	db	"ls_by_proto_ip_each",0
	    db	DB_ID_LS_PROTO_EIP
	    
	db	"ls_by_proto_ip_each-joint",0
	    db	DB_ID_LS_PROTO_EIP_JOINT
	    
	db	"ls_by_eproto_eip",0
	    db	DB_ID_LS_EPROTO_EIP
	    
	db	"ls_by_eproto_eip-joint",0
	    db	DB_ID_LS_EPROTO_EIP_JOINT
	    
	db	"full_log_by_each_ip",0
	    db	DB_ID_FULL_LBEP_EIP
	    
	db	"ls_full_by_each_ip",0
	    db	DB_ID_LS_FULL_BEP_EIP
	    
	db	"ls_full_by_each_ip-joint",0
	    db	DB_ID_LS_FULL_BEP_EIP_JT
	db	0
	
    align	16
_elf_filesz	equ	$ - $$
[absolute 0x08048000 + _elf_filesz]
_data:
    file_fd	resd	1
    file_size	resd	1
    file_name	resd	1
    count_nm	resd	1
    name_addr	resd	1
    buffer	resb	BUFFERSIZE
    tmp_name	resb	BUFFERSIZE
start_table:
_elf_phdr_flags	equ	7		
_elf_memsz	equ	$ - origin
