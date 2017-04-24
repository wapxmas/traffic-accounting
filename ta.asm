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

%define S_BUFFER skin_buffer
%define S_LENGTH ((0x10000*0x10) - 0x100)

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

%assign SEEK_SET	0
%assign SEEK_CUR	1
%assign SEEK_END	2
%assign O_RDONLY	0

%assign	WNOHANG		1	;/* Don't block waiting.  */
%assign	WUNTRACED	2	;/* Report status of stopped children.  */


%define TYPE_STRING	1
%define TYPE_NUM	2
%define TYPE_IP		3
%define TYPE_PATTERN	4
%define TYPE_FILE	5
%define	TYPE_SYMBOL	6
%define	TYPE_SYNUM	7
%define TYPE_PORT	8
%define TYPE_RAW	9
%define	TYPE_TLIMIT	10

%define	TFUNC_NORMAL		1
%define TFUNC_DENY		2
%define	TFUNC_DENY_BY_NAME	3
%define TFUNC_NULL		4
%define TFUNC_INIT		5

%define IPTYPE_RANGE		000001b
%define IPTYPE_NRMAL		000010b
%define IPTYPE_SRC		000100b
%define IPTYPE_DST		001000b
%define IPTYPE_ALL		010000b
%define	IPTYPE_MASK		100000b

%define PPT_NORMAL		01b
%define PPT_RANGE		10b

%define TRAFFIC_PCOUNT		10000

%define	MAX_PATH_LEN		0x1000
%define MAXPATHLEN		MAX_PATH_LEN
%define	PSIG	2

%assign	SA_NOCLDSTOP  1		 ;/* Don't send SIGCHLD when children stop.  */
%assign	SA_NOCLDWAIT  2		 ;/* Don't create zombie on child death.  */
%assign	SA_SIGINFO    4		 ;/* Invoke signal-catching function with
			 ;    three arguments instead of one.  */
%assign	SA_ONSTACK   0x08000000 ;/* Use signal stack by using `sa_restorer'. */
%assign	SA_RESTART   0x10000000 ;/* Restart syscall on signal return.  */
%assign	SA_NODEFER   0x40000000 ;/* Don't automatically block the signal when
			 ;    its handler is being executed.  */
%assign	SA_RESETHAND 0x80000000 ;/* Reset to SIG_DFL on entry to handler.  */
%assign	SA_INTERRUPT 0x20000000 ;/* Historical no-op.  */
;/* Some aliases for the SA_ constants.  */
%assign	SA_NOMASK    SA_NODEFER
%assign	SA_ONESHOT   SA_RESETHAND
%assign	SA_STACK     SA_ONSTACK

%define IFMAXNAME	16

%define	MAXPC_PROTO_SKIN 1
%define	MAXL_PROTO_SKIN	0x1000
%define	MAXC_PROTO_SKIN	1

%define	MAXPC_PORT_SKIN	1
%define	MAXL_PORT_SKIN	0x1000
%define	MAXC_PORT_SKIN	1

%define	MAXPC_CR_TRAF_SKIN	1
%define	MAXL_CR_TRAF_SKIN	0x1000
%define	MAXC_CR_TRAF_SKIN	1

%define	MAXPC_JT_TRAF_SKIN	1
%define	MAXL_JT_TRAF_SKIN	0x1000
%define	MAXC_JT_TRAF_SKIN	1

%define	MAXPC_TABLE_SKIN	1
%define	MAXL_TABLE_SKIN		0x1000
%define	MAXC_TABLE_SKIN		1

%define	MAXPC_TABLE_END_SKIN	1
%define	MAXL_TABLE_END_SKIN	0x1000
%define	MAXC_TABLE_END_SKIN	1

%define	MAXPC_TROW_SKIN	1
%define	MAXL_TROW_SKIN	0x1000
%define	MAXC_TROW_SKIN	1

%define	MAXPC_TCOL_SKIN	1
%define	MAXL_TCOL_SKIN	0x1000
%define	MAXC_TCOL_SKIN	1

%define	MAXPC_END_TROW_SKIN	1
%define	MAXL_END_TROW_SKIN	0x1000
%define	MAXC_END_TROW_SKIN	1

%define	MAXPC_END_TCOL_SKIN	1
%define	MAXL_END_TCOL_SKIN	0x1000
%define	MAXC_END_TCOL_SKIN	1

%define	MAXPC_END_SKIN	1
%define	MAXL_END_SKIN	0x1000
%define	MAXC_END_SKIN	10

%define	MAXPC_HEAD_SKIN	1
%define	MAXL_HEAD_SKIN	0x1000
%define	MAXC_HEAD_SKIN	10

%define	MAXPC_IO_SKIN	1
%define	MAXL_IO_SKIN	0x1000
%define	MAXC_IO_SKIN	1

%define	MAXPC_DEV_SKIN	1
%define	MAXL_DEV_SKIN	0x1000
%define	MAXC_DEV_SKIN	1

%define	MAXPC_IP_SKIN	1
%define	MAXL_IP_SKIN	0x1000
%define	MAXC_IP_SKIN	1

%define	MAXPC_MC_DEV	1
%define	MAXL_MC_DEV	0x1000
%define	MAXC_MC_DEV	1

%define	MAXPC_MC_DIR	1
%define	MAXL_MC_DIR	0x1000
%define	MAXC_MC_DIR	1

%define	MAXPC_MC_MLOG	1
%define	MAXL_MC_MLOG	0x1000
%define	MAXC_MC_MLOG	1

%define	MAXPC_MC_SPC	1
%define	MAXL_MC_SPC	0x2
%define	MAXC_MC_SPC	1

%define MAXPC_MC_SERVER_PORT	1
%define	MAXL_MC_SERVER_PORT	0x1000
%define	MAXC_MC_SERVER_PORT	1

%define	MAXPC_MC_SKIN_PATH	1
%define	MAXL_MC_SKIN_PATH	0x1000
%define	MAXC_MC_SKIN_PATH	1


%define	COUNT_FUNCS	100

%define BUFFERLEN	MAXIPACKTLEN
    
%define TMTYPE_ANY	0
%define TMTYPE_ADIV	1
%define	TMTYPE_SP	2
%define TMTYPE_RN	3
%define TMTYPE_RNDIV	4
%define TMTYPE_ENEW	5

%define PTYPE_DST	IPTYPE_DST
%define PTYPE_SRC	IPTYPE_SRC
%define PTYPE_ALL	IPTYPE_ALL
%define PTYPE_RANGE	IPTYPE_RANGE

