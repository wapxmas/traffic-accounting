;;stat_time_on();
	sub	ecx,ecx
    .lp:
	mov	esi,stat_time_on_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_STAT_TIME_ON
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_stat_time_on
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
file_estart	dd	0
do_stat_time_on:
	lodsb
	cmp	al,MAXPC_STAT_TIME_ON
	je	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .next:
	mov	edi,dword[name_deny_addr]
	call	strcmp
	or	ecx,ecx
	jz	.next1
	;;;
	ret
    .next1:
		mov	esi,start_table
	.lpf:
		mov	dl,DB_ID_STO
		call	find_in_db
		jc	.lpe
		add	esi,dword[esi]
		call	NSkipEnum
		mov	edi,dword[name_deny_addr]
		call	strcmp
		jecxz	.founded
		mov	esi,ebx
		jmp short .lpf
	.founded:
		mov	ebx,dword[file_estart]
		mov	eax,dword[esi]
		mov	dword[ebx],eax
	.lpe:	
	;;;
	ret
.first	db	0
sto_add_to_table:
	lodsb
	mov	edi,main_buffer
	push	esi
	    call to_zero
	    call NSkipFile
	    push esi
	     call to_zero
	     mov dword[.off],esi
	    pop esi
	    push edi
	    add edi,4
	    call dformat_str
	    pop ebx
	    mov edx,edi
	    sub edx,ebx
	    mov dword[ebx],edx
	    mov dword[.ln],edx
	    
	    mov esi,dword[.off]
	    push esi
	    call NSkipEnum
	    pop ebx
	    mov edx,esi
	    sub edx,ebx
	    add dword[.ln],edx
	    mov esi,ebx
	    mov ecx,edx
	    rep movsb
	pop	esi
	push	edi
	    mov	edi,esi
	    call	strlen
	pop	edi
	push	ecx
	inc	ecx
	rep	movsb
	mov	dword[.fd],edi
	lodsd
	stosd
	mov	eax,10
	mov	ebx,esi
	int	0x80	;unlink
	push	edi
	    mov	edi,esi
	    call	strlen
	pop	edi
	mov	eax,ecx
	inc	ecx
	rep	movsb
	pop	ecx
	lea	ecx,[ecx + eax + 6]
	add	ecx,dword[.ln]
	push	ecx
	    mov	esi,ebx
	    mov	edi,stat_buffer.s5
	    mov	eax,dword[.off]
	    mov dword[new_date_name.saddr],eax
	    call new_date_name
	    mov	eax,5
	    mov	ebx,stat_buffer.s5
	    mov	ecx,(O_RDWR|O_CREAT|O_APPEND)
	    mov	edx,110100100b	;rw-r--r--
	    int	0x80
	    or	eax,eax
	    js	@error_file_o
	    mov	ebx,dword[.fd]
	    mov	dword[ebx],eax
	pop	ecx
	mov	esi,main_buffer
	mov	dl,DB_ID_STO
	call	add_to_db	
	;;;
	ret
.fd	dd	0
.ln	dd	0
.off	dd	0
timer_sto:
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
		mov	esi,start_table
	.lpf:
		mov	dl,DB_ID_STO
		call	find_in_db
		jc	near .lpe
		    push	ebx
			mov	dword[allow_value],1	;allowed, default
			push	esi
			lodsd
			mov	dword[.ln],eax
			mov	edi,tm
			mov	dword[time_vid],TIME_ID_3
			call	QallowTIME
			pop	edx
			test	dword[allow_value],1
			jz	.nx
			    mov	esi,edx
			    add	esi,dword[.ln]
			    mov dword[new_date_name.saddr],esi
			    call NSkipEnum
			    call to_zero
			    mov	dword[.fd],esi
			    lodsd
			    push esi
			     push ebx
			      call add_traffic.flush
			     pop ebx
			    pop esi
			    mov ebx,eax
			    mov	eax,6
			    int	0x80 ;close fd
			    mov	edi,main_buffer
			    call new_date_name
			    mov	eax,5
			    mov	ebx,main_buffer
			    mov	ecx,(O_RDWR|O_CREAT|O_APPEND)
			    mov	edx,110100100b	;rw-r--r--
			    int	0x80
			    or	eax,eax
			    js	@error_file_o
			    mov	ebx,dword[.fd]
			    mov	dword[ebx],eax			    
		    .nx:			
		    pop		ebx
		mov	esi,ebx
		jmp .lpf
	.lpe:	
	;;;
	ret
