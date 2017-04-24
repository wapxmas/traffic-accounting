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
%include "inc/others.h"
%include "inc/time.h"

%define TMTYPE_ANY	0
%define TMTYPE_ADIV	1
%define	TMTYPE_SP	2
%define TMTYPE_RN	3
%define TMTYPE_RNDIV	4

%define	 BUFSIZE	0x1000
%define	 MAXNAME	BUFSIZE
%define  NENTRIES	40
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
		cmp	byte[ps_argv.e1],1
		jnz	.usage_p
		cmp	dword[ps_argv.s1],0
		jz	.usage_p
		cmp	byte[ps_argv.e2],1
		jnz	.usage_p
		cmp	dword[ps_argv.s2],0
		jz	.usage_p
		mov	esi,dword[ps_argv.s2]
		cld
		lodsb		
		cmp	al,'t'
		jz	go_outtext
		jmp	short .usage_p
go_outtext:
		mov	esi,dword[ps_argv.s1]
		cld
		lodsw
		or	ah,ah
		jz	.bin
		cmp	ax,'bf'
		jz	.bin
		mov	eax,.invformat
		call	write
		call	@exit
    .bin:
		mov dword[.func],get_bin
		or ah,ah
		jz .nx
		mov dword[.func],get_fbin
    .nx:
		cmp byte[ps_argv.e5],1
		jnz .nx2
		cmp dword[ps_argv.s5],0
		jz .nx2
		mov esi,dword[ps_argv.s5]
		mov edi,time_buf
		call dformat_str
		mov ebx,tzfilename
		call mmap_file
		mov dword[mmap_tz],eax
		mov dword[use.date],1
    .nx2:
		cmp byte[ps_argv.e6],1
		jnz .nx3
		cmp byte[ps_argv.s6],0
		jz .nx3
		mov edi,dword[ps_argv.s6]
		mov esi,host_pack_types
		sub ebp,ebp
	.findT:
		push edi
		    call strcmp
		pop edi
		or ecx,ecx
		jz .ok_find
		call to_zero
		cmp byte[esi],0
		jz .err_type		
		inc ebp
		jmp short .findT
	.err_type:
		mov eax,.invptype
		call write
		call @exit
	.ok_find:
		mov ecx,ebp
		mov byte[var.ptype],cl
		mov dword[use.ptype],1
    .nx3:
		cmp byte[ps_argv.e7],1
		jnz .nx4
		cmp dword[ps_argv.s7],0
		jz .nx4
		mov esi,dword[ps_argv.s7]
		xor cl,cl
		call strdec
		mov byte[var.proto],bl
		mov dword[use.proto],1		
    .nx4:
		cmp byte[ps_argv.e8],1
		jnz .nx5
		cmp dword[ps_argv.s8],0
		jz .nx5
		mov esi,dword[ps_argv.s8]
		xor cl,cl
		call strdec
		mov dword[use.sport],1
		mov word[var.sport],bx
    .nx5:
		cmp byte[ps_argv.e9],1
		jnz .nx6
		cmp dword[ps_argv.s9],0
		jz .nx6
		mov esi,dword[ps_argv.s9]
		xor cl,cl
		call strdec
		mov dword[use.dport],1
		mov word[var.dport],bx
    .nx6:    		    
		cmp byte[ps_argv.e4],1
		jnz near .say_input
		cmp dword[ps_argv.s4],0
		jz  near .say_input
		mov ebx,dword[ps_argv.s4]
		call mmap_file
		mov dword[.memi],eax
		cmp byte[ps_argv.e3],1
		jnz .stdout
		cmp dword[ps_argv.s3],0
		jz .stdout
		mov eax,5
		mov ebx,dword[ps_argv.s3]
		mov ecx,(O_RDWR|O_CREAT|O_APPEND)
		mov edx,100100100b
		int 0x80
		or eax,eax
		js near @error
		mov dword[.fdo],eax
		jmp short .go_read
    .stdout:
		mov dword[.fdo],1
    .go_read:
		mov eax,dword[.memi]
		mov dword[.memov],eax
		mov eax,dword[mmap_buf.len]
		add dword[.memov],eax
		mov esi,dword[.memi]
		mov edi,buffer
    .lp:		
		call dword[.func]
		dec edi
		dec byte[.writes]
		jnz .nextaw
		mov edi,buffer
		call strlen
		xchg ecx,edx		
		mov byte[.writes],NENTRIES
		mov edi,buffer
		mov eax,4
		mov ebx,dword[.fdo]
		mov ecx,buffer
		int 0x80
    .nextaw:
		cmp esi,dword[.memov]
		jnz .lp
		cmp byte[.writes],NENTRIES
		jz .ex
		mov edi,buffer
		call strlen
		xchg ecx,edx		
		mov edi,buffer
		mov eax,4
		mov ebx,dword[.fdo]
		mov ecx,buffer
		int 0x80	
    .ex:	
		call @exit