%include "inc/socket.h"
%include "inc/others.h"
%include "inc/protos.h"
%include "inc/server.h"
%include "inc/md5.h"
%include "inc/rc6.h"
%include "inc/dbname.h"
%include "inc/fdefs.h"
%include "inc/idtime.h"
%define  __SOCK_SIZE__	16
%define  __ASOCK_SIZE__    (__SOCK_SIZE__ -  2 - 2 - 4)
%define  __STRUCT_S_SIZE__ (__ASOCK_SIZE__ + 2 + 2 + 4)
%define  SYS_SOCK	102
%define	MAXIPPACKLEN	65535
%assign	FBUFSIZE	0x2000		;size of the file buffer
%assign	BUFSIZE		FBUFSIZE
;;include macroses;
%include "inc_f/macro.asm"
;;end include;
		pop	ecx
		lea	eax,[esp+(ecx+1)*4]
		mov	dword[penv],eax
		pop	ebp
		dec	ecx
		mov	esi,esp
		mov	edi,ps_argv
		call	getarguments
		test	byte [ps_argv.e2],1
		jz	.next_argv
		mov	edi,dword[ps_argv.s2]
		call	strlen
		cmp	ecx,MAXPATHLEN-1
		ja	.argv_p2_long
		mov	esi,dword[ps_argv.s2]
		mov	edi,file_main_conf
		call	strcat_z
		jmp	short .next_argv1
	.argv_p2_long:
		mov	eax,err_path
		call	write
		call	@exit
	.next_argv:
		mov	esi,file_main_confd
		mov	edi,file_main_conf
		call	strcat_z
	.next_argv1:
		test	byte[ps_argv.e1],1
		jz	.after_argv_step
		setnz	byte[server]
		mov	esi,dword[ps_argv.s1]
		xor	cl,cl
		call	strdec
		mov	word[server_port],bx		
	.after_argv_step:
		test	byte[ps_argv.e3],1
		jz	.after_argv_step1
		cmp	dword[ps_argv.s3],0
		jz	.after_argv_step1
		mov	esi,dword[ps_argv.s3]
		mov	edi,pfile
		call	strcat_z
		jmp	short .after_argv_step2
	.after_argv_step1:
		mov	esi,pfileD
		mov	edi,pfile
		call	strcat_z
	.after_argv_step2:
		mov	ebx,file_main_conf
		call	file_exists
		jns	.next
		mov	esi,error_fne
		call	write2
		call	@exit
        .next:
		mov	ebx,file_main_conf
		mov	dword[c_file],ebx
		call	mmap_file
		call	init_funcs
		mov	dword[mem_start_file],eax
		mov	dword[begin_vars],main_conf
		call	parse_config_file
		cmp	dword[mc_dir_buffer], 0
		jnz	.next2
		mov	esi,error_vDIR
		call	write2
		call	@exit
	.next2:
		test	byte[server],1
		jnz	.after_argv_step3
		cmp	dword[server_port_buffer],0
		jz	.after_argv_step3
		setnz	byte[server]
		mov	ebx,dword[server_port_buffer+5]
		mov	word[server_port],bx
	.after_argv_step3
		cmp	dword[skin_path_buffer],0
		jz	.after_argv_step4
		mov	esi,skin_path_buffer+5
		mov	edi,skin_path
		call	strcat
		mov	esi,skin_path
		call	to_zero
		sub	esi,2
		cmp	byte[esi],'/'
		jz	.after_argv_step4
		mov	word[esi + 1],0x002f
	.after_argv_step4:
		;;MAIN LOG FILE;
		mov	eax,63
		mov	ebx,dword[mlogf+5]
		mov	ecx,1
		int	0x80	;dup2
		;;MAIN LOG FILE ENDS;
		
		;;SPECIAL CHAR BEGIN;
		cmp	byte [spc_char+5],0
		jz	.nx_c
		mov	al,byte[spc_char+5]
		mov	byte[spec_ch],al
	.nx_c:
		;;SPC ENDS;
		cmp	dword[mc_dev_buffer],0
		jnz	.next3
		mov	esi,error_vDEV
		call	write2
		call	@exit
	.next3:
		mov	edi,(mc_dir_buffer+5)
		call	strlen
		cmp	ecx,MAX_PATH_LEN
		jbe	.next4
		mov	esi,error_mxP
		call	write2
		call	@exit
	.next4:	
		mov	edi,(mc_dir_buffer+5)
		sub	ecx,ecx
		dec	ecx
		sub	al,al
		repnz	scasb
		sub 	edi,2
		cmp	byte[edi],'/'
		jz	.next5
		mov	word[edi+1],0x002f
	.next5:
		mov	esi,(mc_dir_buffer+5)
		mov	edi,path_cnf
		call	strcat
		movzx	edx,byte[mc_dev_buffer+5]
		mov	esi,(mc_dev_buffer+6)
		mov	dword[cpids],edx
		inc	dword[cpids]
	.lpd:
		push	esi
		    mov	edi,process.dev
		    call strcat_z
		    mov	edi,process.dev
		    call strlen
		    mov byte[process.len],cl
		    mov	esi,dbg
		    mov	edi,process.dfile
		    call strcat_z
		    mov	esi,process.dev
		    mov	edi,process.dfile
		    call split
		pop	esi
		mov	edi,path_cnf
		call	split
		push	esi
		     mov	esi,conf_ext
		     mov	edi,path_cnf
		     call 	split
		pop	esi
		    ;;PATH_CNF = path to config file	;
			mov	eax,2
			int	0x80	;fork
			or	eax,eax
			jnz	.cloop
			call	@process
		.cloop:
		    ;;		END MAIN PART		;
		push	esi
		     mov	esi,(mc_dir_buffer+5)
		     mov	edi,path_cnf
		     call 	strcat_z
		pop	esi
		inc	word[server_port]
		dec	edx
		jnz	.lpd		
		mov	eax,2
		int	0x80
		or	eax,eax
		jnz	.next6
		call	@exit
	.next6:	
@exit:		
		sub	eax,eax
		inc	eax
		sub	ebx,ebx
		int	0x80
mainP_sigaction:
		dec	dword[cpids]
		cmp	dword[cpids],0
		jne	.nx
		    call	@exit
	    .nx:
		;;;
		ret
sigstruct_traffic:
	dd	add_traffic.flush
	dd	0
	dd	SA_RESTART|SA_NOCLDSTOP|SA_NOMASK
	dd	0
	dd	0
tz_warn:	db	"WARNING: /etc/localtime not found !!",0xA,0
@process:
		;;some init movies;
		mov	dword[some_f_call_deny],0
		mov	dword[use_time_stamp],0
		
		mov	eax,67
		mov	ebx,SIGUSR1
		mov	ecx,sigstruct_traffic
		sub	edx,edx
		int	0x80
		mov	ebx,tzfilename
		call	file_exists
		jns	.tz_exists
		mov	eax,tz_warn
		call	write
	.tz_exists:
		mov	ebx,path_cnf
		call file_exists
		jns	.next
		mov	esi,process_cne
		call	write2
		call	@exit
	.next:
		mov	ebx,path_cnf
		mov	dword[c_file],ebx
		call	mmap_file
		call	init_funcs
		mov	dword[mem_start_file],eax
		mov	dword[begin_vars],strings
		call	parse_config_file
		
		mov	eax,ETH_P_ALL
		xchg	ah,al
		mov	dword [sockP.proto], eax
		mov	eax,SYS_SOCK
		mov	ebx,SYS_SOCKET
		mov	ecx,sockP
		int	0x80
		or	eax,eax
		jns	@ne_error
		push	eax
		mov	esi,error_m.s1
		call 	write2
		pop	eax
		jmp	@error
	@ne_error:
		mov	dword [socket], eax
		push	eax
		mov	esi,iface_main
		mov	edi,ifreq
		call	strcat_z
		pop	ebx
		mov	eax,54
		mov	ecx,SIOCGIFFLAGS
		mov	edx,ifreq
		int	0x80
		or	eax,eax
		jns	@ne_error2
		push	eax
		mov	esi,error_m.s2
		call 	write2
		pop	eax		
		jmp	@error
	@ne_error2:
		or	word [ifreq.flags], IFF_PROMISC
		mov	eax,54
		mov	ecx,SIOCSIFFLAGS
		mov	edx,ifreq
		int	0x80
		or	eax,eax
		jns	@ne_error1
		push	eax
		mov	esi,error_m.s3
		call 	write2
		pop	eax	
		jmp	@error
	@er_m1:
		push	eax
		mov	esi,error_m.s4
		call 	write2
		pop	eax			
		jmp	@error
	@er_m2:
		push	eax
		mov	esi,error_m.s5
		call 	write2
		pop	eax			
		jmp	@error		
	@ne_error1:
		mov	[recvP.sock],ebx
		mov	dword[recvP.buf],packet_buffer
		
		test	byte[rinit_funcs.ex],1
		jz	.pre_main_recvfrom
		mov	esi,rinit_funcs
		call	run_f