.fd	dd	0
.ln	dd	0
mmap_addr	dd	0
mmap_file_date:
	mov	eax,5
	mov	ecx,O_RDWR
	int	0x80
	or	eax,eax
	jns	.nx
	jmp	@error_file_o
    .nx:
	mov	ebx,eax
	mov	eax,19
	sub	ecx,ecx
	mov	edx,SEEK_END
	int	0x80
	or	eax,eax
	jns	.nx1
	jmp	mmap_file.er1
    .nx1:	
	mov	dword [mmap_buf.len], eax
	mov	ecx,eax
	mov	[mmap_buf.fd], ebx
	mov	eax,90
	mov	ebx,mmap_buf
	int	0x80
	mov	dword[mmap_addr],eax
	or	eax,eax
	jns	.nx2
	jmp	mmap_file.er2
    .nx2:		
	;;;
	ret
;;INPUT: esi=*base_name, edi=*buffer;
new_date_name:
		push	edi
		push	esi
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
		pop	esi
		pop	edi		
		call	strcat
		cmp	dword[.saddr],0
		jz	.nx
		mov	esi,dword[.saddr]
		lodsb
		or	al,al
		jnz	.mfmt
	.nx:
		mov	al,'.'
		stosb
		mov	ebx,dword[tm + tmfmt.dy]
		call	put_chdate
		mov	al,'.'
		stosb
		mov	ebx,dword[tm + tmfmt.mo]
		call	put_chdate
		mov	al,'.'
		stosb		
		mov	ebx,dword[tm + tmfmt.yr]
		call	put_chdate
		mov	al,'.'
		stosb
		mov	ebx,dword[tm + tmfmt.hr]
		call	put_chdate
		mov	al,'.'
		stosb
		mov	ebx,dword[tm + tmfmt.mn]
		call	put_chdate
		mov	al,'.'
		stosb
		mov	ebx,dword[tm + tmfmt.sc]
		call	put_chdate
	    .ex:
		;;;
		ret
.saddr		dd	0
.mfmt:
		movzx	ecx,al
	.lp:
		lodsw
		inc esi
		 push ecx
		  call find_sfmt
		  call ebx
		 pop ecx
		dec	ecx
		jnz	.lp
		;;;
		ret
table_fmt:	
		db	"ss"
		    dd	pf_SS
		db	"mm"
		    dd	pf_MM
		db	"hh"
		    dd	pf_HH
		db	"dd"
		    dd	pf_DD
		db	"mo"
		    dd	pf_MO
		db	"yr"
		    dd	pf_YR
		db	"ww"
		    dd	pf_WW
		dw	0
pf_SS:
	mov	al,'.'
	stosb
	mov	ebx,dword[tm + tmfmt.sc]
	call	put_chdate
	;;;
	ret
pf_MM:
	mov	al,'.'
	stosb
	mov	ebx,dword[tm + tmfmt.mn]
	call	put_chdate
	;;;
	ret
pf_HH:
	mov	al,'.'
	stosb
	mov	ebx,dword[tm + tmfmt.hr]
	call	put_chdate
	;;;
	ret	
pf_DD:
	mov	al,'.'
	stosb
	mov	ebx,dword[tm + tmfmt.dy]
	call	put_chdate
	;;;
	ret	