.say_input:
		mov	eax,.need_input
		call	write
		call	@exit
.need_input	db	"You must to specify the input file",0xA,0
.invformat	db	"Invalid format",0xA,0
.invptype	db	"Invalid packet type",0xA,0
.tst		db	"test",0xA,0
.func		dd	0
.fdi		dd	0
.fdo		dd	0
.memi		dd	0
.memov		dd	0
.writes		db	NENTRIES
spec_ch		db	"|"
ipD:
    .s:	db	"s:",0
    .d:	db	"d:",0
    .l:	db	"l:",0
    .t:	db	"t:",0
    .proto:	db	"proto:",0
    .sp:	db	"sp:",0
    .dp		db	"dp:",0
    .ttl	db	"ttl:",0
use:
    .date	dd	0
    .ptype	dd	0
    .proto	dd	0
    .sport	dd	0
    .dport	dd	0
    
var:
    .ptype	db	0
    .proto	db	0
    .sport	dw	0
    .dport	dw	0
    
mmap_tz		dd	0
tzfilename:	db	'/etc/localtime',0

;;INPUT edi=tmfmt, eax=addr_tz;
date:
;all that code described nearly, about data function,;
;i was get from asmutils, and thaks to Brian Raiter;
		mov	ebx, [byte eax + 32]
		bswap	ebx
		mov	esi, [byte eax + 36]
		bswap	esi
		lea	esi, [esi*2 + esi]
		mov	ecx, ebx
		add	eax, byte 44
.tmchgloop:	dec	ecx
		jz	.tmchgloopexit
		mov	edx, [eax + ecx*4]
		bswap	edx
		cmp	edx, [edi]
		jg	.tmchgloop
.tmchgloopexit:

		lea	eax, [eax + ebx*4]
		movzx	ecx, byte [eax + ecx]
		add	eax, ebx
		lea	ecx, [ecx*2 + ecx]
		mov	edx, [eax + ecx*2]
		bswap	edx
		mov	[byte edi + tmfmt.zo], edx
		movzx	ecx, byte [byte eax + ecx*2 + 5]
		lea	eax, [eax + esi*2]
		fild	qword [eax + ecx]
		fistp	qword [byte edi + tmfmt.tz]
		
skipzoning:
		mov	al, '+'
		or	edx, edx
		jns	.eastward
		mov	al, '-'
		neg	edx
.eastward:	mov	[byte edi + tmfmt.zi], al
		xchg	eax, edx
		cdq
		lea	ebx, [byte edx + 60]
		div	ebx
		cdq
		div	ebx
		aam
		xchg	eax, edx
		aam
		shl	edx, 16
		lea	eax, [edx + eax + '0000']
		bswap	eax
		mov	[byte edi + tmfmt.zi + 1], eax
		
		mov	ecx, 1969
		push	byte 4
		pop	esi
		mov	eax, [edi]
		add	eax, [byte edi + tmfmt.zo]
		jge	.positivetime
		add	eax, 365 * 24 * 60 * 60
		dec	ecx
		dec	esi