.pre_main_recvfrom:
		cmp	dword[stat_time_on_buffer],0
		jz	.do_nx
			;;STAT_TIME_ON - INIT. It sucky, i supposed.;
			sub	ecx,ecx
			cld
		    .lp:
			mov	esi,stat_time_on_buffer
			lodsd
			dec	eax
			imul	ebx,ecx,MAXL_STAT_TIME_ON
			add	esi,ebx
			    push ecx
				push	eax
	    			    call sto_add_to_table
				pop	eax
			    pop ecx
			inc	ecx
			cmp	ecx,eax
			jna	.lp
			mov	edx,timer_sto
			call	add_to_timer_f			
	    .do_nx:
		call	update_log_file_ssig
		cmp	byte[server],1
		jne	near main_recvfrom
    %include	"inc_f/ta.srv.asm"
main_recvfrom:
		mov	eax,SYS_SOCK
		mov	ebx,SYS_RECVFROM
		mov	ecx,recvP
		int	0x80
		or	eax,eax
		js	@er_m1
		mov	dword[packet.len], eax
		mov	dword[packet.flen], eax
		mov	eax,dword[packet.sll_ifindex]
		mov	dword[ifreq.flags], eax
		mov	eax,54
		mov	ebx,dword[socket]
		mov	ecx,SIOCGIFNAME
		mov	edx,ifreq
		int	0x80
		or	eax,eax
		js	@er_m2
		mov	esi,ifreq.ifrn_name
		mov	edi,packet.dev
		mov	ecx,IFMAXNAME/4
		rep	movsd
		call	another_header
		mov	ebx,packet_buffer
		add	ebx,eax
		sub	dword[packet.len],eax
		mov	dword[packet.ipdata], ebx
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
		jmp	main_recvfrom
	    .eq:
		test	byte[dfuncs_stable.ex],1
		jz	.next1
		mov	dword[some_f_call_deny],0
		mov	esi,dfuncs_stable
		call	run_f
		test	dword[some_f_call_deny],1
		jnz	main_recvfrom
	    .next1:
		test	byte[run_funcs.ex],1
		jz	.next2
		mov	esi,run_funcs
		call	run_f
	    .next2:
		jmp	main_recvfrom
		call	@exit
		;;;
		ret
start_timer:
	mov	eax,104
	mov	ebx,ITIMER_REAL
	mov	ecx,update_log_file_ssig.value
	sub	edx,edx
	int	0x80
	;;;
	ret
stop_timer:
	mov	eax,104
	mov	ebx,ITIMER_REAL
	mov	ecx,update_log_file_ssig.value2
	sub	edx,edx
	int	0x80
	;;;
	ret	
start_on_timer:
	call	stop_timer
	mov	eax,13
	mov	ebx,start_timer_value
	int	0x80
	test	byte[timer_funcs.ex],1
	jz	.nx
	mov	esi,timer_funcs
	call	run_f
    .nx:
	;call	update_log_file_ssig
	call	start_timer
	;;;
	ret
start_timer_value	dd	0
;;INPUT: edx:eax=v, ecx:ebx=d;
;;OUT: edx:eax=c, esi:edi=o;
div64:
		mov	ebp,64
		sub	esi,esi
		sub	edi,edi
	.lp:	shl	eax,1
		rcl	edx,1
		rcl	edi,1
		rcl	esi,1
		cmp	esi,ecx
		ja	.div
		jb	.nx
		cmp	edi,ebx
		jb	.nx
	.div:	sub	edi,ebx
		sbb	esi,ecx
		inc	eax
	.nx:	dec	ebp
		jnz	.lp
		;;;
		ret
;;INPUT: eax=value, edi=*buffer;
d2s:
		cld
		mov	ebx,10
		mov	ecx,1
		push	dword 0
    .lp:
		sub	edx,edx
		div	ebx
		xchg	edx,eax
		add	eax,0x30
		push	eax
		xchg	edx,eax
		inc	ecx
		or	eax,0
		jnz	.lp
    .lpc:
		pop	eax
		stosb
		dec	ecx
		jnz	.lpc
		ret
;;INPUT: edx:eax=value, edi=*buffer;

d64_2s:
		cld
		mov	ebx,10
		mov	ecx,1
		mov	dword[.out],edi
		push	dword 0
    .lp:
		push	ecx
		    sub	ecx,ecx
		    call div64
		pop	ecx
		add	edi,0x30
		push	edi
		inc	ecx
		or	eax,0
		jnz	.lp
		or	edx,0
		jnz	.lp
		mov	edi,dword[.out]
    .lpc:
		pop	eax
		stosb
		dec	ecx
		jnz	.lpc
		ret
    .out:	dd	0
run_f:
		cld
		lodsd
		sub	esi,4
		or	eax,eax
		jnz	.lp
		;;;
		ret
	    .lp:
		push	eax
		    push	esi
			call	[esi+eax*4]
		    pop		esi
		pop	eax
		dec	eax
		jnz	.lp		
		;;;
		ret