pf_MO:
	mov	al,'.'
	stosb
	mov	ebx,dword[tm + tmfmt.mo]
	call	put_chdate
	;;;
	ret		
pf_YR:
	mov	al,'.'
	stosb
	mov	ebx,dword[tm + tmfmt.yr]
	call	put_chdate
	;;;
	ret	
pf_WW:
	mov	al,'.'
	stosb
	mov	ebx,dword[tm + tmfmt.w1]
	call	put_chdate
	;;;
	ret	
find_sfmt:
		mov	edx,esi
		mov	esi,table_fmt
		mov	bx,ax
	.lp:
		lodsw
		cmp	ax,bx
		je	.found
		or	ax,ax
		jz	.er
		lodsd
		jmp	short .lp
	.found:
		lodsd
		mov	ebx,eax
	.ex:
		mov	esi,edx
		;;;
		ret
	.er:
		mov	ebx,dword[table_fmt + 2]
		mov	esi,edx		
		;;;
		ret
put_chdate:
		cmp	ebx,10
		jge	.nx
		mov	al,'0'
		stosb
	    .nx:
		mov	eax,ebx
		call	d2s
		dec	edi
		;;;
		ret
;;INPUT edi=tmfmt, esi=tzfilename;
date:
		mov	eax,13
		mov	ebx,edi
		int	0x80	;time
date2:
		mov	ebx,esi
		call	mmap_file
;all that code described nearly, about data function,;
;i was get from asmutils, and thaks to Brian Raiter;
		mov	dword[mmap_addr],eax
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
;;INPUT edi=tmfmt, esi=tzfilename, eax=unix_time;
date_diff:
		mov	dword[edi],eax
		mov	ebx,esi
		call	mmap_file
;all that code described nearly, about data function,;
;i was get from asmutils, and thaks to Brian Raiter;
		mov	dword[mmap_addr],eax
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
;;esi=*stable_Atime, edi=*tm;
QallowTIME:
	mov	ebx,table_time
	mov	byte[.enew],0
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
.over	db	0
.ss	db	0
.mm	db	0
.hh	db	0
.dd	db	0
.mo	db	0
.yr	db	0
.tmp	db	0
.enew	db	0

allow_value	dd	0	;1 if allowed, otherwise is not	
;;INPUT: esi=*str4format, edi=*buffer;
dformat_str:
	push edi
	 mov edi,time_buffer
	 call strcat	 
	pop edi
	push esi
	 mov esi,time_buffer
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
	pop esi
	call to_zero
	;;;
	ret
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
	jz .range
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
	jz .range
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
	jz .star
	cmp al,'_'
	jz .enew
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
	jz .stardiv
	mov al,TMTYPE_ANY
	stosb
	;;;
	ret
.enew:
	inc esi
	mov al,TMTYPE_ENEW
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
	jz .dinc
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
	jz .strip
	or al,al
	jnz .lp
	;;;
	ret
 .strip:
	mov byte[esi-1],0
	jmp short .lp
do_time_check:
	mov byte[QallowTIME.enew],0
	lodsb
	movzx ecx,al
	mov byte[.state],0
	mov byte[time_any.any],0
    .lp:
	lodsb
	movzx ebx,al
	  push ecx
	    call dword[ebx*4+Ttable_funcs]
	    jc .nx
	     setnc byte[.state]
	.nx:
	  pop ecx
	dec ecx
	jnz .lp		
	test byte[.state],1
	jz .dstc
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
time_any:
    clc
    setnc byte[.any]
    ;;;
    ret
.any	db	0
time_enew:
    mov	byte[QallowTIME.enew],1
    stc
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
    jnz .dstc
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
    test byte[do_time_check.hr],1
    jnz .rnd_nx
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
    test byte[do_time_check.hr],1
    jz .rnd_nx
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
	    dd time_enew