.positivetime:	push	esi

;; eax holds the number of seconds since the Epoch. This is divided by
;; 60 to get the current number of seconds, by 60 again to get the
;; current number of minutes, and then by 24 to get the current number
;; of hours.

		cdq
		lea	ebx, [byte edx + 60]
		div	ebx
		mov	[byte edi + tmfmt.sc], edx
		cdq
		div	ebx
		mov	[byte edi + tmfmt.mn], edx
		mov	bl, 24
		cdq
		div	ebx
		mov	[byte edi + tmfmt.hr], edx		
		
		sub	edx, byte 12
		setae	byte [byte edi + tmfmt.mr]
		ja	.morning
.midnight:	add	edx, byte 12
		jz	.midnight
.morning:	mov	[byte edi + tmfmt.hm], edx

;; eax now holds the number of days since the Epoch. This is divided
;; by seven, after offsetting by the value in esi, to determine the
;; current day of the week.

		push	eax
		add	eax, esi
		mov	bl, 7
		cdq
		div	ebx
		mov	[byte edi + tmfmt.wd], edx
		sub	eax, eax
		cmpxchg	edx, ebx
		mov	[byte edi + tmfmt.w1], edx
		mov	eax, [esp]

;; A year's worth of days are successively subtracted from eax until
;; the current year is determined. The program takes advantage of the
;; fact that every 4th year is a leap year within the range of our
;; Epoch.

		mov	bh, 1
.yrloop:	mov	bl, 110
		inc	ecx
		test	cl, 3
		jz	.leap
		dec	ebx
.leap:		sub	eax, ebx
		jge	.yrloop
		add	eax, ebx
		mov	[byte edi + tmfmt.yr], ecx

		mov	ch, 20
		sub	cl, 208
		jnc	.twentieth
		dec	ch
		add	cl, 100
.twentieth:	mov	[byte edi + tmfmt.cy], cl
		mov	[byte edi + tmfmt.ce], ch
		
		

		mov	esi, eax
		add	ebx, 11000000001110111011111011101100b - 365
		sub	ecx, ecx
		cdq
.moloop:	mov	dl, 7
		shld	edx, ebx, 2
		ror	ebx, 2
		inc	ecx
		sub	eax, edx
		jge	.moloop
		add	eax, edx
		inc	eax
		add	edi, byte tmfmt.dy
		stosd
		xchg	eax, ecx
		stosd

;; The program retrieves from the stack the day of the year, the
;; number of days since the Epoch, and the day of the week at the
;; start of the Epoch, respectively. These are used to calculate the
;; day of the week of January 1st of the current year.

		pop	eax
		pop	ebx
		sub	eax, esi
		add	eax, ebx
		mov	bl, 7
		cdq
		div	ebx
		mov	ecx, edx

;; Using this, the program now determines the current week of the year
;; according to three different measurements. The first uses Sunday as
;; the start of the week, and a partial week at the beginning of the
;; year is considered to be week zero. The second is the same, except
;; that it uses Monday as the start of the week.

		sub	eax, eax
		cmpxchg	ecx, ebx
		lea	eax, [esi + ecx]
		cdq
		div	ebx
		stosd
		dec	ecx
		jnz	.mondaynot1st
		mov	cl, bl
.mondaynot1st:	lea	eax, [esi + ecx]
		cdq
		div	ebx
		stosd

;; Finally, the ISO-8601 week number uses Monday as the start of the
;; week, and requires every week counted to be the full seven days. A
;; partial week at the end of the year of less than four days is
;; counted as week 1 of the following year; likewise, a partial week
;; at the start of the year of less than four days is counted as week
;; 52 or 53 of the previous year. In order to cover all possibilities,
;; the program must examine the current day of the week, and whether
;; the current year and/or the previous year was a leap year. Outside
;; of these special cases, the ISO-8601 week number will either be
;; equal to or one more than the value previously calculated.

		mov	ebx, [byte edi + tmfmt.yr - tmfmt.wi]
		mov	dl, 3
		and	dl, bl
		sub	ecx, byte 4
		adc	al, 0
		jnz	.fullweek
		dec	ebx
		mov	al, 52
		or	ecx, ecx
		jz	.add1stweek
		dec	ecx
		jnz	.wifound
		dec	edx
		jnz	.wifound