;;INPUT: esi=str1, edi=str2, ecx=COUNT;
;;OUT: ecx=0 then str`s is equal;
another_header:
		mov	esi,link_types
		cld
		movzx	ebx,word[packet.sll_hatype]
	    .lp
		lodsd
		or	eax,eax
		jz	.ex
		cmp	ax,bx
		jz	.add
		jmp	short	.lp
	    .add:
		shr	eax,16
	    .ex
		;;;
		ret
send_Pok:
		mov	eax,64
		int	0x80
		xchg	eax,ebx
		mov	eax,37
		mov	ecx,PSIG
		int	0x80
		;;;
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
.er2:
	push eax
	    mov esi,error_m.s9
	    call write2
	pop eax	
	jmp @error		
.er1:
	push eax
	    mov esi,error_m.s8
	    call write2
	pop eax	
	jmp @error	
.er:
	push eax
	    mov esi,error_m.s6
	    mov	dword[esi+16],ebx
	    call write2
	pop eax	
	jmp @error
strcat:
		push	edi
		    mov	edi,esi
		    call strlen
		pop	edi
		mov	eax,edx
		mov	edx,ecx
		shr	ecx,2
		rep	movsd
		mov	ecx,edx
		and	ecx,11b
		rep	movsb
		mov	edx,eax
		;;;
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
		rep	movsb
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
;;esi=*pointer(dd str1, dd str2, dd 0);
write2:
	lodsd
	or	eax,eax
	jz	.ex
	call	write
	push	dword write2
    .ex:
	;;;
	ret
parse_config_file:
	mov	esi,dword[mem_start_file]
	mov	dword[current_line],1
    .lp:
	call	getnextparam
	inc	dword[current_line]
	or	ah,ah
	jz	.lp
	or	al,al
	jnz	@error_line
	;;;
	ret
@error_line:
	mov	eax,dword[current_line]
	mov	edi,main_buffer
	call	d2s
	mov	esi,error_m.s7
	mov	eax,dword[c_file]
	mov	dword[esi+24],eax
	call	write2	
	call	@exit
	ret
getnextparam:
	mov	edi,main_buffer
	sub	edx,edx
	cld
	
	lodsb
	dec esi
	sub al,'#'
	jz .comment
    .lp:
	lodsb
	cmp al,'='
	jz .en_p
	cmp al,' '
	jz .lp
	or al,al
	jz .ex_e
	or dl,1
	stosb
	jmp short .lp
    .en_p:
	or dl,dl
	jz .ex_e
	sub al,al
	stosb
	push	esi
	push	edi
	    mov		edi,main_buffer
	    mov		esi,dword[begin_vars]
	    call	find_entry
	    ;;OUT: eax=*config_of_parameter;
	pop	edi
	pop	esi
	    ;;IN: eax=*config_of_parametres, esi=*begin_of_params;
	    call	parse_function
	    sub	ah,ah
	;;;
	ret
    .ex_e:
	setz ah
    .ex:	
	;;;
	ret
.comment:
	lodsb
	or al,al
	jz .comm_zero
	cmp al,0xA
	jnz .comment
	setnz ah
	;;;
	ret
.comm_zero:
	setz ah
	;;;
	ret
;;IN: eax=*config_of_parametres, esi=*begin_of_params;
parse_function:
	push	esi
	    push	eax
	    mov	esi,eax
	    mov	edi,current
	    cld
	    lodsb
	    stosb	;.mxPC
	    movzx	ebx,al
	    lodsw
	    stosw	;.mxL
	    lodsb
	    stosb	;.mxC
	    add	esi,ebx
	    lodsd
	    stosd	;.fnc
	    lodsd
	    stosd	;.buf
	    lodsb	
	    stosb	;.ftype
	    pop	eax
	pop	esi
	    mov	ecx,dword[current.buf]
	    mov	byte[current.ep],0
	    push	eax	    
		movzx	eax,byte[current.mxC]
		mov	edx,dword[ecx]
		inc	edx
		cmp	edx,eax
		jna	.nx
		    mov	eax,count_match
		    call write
		    call @exit
		.nx:
		movzx	eax,word[current.mxL]
		mul	dword[ecx]
		add	dword[current.buf],eax		
	    pop		eax
	    inc dword[ecx]
	    mov	edi,dword[current.buf]
	    add	edi,5
	    add	eax,4	;params
	    mov	dl,byte[current.mxPC]
	.lpP:
	    movzx	ebx,byte[eax]
		push	eax
		    push edx
		call [funcs+ebx*4]
		    pop edx
		pop	eax
	    inc	eax
	    dec dl
	    jnz	.lpP
	    movzx ebx,byte[current.ftype]
	    call [funcs_deny+ebx*4]
	    call tobr
	;;;
	ret
tobr:
	cmp byte [esi],0x0A
	jnz	.nx
	    inc esi
	    ;;;
	    ret
	.nx:
	    lodsb
	    or al,al
	    jz .eof
	    sub al,0x0A
	    jnz .nx
	.eof
	;;;
	ret
dfunc_normal:
	mov	byte[run_funcs.ex],1
	call	chk_ex_nrm
	jc	.ex
	inc	dword[run_funcs]
	mov	ebx,dword[run_funcs]
	mov	edx,dword[current.fnc]
	mov	[run_funcs+ebx*4],edx
    .ex:
	;;;
	ret
chk_ex_nrm:
	mov	ecx,dword[run_funcs]
	mov	ebx,dword[current.fnc]	
	clc
	jecxz 	.ex
    .lp:
	cmp	ebx,dword[run_funcs+ecx*4]
	jnz	.nx
	stc
	;;;
	ret
    .nx:
	dec	ecx
	jnz	.lp
.ex:	clc
	;;;
	ret
chk_ex_denyS:
	mov	ecx,dword[dfuncs_stable]
	mov	ebx,dword[current.fnc]	
	clc
	jecxz	.ex
    .lp:
	cmp	ebx,dword[dfuncs_stable+ecx*4]
	jnz	.nx
	stc
	;;;
	ret
    .nx:
	dec	ecx
	jnz	.lp
.ex:	clc
	;;;
	ret
chk_ex_denyN:
	mov	ecx,dword[dfuncs_ntable]
	mov	ebx,dword[current.fnc]	
	clc
	jecxz	.ex
    .lp:
	cmp	ebx,dword[dfuncs_ntable+ecx*4]
	jnz	.nx
	stc
	;;;
	ret
    .nx:
	dec	ecx
	jnz	.lp
.ex:	clc
	;;;
	ret
chk_ex_I:
	mov	ecx,dword[rinit_funcs]
	mov	ebx,dword[current.fnc]	
	clc
	jecxz	.ex
    .lp:
	cmp	ebx,dword[rinit_funcs+ecx*4]
	jnz	.nx
	stc
	;;;
	ret
    .nx:
	dec	ecx
	jnz	.lp
.ex:	clc
	;;;
	ret
dfunc_deny:
	mov	byte[dfuncs_stable.ex],1
	call	chk_ex_denyS
	jc	.ex	
	inc	dword[dfuncs_stable]
	mov	ebx,dword[dfuncs_stable]	
	mov	edx,dword[current.fnc]
	mov	[dfuncs_stable+ebx*4],edx
    .ex:
	;;;
	ret
dfunc_null:
	;do nothing
	;;;
	ret
dfunc_deny_by_name:
	mov	byte[dfuncs_ntable.ex],1
	call	chk_ex_denyN
	jc	.ex
	inc	dword[dfuncs_ntable]
	mov	ebx,dword[dfuncs_ntable]	
	mov	edx,dword[current.fnc]
	mov	[dfuncs_ntable+ebx*4],edx
    .ex:
	;;;
	ret
dfunc_init:
	mov	byte[rinit_funcs.ex],1
	call	chk_ex_I
	jc	.ex		
	inc	dword[rinit_funcs]
	mov	ebx,dword[rinit_funcs]	
	mov	edx,dword[current.fnc]
	mov	dword[rinit_funcs+ebx*4],edx
    .ex:
	;;;
	ret
;;INPUT: edx=*addr_of_function;
add_to_timer_f:
	mov	byte[timer_funcs.ex],1
	inc	dword[timer_funcs]
	mov	ebx,dword[timer_funcs]
	mov	[timer_funcs+ebx*4],edx
    .ex:
	;;;
	ret
init_funcs:
	;NORMAL FUNCTIONS
	mov	dword[funcs+TYPE_STRING*4], func_string
	mov	dword[funcs+TYPE_NUM*4], func_num
	mov	dword[funcs+TYPE_IP*4], func_ip
	mov	dword[funcs+TYPE_PATTERN*4], func_pattern
	mov	dword[funcs+TYPE_FILE*4], func_file
	mov	dword[funcs+TYPE_SYMBOL*4], func_symbol
	mov	dword[funcs+TYPE_SYNUM*4], func_synum
	mov	dword[funcs+TYPE_PORT*4], func_port
	mov	dword[funcs+TYPE_RAW*4], func_raw
	mov	dword[funcs+TYPE_TLIMIT*4], func_tlimit
	;DENY FUNCTIONS
	mov	dword[funcs_deny+TFUNC_NORMAL*4],dfunc_normal
	mov	dword[funcs_deny+TFUNC_DENY*4],dfunc_deny
	mov	dword[funcs_deny+TFUNC_DENY_BY_NAME*4],dfunc_deny_by_name
	mov	dword[funcs_deny+TFUNC_NULL*4],dfunc_null	
	mov	dword[funcs_deny+TFUNC_INIT*4],dfunc_init
	;;;
	ret
func_string:
	test	byte[current.ep],1
	jz	.nx
	;;;
	ret
    .nx:
	sub	edx,edx
	call	fill_pstr
	dec	esi
	sub	al,al
	stosb
	mov	ecx,dword[current.buf]
	inc	byte [ecx+4]	;inc parametres count
	;;;
	ret
func_raw:
	test	byte[current.ep],1
	jz	.nx
	;;;
	ret
    .nx:
	sub	edx,edx
	call	fill_pstr_raw
	dec	esi
	sub	al,al
	stosb
	mov	ecx,dword[current.buf]
	inc	byte [ecx+4]	;inc parametres count
	;;;
	ret
func_tlimit:
	test	byte[current.ep],1
	jz	.nx
	;;;
	ret
    .nx:
	sub	edx,edx
	mov	dword[current.tmp],edi
	mov	edi,main_buffer
	call	fill_pstr
	dec	esi
	sub	al,al
	stosb
	mov	ecx,dword[current.buf]
	inc	byte [ecx+4]	;inc parametres count
	mov	edi,dword[current.tmp]
	push	esi
	    mov	esi,main_buffer
	    mov	dword[.count],edi
	    inc	edi
	.lp:
	    lodsb
	    jz .ex
	    mov bl,al
	    sub al,al
	    stosb	;limit not allowed
	    call gtype_num
	    jc .terr
	    stosb
	    lodsb
	    sub al,'#'
	    jnz .serr
	    mov cl,','
	    call strdec64
	    mov eax,dword[strdec64.N + 4]
	    stosd
	    mov eax,dword[strdec64.N]
	    stosd
	    mov eax,dword[.count]
	    inc byte[eax]
	    cmp byte[esi - 1],0
	    jnz .lp	    
	.ex:
	pop	esi
	;;;
	ret
.serr:
	mov eax,.err2
	jmp short .err
.terr:
	mov eax,.err1
    .err:
	call write
	call @exit
.err1:	db	"ERROR: ip_range_traf_limit: packet type is invalid",0xA,0
.err2:	db	"ERROR: ip_range_traf_limit: syntax error",0xA,0
.count	dd	0
strdec64:
		sub	edx,edx
		sub	ebx,ebx
		sub	eax,eax
		cld
		mov	dword[.N],0
		mov	dword[.N + 4],0
		push edi
		 push ecx
		  mov ecx,8
		  mov edi,mul64.X
		  rep stosd
		 pop ecx
		pop edi
	.lp
		lodsb
		cmp	al,cl
		jz	.ex
		or	al,al
		jz	.ex
		and	eax,1111b
		add	dword[mul64.X],eax
		adc	dword[mul64.X + 4],0
		mov	dword[mul64.Y],10
		mov	dword[mul64.Y + 4],0
		;;save old;
		mov	eax,dword[mul64.X]
		mov	ebx,dword[mul64.X + 4]
		mov	dword[.N],eax
		mov	dword[.N + 4],ebx
		;;end save;
		push ecx
		 call mul64
		pop ecx
		mov	eax,dword[mul64.Z]
		mov	ebx,dword[mul64.Z + 4]
		mov	dword[mul64.X],eax
		mov	dword[mul64.X + 4],ebx
		jmp	short .lp
	.ex:
		;;;
		ret
		
.N	dd	0,0
mul64:
    mov	eax,dword[.X]
    mov ebx,eax
    mul dword [.Y]
    mov dword[.Z],eax
    mov ecx,edx
    mov eax,ebx
    mul dword [.Y + 4]
    add eax,ecx
    adc edx,0
    mov ebx,eax
    mov ecx,edx
    mov eax,dword[.X + 4]
    mul dword [.Y]
    add eax,ebx
    mov dword[.Z + 4],eax
    adc ecx,edx
    mov eax,dword[.X + 4]
    mul dword [.Y + 4]
    adc eax,ecx
    adc edx,0
    mov dword[.Z + 8],eax
    mov dword[.Z + 12],edx
    ;;;
    ret
.X:	dd	0,0
.Y:	dd	0,0
.Z:	dd	0,0,0,0
	
;;INPUT: bl=packet_type;
;;OUTPUT: al=num, cf=0 if OK, cf=1 if type is invalid;
gtype_num:
	push esi
	mov esi,pkt_types
	mov ecx,5
    .lp:
	cmp bl,byte[esi + ecx]
	jz .found
	dec ecx
	jns .lp
	pop esi
	stc
	;;;
	ret
    .found:
	mov al,cl
	pop esi
	clc
	;;;
	ret
func_num:
	test	byte[current.ep],1
	jz	.nx
	;;;
	ret
    .nx:
	sub	edx,edx
	mov	dword[current.tmp],edi
	mov	edi,main_buffer
	call	fill_pstr
	dec	esi
	sub	al,al
	stosb
	mov	ecx,dword[current.buf]
	inc	byte [ecx+4]	;inc parametres count
	mov	edi,dword[current.tmp]
	push	esi
	    mov	esi,main_buffer
	    sub cl,cl
	    call strdec
	    mov eax,ebx
	    stosd
	pop	esi
	;;;
	ret
func_port:
	test	byte[current.ep],1
	jz	.nx
	;;;
	ret
    .nx:
	sub	edx,edx
	mov	dword[current.tmp],edi
	mov	edi,main_buffer
	call	fill_pstr
	dec	esi
	sub	al,al
	stosb
	mov	ecx,dword[current.buf]
	inc	byte [ecx+4]	;inc parametres count
	mov	edi,dword[current.tmp]
	push	esi
	    mov	esi,main_buffer
	    sub	ebx,ebx
	.elp:
	    lodsb
	    cmp	al,','
	    jz	.chkp
	    or	al,al
	    jz	.ince
	    jmp	short .elp
	.chkp:
	    lodsb
	    or	al,al
	    jz	.err_en
	    cmp	al,','
	    jz	.err_en
	    inc	ebx
	    mov byte[esi-2],0
	    jmp	short	.elp
	.err_en:
	    mov	eax,err_en_str
	    call write
	    call @exit
	.ince:
	pop	esi
	    inc	ebx
	    mov al,bl
	    stosb
	push	esi
	    mov	esi,main_buffer
	.lp:
	    push ebx
	     call put_port
	    pop ebx
	    dec ebx
	    jnz .lp
	pop	esi	
	;;;
	ret
put_port:
	lodsb
	push dword .nx
	cmp al,'d'
	jnz .chk_s
	mov dl,PTYPE_DST
	;;;
	ret
    .chk_s:
	cmp al,'s'
	jnz .chk_a
	mov dl,PTYPE_SRC
	;;;
	ret
    .chk_a:
	cmp al,'a'
	jnz .er_t
	mov dl,PTYPE_ALL
	;;;
	ret
    .er_t:
	mov eax,err_port
	call write
	call @exit
    .nx:
	push esi
	 call chkIPrange
	pop esi
	dec bl
	js .normal
	or dl,PTYPE_RANGE
	mov al,dl
	stosb
	sub cl,cl
	call strdec
	mov eax,ebx
	stosd
	sub cl,cl
	call strdec
	mov eax,ebx
	stosd
	;;;
	ret
    .normal:
	mov al,dl
	stosb
	sub cl,cl
	call strdec
	mov eax,ebx
	stosd
	;;;
	ret
func_synum:
	test	byte[current.ep],1
	jz	.nx
	;;;
	ret
    .nx:
	sub	edx,edx
	mov	dword[current.tmp],edi
	mov	edi,main_buffer
	call	fill_pstr
	dec	esi
	sub	al,al
	stosb
	mov	ecx,dword[current.buf]
	inc	byte [ecx+4]	;inc parametres count
	mov	edi,dword[current.tmp]
	push	esi
	    mov	esi,main_buffer
	    sub	ebx,ebx
	.elp:
	    lodsb
	    cmp	al,','
	    jz	.chkp
	    or	al,al
	    jz	.ince
	    jmp	short .elp
	.chkp:
	    lodsb
	    or	al,al
	    jz	.err_en
	    cmp	al,','
	    jz	.err_en
	    inc	ebx
	    mov byte[esi-2],0
	    jmp	short	.elp
	.err_en:
	    mov	eax,err_en_str
	    call write
	    call @exit
	.ince:
	pop	esi
	    inc	ebx
	    mov al,bl
	    stosb
	push	esi
	    mov	esi,main_buffer
	.lp:
	    push ebx
	      call put_synum
	    pop ebx
	    dec ebx
	    jnz .lp
	pop	esi
	;;;
	ret
put_synum:
	push esi
	  call chkIPrange
	pop esi
	dec bl
	js .normal
	mov al,PPT_RANGE
	stosb
	sub cl,cl
	call strdec
	mov eax,ebx
	stosd
	sub cl,cl
	call strdec
	mov eax,ebx
	stosd
	;;;
	ret
.normal:
	sub cl,cl
	call strdec
	mov al,PPT_NORMAL
	stosb
	mov eax,ebx
	stosd
	;;;
	ret
func_ip:
	test	byte[current.ep],1
	jz	.nx
	;;;
	ret
    .nx:
	sub	edx,edx
	mov	dword[current.tmp],edi
	mov	edi,main_buffer
	call	fill_pstr
	dec	esi
	sub	al,al
	stosb
	mov	ecx,dword[current.buf]
	inc	byte [ecx+4]	;inc parametres count
	mov	edi,dword[current.tmp]
	push	esi
	    mov	esi,main_buffer
	    sub	ebx,ebx
	.elp:
	    lodsb
	    cmp	al,','
	    jz	.chkp
	    or	al,al
	    jz	.ince
	    jmp	short .elp
	.chkp:
	    lodsb
	    or	al,al
	    jz	.err_en
	    cmp	al,','
	    jz	.err_en
	    inc	ebx
	    mov byte[esi-2],0
	    jmp	short	.elp
	.err_en:
	    mov	eax,err_en_str
	    call write
	    call @exit
	.ince:
	pop	esi
	    inc	ebx
	    mov al,bl
	    stosb
	push	esi
	    mov	esi,main_buffer
	.lpip:
	    push ebx
		call gIPinBuffer
	    pop ebx
	    dec ebx
	    jnz	.lpip
	pop	esi
	;;;
	ret
;;INPUT: esi=*ip_buffer;
gIPinBuffer:
	    push dword .cra
	    sub	bl,bl
	    lodsb
	    cmp	al,'a'
	    jz	.all_type
	    cmp al,'s'
	    jz	.src_type
	    cmp al,'d'
	    jz	.dst_type
	    mov	eax,err_en_str_ip
	    call write
	    call @exit
    .dst_type:
	    or	bl,IPTYPE_DST
	    ;;;
	    ret
    .src_type:
	    or	bl,IPTYPE_SRC
	    ;;;
	    ret
    .all_type:
	    or	bl,IPTYPE_ALL
	    ;;;
	    ret
    .cra:
	    mov	ah,'-'
	    call chkIPr
	    jnc	.nr
	    or	bl,IPTYPE_RANGE
	    mov al,bl
	    stosb
	    call put_r_count
	    mov al,bl
	    stosb
	    mov ecx,4
	.lpr:
	    push ecx
	        call put_pr
	    pop	ecx
	    dec	ecx
	    jnz .lpr
	    ;;;
	    ret
    .mask:
	    or	bl,IPTYPE_MASK
	    mov	al,'/'
	    push edi
	    push esi
		mov edi,esi
		mov ecx,-1
		repnz scasb
		mov byte[edi-1],0
	    pop esi
	    pop edi
	    mov al,bl
	    stosb
	    call sIPtoN
	    stosd
	    call add_mask
	    stosd
	    ;;;
	    ret
    .nr:
	    mov	ah,'/'
	    call chkIPr
	    jc	.mask	        
	    mov al,bl
	    stosb
	    call sIPtoN
	    stosd
	    ;;;
	    ret
;;INPUT: esi=*ip_mask;
;;OUT: eax=mask;
add_mask:
	mov ah,'.'
	call chkIPr
	jnc .bits
	    call sIPtoN
	    ;;;
	    ret
    .bits:
	sub cl,cl
	call strdec
	sub eax,eax
	mov edx,0x80000000
    .lp:
	or eax,edx
	shr edx,1
	dec ebx
	jnz .lp
	;;;
	ret
;;INPUT: esi=*ip_str;
put_pr:
	call	chk_r
	jnc	.nx
	dec	byte[put_r_count.cnt]
	sub	cl,cl
	call	strdec
	mov	al,bl
	stosb
	cmp	byte[put_r_count.cnt],0
	jz	.ex
    .nx:
	mov	cl,'.'
	call	strdec
	mov	al,bl
	stosb
    .ex:
	;;;
	ret
chk_r:
	mov	edx,esi
	clc
    .lp:
	lodsb
	or	al,al
	jz	.sign
	cmp	al,'.'
	jz	.ex
	jmp	short .lp
    .sign:
	stc
	mov	esi,edx
	;;;
	ret
    .ex:
	clc
	mov	esi,edx
	;;;
	ret
;;INPUT: esi=*ip_range;
;;OUTPUT: bl=struct_count;
put_r_count:
	    mov byte[.cnt],1
	    push esi
		sub	bl,bl
		mov	ecx,3
	    .lp:
		lodsb
		or	al,al
		jz	.ex
		cmp	al,'-'
		jz	.sign
		cmp	al,'.'
		jz	.decx
		jmp	short .lp
	    .decx:
		dec	ecx		
		jmp	short .lp
	    .sign:
		mov	byte[esi-1],0
		bts	ebx,ecx
		inc	byte[.cnt]
		jmp	short .lp
	    .ex:
	    pop	esi
	    ;;;
	    ret
.cnt		db	0
;;ah=chk_symbol;
chkIPr:
	mov edx,esi
	clc
    .lp:
	lodsb
	or al,al
	jz .ex
	cmp al,ah
	jz .rn
	jmp short .lp
    .rn:
	mov esi,edx
	stc
	;;;
	ret
    .ex:
	mov esi,edx
	clc
	;;;
	ret
;;INPUT: esi=*str_ip			;
;;OUT: bl=1 if range, otherwise isn`t;
chkIPrange:
	clc
	sub	bl,bl
    .lp:
	lodsb
	cmp	al,'-'
	jz	.ex_r
	or	al,al
	jnz	.lp
	;;;
	ret
    .ex_r:
	stc
	mov	byte[esi-1],0
	mov	ecx,esi
	inc	bl
	;;;
	ret