time_SS:
	cmp dword[allow_value],0
	jz near .nx
	.TIME ss, sc
	mov eax,[edi + tmfmt.sc]
	mov dword[do_time_check.arg], eax
	call do_time_check
	jnc	.nx
	.ENEW1
	mov dword[allow_value],0
    .nx:
	;;;
	ret
	.ENEW2 ss
time_MM:
	cmp dword[allow_value],0
	jz near .nx
	.TIME mm, mn
	mov eax,[edi + tmfmt.mn]
	mov dword[do_time_check.arg], eax
	call do_time_check
	jnc	.nx
	.ENEW1
	mov dword[allow_value],0
    .nx:
	;;;
	ret
	.ENEW2 mm
time_HH:
	mov byte[do_time_check.hr],1
	cmp dword[allow_value],0
	jz near .nx
	.TIME hh, hr
	mov eax,[edi + tmfmt.hr]
	mov dword[do_time_check.arg], eax	
	call do_time_check
	jnc	.nx
	.ENEW1
	mov dword[allow_value],0
    .nx:
	mov byte[do_time_check.hr],0
	;;;
	ret
	.ENEW2 hh
time_DD:
	cmp dword[allow_value],0
	jz near .nx
	.TIME dd, dy
	mov eax,[edi + tmfmt.dy]
	mov dword[do_time_check.arg], eax	
	call do_time_check
	jnc	.nx
	.ENEW1
	mov dword[allow_value],0
    .nx:
	;;;
	ret
	.ENEW2 dd
time_MO:
	cmp dword[allow_value],0
	jz near .nx
	.TIME mo, mo
	mov eax,[edi + tmfmt.mo]
	mov dword[do_time_check.arg], eax	
	call do_time_check
	jnc	.nx
	.ENEW1
	mov dword[allow_value],0
    .nx:
	;;;
	ret
	.ENEW2 mo
time_YY:
	cmp dword[allow_value],0
	jz near .nx
	.TIME yr, yr
	mov eax,[edi + tmfmt.yr]
	mov dword[do_time_check.arg], eax	
	call do_time_check
	jnc	.nx
	.ENEW1
	mov dword[allow_value],0
    .nx:
	;;;
	ret
	.ENEW2 yy
time_WW:
	cmp dword[allow_value],0
	jz near .nx
	test byte[QallowTIME.over],1
	jnz .nx
	mov eax,[edi + tmfmt.w1]
	mov dword[do_time_check.arg], eax	
	call do_time_check
	jnc	.nx
	.ENEW1
	mov dword[allow_value],0
    .nx:
	;;;
	ret
	.ENEW2 ww
table_time:
	    dd	time_SS
	    dd	time_MM
	    dd	time_HH
	    dd	time_DD
	    dd	time_MO
	    dd	time_YY
	    dd	time_WW
	    dd	0
    
tzfilename:	db	'/etc/localtime',0
STRUC tmfmt
.ct:		resd	1	; C time (seconds since the Epoch)
.sc:		resd	1	; seconds
.mn:		resd	1	; minutes
.hr:		resd	1	; hours
.yr:		resd	1	; year
.hm:		resd	1	; hour of the meridian (1-12)
.mr:		resd	1	; meridian (0 for AM)
.wd:		resd	1	; day of the week (Sunday=0, Saturday=6)
.w1:		resd	1	; day of the week (Monday=1, Sunday=7)
.dy:		resd	1	; day of the month
.mo:		resd	1	; month (one-based)
.ws:		resd	1	; week of the year (Sunday-based)
.wm:		resd	1	; week of the year (Monday-based)
.wi:		resd	1	; week of the year according to ISO 8601:1988
.yi:		resd	1	; year for the week according to ISO 8601:1988
.yd:		resd	1	; day of the year
.ce:		resd	1	; century (zero-based)
.cy:		resd	1	; year of the century
.zo:		resd	1	; time zone offset
.zi:		resb	6	; time zone identifier
.tz:		resb	10	; time zone name
ENDSTRUC
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	