.add1stweek:	inc	eax
.fullweek:	cmp	al, 53
		jnz	.wifound
		cmp	dl, 1
		mov	edx, esi
		sbb	dl, 104
		cmp	dl, [byte edi + tmfmt.wd - tmfmt.wi]
		jle	.wifound
		mov	al, 1
		inc	ebx
.wifound:	stosd
		xchg	eax, ebx
		stosd
		inc	esi
		xchg	eax, esi
		stosd
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
;;esi=*stable_Atime, edi=*tm;
QallowTIME:
	mov	ebx,table_time
    .lp:
	cmp	dword[ebx],0
	jz	.ex
	    push ebx
	     call dword[ebx]
	    pop ebx
	    add ebx,4
	jmp short .lp	
    .ex:
	;;;
	ret
allow_value	dd	0	;1 if allowed, otherwise is not	    
;;INPUT: esi=*str4format, edi=*buffer;
dformat_str:
	push esi
	  call strip_brk
	pop esi
	mov ecx,7
    .lp:
	 push ecx
	    call do_format
	 pop ecx
	dec ecx
	jnz .lp
	;;;
	ret
do_time_check:
	lodsb
	movzx ecx,al
	mov byte[.state],0
    .lp:
	lodsb
	movzx ebx,al
	  push ecx
	    call dword[ebx*4+Ttable_funcs]
	    jc .nx
		mov byte[.state],1
	.nx:
	  pop ecx
	dec ecx
	jnz .lp
		
	cmp byte[.state],1
	jne .dstc
	clc
	;;;
	ret
.dstc:
	stc
	;;;
	ret
.arg	dd	0
.hr	db	0
.state	db	0
do_time_check_h:
	;;;
	ret
time_any:
    clc
    ;;;
    ret
time_adiv:
    lodsd
    mov ebx,eax
    mov eax,dword[do_time_check.arg]
    sub edx,edx
    div ebx
    or edx,edx
    jz .dclc
    stc
    ;;;
    ret
.dclc:
    clc
    ;;;
    ret
time_sp:
    lodsd
    cmp eax,dword[do_time_check.arg]
    jne .dstc
    clc
    ;;;
    ret
.dstc:
    stc
    ;;;
    ret
time_rn:

    lodsd
    mov ebx,eax
    lodsd
    mov ecx,dword[do_time_check.arg]
    cmp ebx,eax
    ja .rnd
.ccm:
    cmp ecx,ebx
    jae .nx
    stc
    ;;;
    ret
.nx:
    cmp ecx,eax
    jbe .nx1
    stc
    ;;;
    ret
.nx1:
    clc
    ;;;
    ret
.rnd:
    mov edx,60
    cmp byte[do_time_check.hr],0
    jne .rnd_nx
    mov edx,24
.rnd_nx:
    sub edx,ebx
    mov ebx,edx
    add ecx,edx
    add eax,edx
    jmp short .ccm
    ;;;
    ret
time_rndiv:
    lodsd
    mov ebx,eax
    lodsd
    push eax
     lodsd
     mov dword[.arg], eax
    pop eax
    mov ecx,dword[do_time_check.arg]
    cmp ebx,eax
    ja .rndivd
.ccm:
    cmp ecx,ebx
    jae .nx
    stc
    ;;;
    ret
.nx:
    cmp ecx,eax
    jbe .nx1
    stc
    ;;;
    ret
.nx1:
    mov ebx,dword[.arg]
    mov eax,dword[do_time_check.arg]
    sub edx,edx
    div ebx
    or edx,edx
    jz .nx2
    stc
    ;;;
    ret