func_pattern:
	test	byte[current.ep],1
	jz	.nx
	;;;
	ret
    .nx:
	sub	edx,edx
	mov	dword[current.tmp],edi
	mov	edi,main_buffer
	call	fill_pstr
	dec	esi
	sub	al,al
	stosb
	mov	ecx,dword[current.buf]
	inc	byte [ecx+4]	;inc parametres count
	push	edi
	    mov	edi,main_buffer
	    call strlen
	pop	edi
	push	esi
	    mov	esi,main_buffer
	    mov	edi,dword[current.tmp]
	    sub	ebx,ebx
	.elp:
	    lodsb
	    cmp	al,','
	    jz	.chkp
	    or	al,al
	    jz	.ince
	    jmp	short .elp
	.chkp:
	    lodsb
	    or	al,al
	    jz	.err_en
	    cmp	al,','
	    jz	.err_en
	    inc	ebx
	    mov	byte[esi-2],0
	    jmp	short	.elp
	.err_en:
	    mov	eax,err_en_str
	    call write
	    call @exit
	.ince:
	pop	esi
	    inc	ebx
	    xchg eax,ebx
	    stosb
	    push esi
	    mov	esi,main_buffer
	    rep movsb
	    pop esi
	    sub al,al
	    stosb
	;;;
	ret	
func_file:
	test	byte[current.ep],1
	jz	.nx
	;;;
	ret
    .nx:
	sub	edx,edx
	mov	dword[current.tmp],edi
	add	edi,4
	call fill_pstr
	dec	esi
	mov	ecx,dword[current.buf]
	inc	byte[ecx+4]	;inc parametres count
	sub	al,al
	stosb	;zero is the mind as end of file
	mov	eax,5
	mov	ebx,dword[current.tmp]
	add	ebx,4
	mov	ecx,(O_RDWR|O_CREAT|O_APPEND)
	mov	edx,110100100b	;rw-r--r--
	int	0x80
	or	eax,eax
	js	@error_file_o
	mov	dword[ebx-4],eax	;file descriptor(fd)
	;;;
	ret
@error_file_o:
	push eax
	    mov esi,error_m.s10
	    mov dword[esi + 16],ebx
	    call write2
	pop eax
	jmp @error
func_symbol:
	;;;
	ret
w:
		mov	eax,4
		mov	ebx,1
		mov	ecx,t
		mov	edx,2
		int	0x80
		ret
;;INPUT: esi=*ip_str;
;;OUT: eax=ip;
sIPtoN:
		sub	eax,eax
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
		jz	.nxp
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
		jz .nxeos
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
		jz	.ex
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
;;IN: edi=*to_str, esi=*from_str;
;;OUT: ebx=count_of_readed	;
fill_pstr_raw:
	sub	ebx,ebx
	cld
    .lp:
	lodsb
	cmp	al,'('
	jz	.brkO
	cmp	al,')'
	jz	.brkC
	cmp	al,'\'
	jz	.schar
	cmp	al,0x0A
	jz	.eofline
	or	al,al
	jz	.eof
    .dput:
	stosb
	inc	ebx
	jmp	short	.lp	
    .schar:
	lodsb
	cmp	al,0x0A
	jz	.eofline
	or	al,al
	jz	.eof
	jmp	short	.dput
    .brkC:
	or	dl,dl	;error param
	jz	.eofline
	or	ebx,ebx
	jz	.zerop
	.lp2:
	    lodsb
	    or	al,al
	    jz	.cep
	    cmp	al,' '
	    jz	.lp2
	    cmp al,'('
	    jz	.bnep
	    sub	al,0x0A
	    jz	.cep
	jmp short .lp2
    .zerop:
	    mov	eax,zerop_str
	    call write
	    call @exit
    .cep:
	    setz byte [current.ep]
    .bnep:
	    ;;;
	    ret
    .brkO:
	or	dl,dl
	jnz	.eofline
	or	dl,1	;param opened
	jmp	.lp
    .eofline:
	jmp	@error_line
    .eof:
	mov	eax,eof_string
	call	write
	call	@exit		