.nx2:
    clc
    ;;;
    ret
.rndivd:
    mov edx,60
    cmp byte[do_time_check.hr],1
    jne .rnd_nx
    mov edx,24
.rnd_nx:
    sub edx,ebx
    mov ebx,edx
    add ecx,edx
    add eax,edx
    jmp short .ccm
    ;;;
    ret
.arg	dd	0
Ttable_funcs:
	    dd time_any
	    dd time_adiv
	    dd time_sp
	    dd time_rn
	    dd time_rndiv
time_SS:
	cmp dword[allow_value],0
	jz .nx
	mov eax,[edi + tmfmt.sc]
	mov dword[do_time_check.arg], eax
	call do_time_check
	jnc	.nx	
	mov dword[allow_value],0
    .nx:
	;;;
	ret
time_MM:
	cmp dword[allow_value],0
	jz .nx
	mov eax,[edi + tmfmt.mn]
	mov dword[do_time_check.arg], eax	
	call do_time_check
	jnc	.nx
	mov dword[allow_value],0
    .nx:
	;;;
	ret
time_HH:
	mov byte[do_time_check.hr],1
	cmp dword[allow_value],0
	jz .nx	
	mov eax,[edi + tmfmt.hr]
	mov dword[do_time_check.arg], eax	
	call do_time_check
	jnc	.nx
	mov dword[allow_value],0
    .nx:
	mov byte[do_time_check.hr],0
	;;;
	ret
time_DD:
	cmp dword[allow_value],0
	jz .nx
	mov eax,[edi + tmfmt.dy]
	mov dword[do_time_check.arg], eax	
	call do_time_check
	jnc	.nx
	mov dword[allow_value],0
    .nx:
	;;;
	ret
time_MO:
	cmp dword[allow_value],0
	jz .nx
	mov eax,[edi + tmfmt.mo]
	mov dword[do_time_check.arg], eax	
	call do_time_check
	jnc	.nx
	mov dword[allow_value],0
    .nx:
	;;;
	ret
time_YY:
	cmp dword[allow_value],0
	jz .nx
	mov eax,[edi + tmfmt.yr]
	mov dword[do_time_check.arg], eax	
	call do_time_check
	jnc	.nx
	mov dword[allow_value],0
    .nx:
	;;;
	ret
time_WW:
	cmp dword[allow_value],0
	jz .nx
	mov eax,[edi + tmfmt.w1]
	mov dword[do_time_check.arg], eax	
	call do_time_check
	jnc	.nx
	mov dword[allow_value],0
    .nx:
	;;;
	ret
table_time:
	    dd	time_SS
	    dd	time_MM
	    dd	time_HH
	    dd	time_DD
	    dd	time_MO
	    dd	time_YY
	    dd	time_WW
	    dd	0	
;*/23, *, 12, 1-56, 
do_format:
	push esi
	 call get_cnt
	pop esi
	mov al,cl
	stosb
    .lp:
	lodsb
	    push ecx
	    call tparse_input
	    pop ecx
	dec ecx
	jnz .lp
	;;;
	ret
chk_range:
	mov edx,esi
    .lp:
	lodsb
	cmp al,'-'
	je .range
	or al,al
	jnz .lp
	mov esi,edx
	clc
	;;;
	ret
    .range:
	mov byte[esi-1],0
	mov esi,edx
	stc
	;;;
	ret
chk_drange:
	mov edx,esi
	call to_zero
    .lp:
	lodsb
	cmp al,'/'
	je .range
	or al,al
	jnz .lp
	mov esi,edx
	clc
	;;;
	ret
    .range:
	mov byte[esi-1],0
	mov esi,edx
	stc
	;;;
	ret
tparse_input:
	cmp al,'*'
	je .star
	dec esi
	call chk_range
	jc .range
	mov al,TMTYPE_SP
	stosb
	sub cl,cl
	call strdec
	mov eax,ebx
	stosd
	;;;
	ret
.range:
	call chk_drange
	jc .drange
	mov al,TMTYPE_RN
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
.drange:
	mov al,TMTYPE_RNDIV
	stosb
	sub cl,cl
	call strdec
	mov eax,ebx
	stosd
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
.star:
	lodsb
	cmp al,'/'
	je .stardiv
	mov al,TMTYPE_ANY
	stosb
	;;;
	ret
.stardiv:
	mov al,TMTYPE_ADIV
	stosb
	sub cl,cl
	call strdec
	mov eax,ebx
	stosd
	;;;
	ret
;;OUTPUT: ecx=count;
get_cnt:
	mov ecx,1
    .lp:
	lodsb
	cmp al,','
	je .dinc
	or al,al
	jnz .lp
	;;;
	ret
.dinc:
	mov byte[esi-1],0
	inc ecx
	jmp short .lp
strip_brk:
    .lp:
	lodsb
	cmp al,'|'
	je .strip
	or al,al
	jnz .lp
	;;;
	ret
 .strip:
	mov byte[esi-1],0
	jmp short .lp    
get_fbin:
	    mov dword[.deny],0
	    mov dword[.old_edi],edi
	    call strcat
	    inc esi
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"s:"
	     stosw
	    lodsd
	    mov ebx,eax	    
	    bswap ebx
	    call ipn2s
	    dec	edi
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"d:"
	     stosw
	    lodsd
	    mov ebx,eax
	    bswap ebx
	    call ipn2s
	    dec edi
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"l:"
	     stosw
	    lodsd
	    call d2s
	    dec edi
	    mov	al,byte[spec_ch]
	    stosb
	     mov ax,"t:"
	     stosw
	    lodsb
	    cmp byte[use.ptype],1
	    jnz .nx_ptype
	    cmp byte[var.ptype],al
	    jz .nx_ptype
	    mov dword[.deny],1
    .nx_ptype:
	    push esi
	    call ptype
	    pop esi
	    mov al,byte[spec_ch]
	    stosb
	     mov eax,"ttl:"
	     stosd
	    sub eax,eax
	    lodsb
	    call d2s
	    dec edi
	    mov al,byte[spec_ch]
	    stosb
	     mov eax,"prot"
	     stosd
	     mov ax,"o:"
	     stosw
	    sub eax,eax
	    lodsb
	    cmp dword[use.proto],1
	    jnz .nx_proto
	    cmp byte[var.proto],al
	    jz .nx_proto
	    mov dword[.deny],1
	.nx_proto:
	    call d2s
	    dec edi
	    lodsb
	    or al,al
	    jz	.nx
	    mov al,[spec_ch]
	    stosb
	     mov ax,"sp"
	     stosw
	     mov al,":"
	     stosb
	    sub eax,eax
	    lodsw
	    cmp dword[use.sport],1
	    jnz .nx_sport
	    cmp word[var.sport],ax
	    jz .nx_sport
	    mov dword[.deny],1
    .nx_sport:	    
	    call d2s
	    dec edi
	    mov al,[spec_ch]
	    stosb
	     mov ax,"dp"
	     stosw
	     mov al,":"
	     stosb
	    sub eax,eax
	    lodsw	    
	    cmp dword[use.dport],1
	    jnz .nx_dport
	    cmp word[var.dport],ax
	    jz .nx_dport
	    mov dword[.deny],1
    .nx_dport:	    	    
	    call d2s
	    dec edi
	.nx:
	    lodsb
	    or al,al
	    jz .nxti
	    cmp dword[use.date],1
	    jnz .nx_wd
	    push esi
	     push edi	    
	      mov	dword[allow_value],1	;allowed, default
	      lodsd
	      mov dword[tm],eax
	      mov eax,dword[mmap_tz]
	      mov edi,tm
	      call date
	      mov edi,tm
	      mov esi,time_buf
	      call QallowTIME
	     pop edi
	    pop esi
	    cmp dword[allow_value],1
	    jz .nx_wd
	    add esi,4
	    mov edi,dword[.old_edi]
	    sub al,al
	    stosb
	    ;;;
	    ret
       .nx_wd:
	    mov al,byte[spec_ch]
	    stosb
	    lodsd
	    call d2s
	    dec	edi
	.nxti:
	    mov al,0xA
	    stosb
	    sub	al,al
	    stosb
	    cmp dword[.deny],1
	    jz .do_deny
		;;;
		ret
    .do_deny:
	    mov edi,dword[.old_edi]
	    sub al,al
	    stosb
	    ;;;
	    ret