;;IN: edi=*to_str, esi=*from_str;
;;OUT: ebx=count_of_readed	;
fill_pstr:
	sub	ebx,ebx
	cld
    .lp:
	lodsb
	cmp	al,'('
	jz	.brkO
	cmp	al,')'
	jz	.brkC
	cmp	al,'\'
	jz	.schar
	cmp	al,' '
	jz	.lp
	cmp	al,0x0A
	jz	.eofline
	or	al,al
	jz	.eof
    .dput:
	stosb
	inc	ebx
	jmp	short	.lp	
    .schar:
	lodsb
	cmp	al,0x0A
	jz	.eofline
	or	al,al
	jz	.eof
	jmp	short	.dput
    .brkC:
	or	dl,dl	;error param
	jz	.eofline
	or	ebx,ebx
	jz	.zerop
	.lp2:
	    lodsb
	    or	al,al
	    jz	.cep
	    cmp	al,' '
	    jz	.lp2
	    cmp al,'('
	    jz	.bnep
	    sub	al,0x0A
	    jz	.cep
	jmp short .lp2
    .zerop:
	    mov	eax,zerop_str
	    call write
	    call @exit
    .cep:
	    setz byte [current.ep]
    .bnep:
	    ;;;
	    ret
    .brkO:
	or	dl,dl
	jnz	.eofline
	or	dl,1	;param opened
	jmp	.lp
    .eofline:
	jmp	@error_line
    .eof:
	mov	eax,eof_string
	call	write
	call	@exit
to_zero:	
	push	edi
	 push	ecx
	  mov	edi,esi
	  sub	al,al
	  sub	ecx,ecx
	  dec	ecx
	  cld
	  repnz	scasb
	  mov   esi,edi
	 pop ecx
	pop	edi
;    .lp:
;	lodsb
;	or al,al
;	jnz .lp
	;;;
	ret
find_entry:
    .lp:
	push	edi
	call	strcmp
	pop	edi
	jecxz	.ex
	call	to_zero
	movzx	eax,byte[esi]
	add	esi,13
	add	esi,eax
	cmp	byte [esi],0
	jz	.err_p
	jmp	short .lp
    .ex:
	mov	eax,esi
	;;;
	ret
    .err_p:
	mov	eax,error_up
	call	write
	call	@exit
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
debugP:
	cmp dword[a_openDP], 0
	jnz	.next
	push	ecx
	push	edx
	mov	eax,5
	mov	ebx,process.dfile
	mov	ecx,(O_RDWR|O_CREAT|O_APPEND)
	mov	edx,100100100b
	int	0x80
	or	eax,eax
	js	@error_file_o
	mov	dword[a_openDP],eax
	pop	edx
	pop	ecx
    .next
	mov	ebx,dword[a_openDP]
	mov	eax,4
	int	0x80
	or	eax,eax
	js	@error_write
	;;;
	ret
@error_write:
	push eax
	    mov esi,error_m.s11
	    call write2
	pop eax
	jmp @error
a_openDP	dd	0
;;input:		      	         ;
;;	esi	=	offset	strvalue ;
;;out:	ebx	=	value	         ;
strtodec:
		sub	edx,edx
		sub	eax,eax
		sub	ebx,ebx
		cld
strtodec@go:
		lodsb
		or	al,al
		jz	strtodec@ex
		and	al,1111b
		add	edx,eax
		mov	ebx,edx
		imul	edx,edx,10
		jmp	short strtodec@go
strtodec@ex:
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
%include	"inc_f/ta.ad.asm"
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
	    jnz	.nx
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
	    
%include "inc_f/ta.funcs.asm"

%include "inc_f/md5.f.asm"
%include "inc_f/rc6.f.asm"

error_fne:
		dd	txt1
		dd	txt2
		dd	file_main_conf
		dd	txt3
		dd	txt4
		dd	0
error_vDIR:
		dd	txt1
		dd	txt5
		dd	main_conf.vdir
		dd	txt3
		dd	txt4
		dd	0
error_vDEV:
		dd	txt1
		dd	txt5
		dd	main_conf.vdev
		dd	txt3
		dd	txt4
		dd	0
error_mxP:
		dd	txt1
		dd	txt6
		dd	file_main_conf
		dd	txt7
		dd	txt4
		dd	0
show_conf:
		dd	path_cnf
		dd	txt4
		dd	0
process_cne:
		dd	txt1
		dd	txt2
		dd	path_cnf
		dd	txt3
		dd	txt4
		dd	0