.old_edi	dd	0
.deny		dd	0		
get_bin:
	    mov dword[.old_edi],edi	    
	    call strcat
	    inc esi
	    mov	al,byte[spec_ch]
	    stosb
	    push esi
	    mov	esi,ipD.s
	    call strcat
	    pop esi
	    lodsd
	    mov ebx,eax	    
	    bswap ebx
	    call ipn2s
	    dec	edi
	    mov	al,byte[spec_ch]
	    stosb
	    push esi
	    mov	esi,ipD.d
	    call strcat
	    pop esi
	    lodsd
	    mov ebx,eax
	    bswap ebx
	    call ipn2s
	    dec edi
	    mov	al,byte[spec_ch]
	    stosb
	    push esi
	    mov	esi,ipD.l
	    call strcat
	    pop esi
	    lodsd
	    call d2s
	    dec edi
	    mov	al,byte[spec_ch]
	    stosb
	    push esi 
	    mov	esi,ipD.t
	    call strcat
	    pop esi
	    lodsb
	    cmp byte[use.ptype],1
	    jnz .nx_ptype
	    cmp byte[var.ptype],al
	    jz .nx_ptype
	    mov dword[.deny],1
    .nx_ptype:	    
	    push esi
	    call ptype
	    pop esi
	    lodsb
	    or al,al
	    jz .nxti
	    cmp dword[use.date],1
	    jnz .nx_wd
	    push esi
	     push edi	    
	      mov dword[allow_value],1	;allowed, default
	      lodsd
	      mov dword[tm],eax
	      mov eax,dword[mmap_tz]
	      mov edi,tm
	      call date
	      mov edi,tm
	      mov esi,time_buf
	      call QallowTIME
	     pop edi
	    pop esi
	    cmp dword[allow_value],1
	    jz .nx_wd
	    add esi,4
	    mov edi,dword[.old_edi]
	    sub al,al
	    stosb
	    ;;;
	    ret
       .nx_wd:	    
	    mov al,byte[spec_ch]
	    stosb
	    lodsd
	    call d2s
	    dec	edi
	.nxti:
	    mov al,0xA
	    stosb
	    sub	al,al
	    stosb
	    cmp dword[.deny],1
	    jz .do_deny
		;;;
		ret
    .do_deny:
	    mov edi,dword[.old_edi]
	    sub al,al
	    stosb
	    ;;;
	    ret
.old_edi	dd	0
.deny		dd	0		
ipn2s:
	mov	ecx,4
    .lp:
	sub	eax,eax
	push	ecx
	mov	cl,8
	shld	eax,ebx,cl
	shl	ebx,cl
	    push ebx
		call	d2s
	    pop	ebx
	pop	ecx
	cmp	ecx,1
	jne	.next
	    ;;;
	    ret
    .next:
	dec	edi
	mov	al,'.'
	stosb	
	dec	ecx
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
ptype:
	mov	ah,al
	mov	esi,host_pack_types
	or	ah,ah
	jz	.pt
    .lp:
	lodsb
	or	al,al
	jnz	.lp
	lodsb
	or	al,al
	jz	.pt
	dec	esi
	dec	ah
	jnz	.lp
    .pt:
	push	edi
	mov	edi,esi
	call	strlen
	pop	edi
	rep	movsb
	;;;
	ret