%include	"inc_f/errors.asm"
%include	"inc_f/ta.mdata.asm"
spec_ch		db	"|",0
spec_ch2:	db	":",0
cpids		dd	0
ppid		dd	0
conf_ext:	db	"-conf",0
error_exists:	db	"Error: file doesn`t exists.",0xA,0
begin_vars	dd	0
file_main_confd	db	"/etc/ta.conf",0
error_ips:	db	"Error: ip string is wrong!",0xA,0
t		db	"1",0xA
err_en_str	db	"Error on enum",0xA,0
err_en_str_ip	db	"Error on enum IP",0xA,0
zerop_str:	db	"Error: parameter on line is ZERO",0xA,0
eof_string:	db	"Something wrong: EOF reached!",0xA,0
current_line	dd	1;
count_match	db	"Too many string of function",0xA,0
ok_mess		db	"Ok message",0xA,0
debug_file	db	"outdebug",0
error_up	db	"Unknown parameter", 0xA, 0
error_l		db	"Error on line in file", 0xA, 0
file		db	"eth-conf",0;
dbg		db	"debug-",0
err_port	db	"Error on ports enum",0xA,0
err_path	db	"path of file is too long",0xA,0
socket		dd	0
;mlogf		db	"/var/log/mainlog",0
iface_main	db	"lo",0
eodb		dd	start_table
server		db	0
pfileD		db	"/etc/passwd.db",0
ps_argv:
    .ps1:	db	"--server",0
		db	1		;count of parametres for ps1
		.e1: db	0		;1 if parameter exists
		.s1: dd	0		;offsets to params
    .ps2:	db	"--cfile",0
		db	1
		.e2: db	0
		.s2: dd	0
    .ps3:	db	"--pfile",0
		db	1
		.e3: db	0
		.s3: dd	0			
    .eop:	db	0		;zero must have be present to
					;specify end of arguments list.    
ipD:
    .s:	db	"s:",0
    .d:	db	"d:",0
    .l:	db	"l:",0
    .t:	db	"t:",0
    .proto:	db	"proto:",0
    .sp:	db	"sp:",0
    .dp		db	"dp:",0
    .ttl	db	"ttl:",0
link_types:		
		dw	ARPHRD_ETHER
		dw	ETH_HLEN
		
		dw	ARPHRD_LOOPBACK
		dw	ETH_HLEN
		
		dw	ARPHRD_FDDI
		dw	21		
				
		dd	0
recvP:
		.sock	dd	0
		.buf	dd	0
		.len	dd	MAXIPPACKLEN
		.flags	dd	0
		.sockaddr	dd	packet.sockaddr_ll
		.sock_len	dd	len_sock
len_sock:
		dd	20
sockP:
		.domain:	dd	AF_PACKET
		.type:		dd	SOCK_RAW
		.proto:		dd	0 ;IPPROTO_ICMP; ETH_P_ALL		
sigstruct:
	dd	mainP_sigaction
	dd	0
	dd	(SA_RESTART | SA_NOCLDSTOP)
	dd	0
mmap_buf:
		dd	0
	    .len:
		dd	0
		dd	PROT_READ|PROT_WRITE
		dd	MAP_SHARED
	    .fd:
		dd	0
		dd	0
		
%include	"inc_f/ta.fL.asm"

error_string:
    db	"ERROR:",0
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
szA:
process:
    .dev:	resb	IFMAXNAME
    .len:	resb	1
    .dfile	resb	0x100
current:
    .mxPC:	resb	1
    .mxL:	resw	1
    .mxC:	resb	1
    .fnc:	resd	1
    .buf:	resd	1    
    .ftype:	resb	1
    .ep:	resb	1    
    .tmp	resd	1
    .tmp2	resd	1
    .nfunc	resd	1
mlogf:		resb	MAX_PATH_LEN
spc_char:	resb	10
main_buffer:	resb	0x10000
main_buffer2:	resb	0x10000
skin_buffer:	resb	(0x10000*0x10)
skin_buffer_t:	resb	0x10000
limit_buffer:	resb	0x100
time_buffer:	resb	0x1000
traffic_buffer: resb	(0x10000*0x17)

%include	"inc_f/ta.fb.asm"
time_vid	resd	1
time_values_ss	resd	(TIMES_COUNT)
time_values_mm	resd	(TIMES_COUNT)
time_values_hh	resd	(TIMES_COUNT)
time_values_dd	resd	(TIMES_COUNT)
time_values_mo	resd	(TIMES_COUNT)
time_values_yy	resd	(TIMES_COUNT)
time_values_ww	resd	(TIMES_COUNT)

ftime_values_ss	resb	(TIMES_COUNT)
ftime_values_mm	resb	(TIMES_COUNT)
ftime_values_hh	resb	(TIMES_COUNT)
ftime_values_dd	resb	(TIMES_COUNT)
ftime_values_mo	resb	(TIMES_COUNT)
ftime_values_yy	resb	(TIMES_COUNT)
ftime_values_ww	resb	(TIMES_COUNT)


funcs:	resd	11
funcs_deny:	resd	(COUNT_FUNCS+1)
run_funcs:	
		resd	1		
		resd	((COUNT_FUNCS+1))
		.ex	resb	1
dfuncs_stable:
		resd	1	;count		
		resd	((COUNT_FUNCS+1))		
		.ex	resb	1
dfuncs_ntable:	
		resd	1	;count		
		resd	((COUNT_FUNCS+1))
		.ex	resb	1
rinit_funcs:
		resd	1
		resd	((COUNT_FUNCS+1))
		.ex	resb	1		
timer_funcs:
		resd	1
		resd	((COUNT_FUNCS+1))
		.ex	resb	1
file_size	resd	1;
mem_start_file	resd	1;
file_fd		resd	1;
path_cnf:	resb	MAX_PATH_LEN
packet:
    .dev:	resb	IFMAXNAME
    .len	resd	1
    .flen	resd	1
;    .sa:	resd	1	;source addr
;    .da:	resd	1	;destination addr
    .ipdata:	resd	1	;*pointer to raw ip data
;    .ipproto:	resb	1	;ip protocol
;    .ptype:	resb	1
    .sockaddr_ll:
	.sll_family:	resw	1
	.sll_protocol:	resw	1
	.sll_ifindex:	resd	1
	.sll_hatype:	resw	1
      .ptype: 
	.sll_pkttype:	resb	1
	.sll_halen:	resb	1
	.sll_addr:	resb	8
 .iphdr:
	.ihl		resb	1	;version:4
	.tos		resb	1
	.tot_len	resw	1
	.id		resw	1
	.frag_off	resw	1
	.ttl		resb	1
      .ipproto:
      .proto:
	.protocol	resb	1
	.check		resw	1
	.sa: 
	  .saddr		resd	1
	.da:
	  .daddr		resd	1
iphdL	equ	$-packet.iphdr
ifreq:
	.ifrn_name: resb 16
	.flags:	resw	1
	.port:	resw	1
	.addr:	resd	1
	.unused: resb	8
some_f_call_deny	resd	1
some_f_name_deny	resd	1
name_deny_addr		resd	1
name_esi_tmp		resd	1
penv			resd	1
tm:		resb	tmfmt_size
tm2:		resb	tmfmt_size
file_main_conf	resb	MAXPATHLEN
server_port	resw	1
skin_path	resb	MAXPATHLEN
%include	"inc_f/ta.bdata.asm"
stat_buffer:
	    .s1:	resb	0x1000
	    .s2:	resb	0x1000
	    .s3:	resb	0x1000
	    .s4:	resb	0x1000
	    .s5:	resb	0x1000
packet_buffer:	resb	MAXIPPACKLEN
size_all	equ	$-szA
start_table:
_elf_phdr_flags	equ	7		
_elf_memsz	equ	$ - origin
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	