host_pack_types:
	    db	"input",0
	    db	"broadcast",0
	    db	"multicast",0
	    db	"forward",0
	    db	"output",0
	    db	0
	    db	"unknown",0		
@exit:
		sub	eax,eax
		inc	eax
		sub	ebx,ebx
		int	0x80
usage:		db	"Usage: tmlog -f <[b][bf]> -p <[t]> -i <input_file>",0xA
		db	"-f: ",0xA
		db	"	 b: binary",0xA
		db	"	bf: binary full",0xA
		db	"-p: ",0xA
		db	"	t: convert from binary to text",0xA
		db	"-o: ",0xA
		db	"	output file, if empty than stdout be use",0xA
		db	"-i: ",0xA
		db	"	input file",0xA
		db	"--date: ",0xA
		db	"	date string, like: 0|*|23-7/1,9|*|*|*|1,3 ",0xA
		db	"	this date string format alike stat_time_on function.",0xA
		db	"--ptype: ",0xA
		db	"	restrict output by packet type, types can be:",0xA
		db	"		input,output,forward",0xA
		db	"		broadcast, multicast",0xA
		db	"	if ptype is equal to input than out to will be",0xA
		db	"	have only packet wich input type.",0xA
		db	"--proto: ",0xA
		db	"	restrict output by protocol type.",0xA
		db	"--sport: ",0xA
		db	"	restrict output by source port",0xA		
		db	"--dport: ",0xA
		db	"	restrict output by destination port",0xA						
		db	0
ps_argv:
    .ps1:	db	"-f",0
		db	1
		.e1: db	0
		.s1: dd	0
    .ps2:	db	"-p",0
		db	1
		.e2: db	0
		.s2: dd	0
    .ps3:
		db	"-o",0
		db	1
		.e3: db	0
		.s3: dd	0
    .ps4:
		db	"-i",0
		db	1
		.e4: db	0
		.s4: dd	0
    .ps5:
		db	"--date",0
		db	1
		.e5	db	0
		.s5	dd	0
    .ps6:
		db	"--ptype",0
		db	1
		.e6	db	0
		.s6	dd	0		
    .ps7:
		db	"--proto",0
		db	1
		.e7	db	0
		.s7	dd	0
    .ps8:
		db	"--sport",0
		db	1
		.e8	db	0
		.s8	dd	0
    .ps9:
		db	"--dport",0
		db	1
		.e9	db	0
		.s9	dd	0		
    .eop:	db	0
mmap_buf:
		dd	0
	    .len:
		dd	0
		dd	PROT_READ|PROT_WRITE
		dd	MAP_SHARED
	    .fd:
		dd	0
		dd	0	    
error_string:
		db	"ERROR: ",0
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
		jne	.ex
		inc	ecx
		repe	cmpsb
		or	ecx,ecx
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
		sub	eax,eax
		lodsb
		lea	esi,[esi + eax*4 + 1]
		lodsb
		dec esi
		or al,al
		jnz .lp
		sub ecx,ecx
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
	sub	ebx,ebx
	sub	edx,edx
 .lp:
	lodsb
	or	al,al
	jz	.ex
	call	to_zero
	inc	ebx
	inc	edx
	sub	eax,eax
	lodsb
	add	ebx,eax
	lea	esi,[esi + eax*4 + 1]
	jmp	short .lp
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
	sub	ecx,ecx
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
@error:
		neg	eax
		push	eax
		    mov	eax,error_string
		    call write
		pop	eax
		mov	esi,errno
		call	show_errno
		call	@exit		
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
.e: db " Too many references: cannot splice ",0
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
db	"Unknown error",0
    align	16
_elf_filesz	equ	$ - $$
[absolute 0x08048000 + _elf_filesz]
_data:
    buffer:	resb	BUFSIZE*4
    time_buf:	resb	0x100
    tm: resb tmfmt_size
_elf_phdr_flags	equ	7		
_elf_memsz	equ	$ - origin
