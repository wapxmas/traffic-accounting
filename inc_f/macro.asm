%macro .ENEW1 0-*
	test	byte[QallowTIME.enew],1
	jz	.nx_nq
	 call	.enew
	 jnc	.nx
    .nx_nq:
%endmacro
%macro .ENEW2 0-*
.enew:
	mov	ebx,dword[time_vid]
	test	byte[ftime_values_%1 + ebx],1
	jnz	.chk
	setz	byte[ftime_values_%1 + ebx]
	mov	eax,dword[do_time_check.arg]
	mov	dword[time_values_%1 + ebx*4],eax
.not_new:
	mov	dword[allow_value],0
	stc
	;;;
	ret
.chk:
	mov	eax,dword[do_time_check.arg]
	cmp	dword[time_values_%1 + ebx*4],eax
	jz	.not_new
	mov	dword[time_values_%1 + ebx*4],eax
	clc
	;;;
	ret
%endmacro
%macro .TIME  1-*
	test byte[QallowTIME.over],1
	jz near .nx2
	mov ebx,dword[tm2 + tmfmt.%2]
	cmp ebx,dword[edi + tmfmt.%2]
	jz .nx2	
	mov dword[allow_value],0
    .lp:
	mov dword[do_time_check.arg], ebx		
	push esi
	 push ebx
	call do_time_check
	jc .nx3
	test byte[time_any.any],1
	jnz .nx3
	mov dword[allow_value],1
	jmp short .nx_lp
    .nx3:
	test	byte[QallowTIME.enew],1
	jz	.nx_lp
	 call	.enew
	 jc	.nx_lp
	 mov dword[allow_value],1
    .nx_lp:
         pop ebx
	pop esi
	inc ebx
	%ifidni %1,ss
	    sub eax,eax	    
	    cmp ebx,61
	    cmove ebx,eax
	%elifidni %1,mm
	    sub eax,eax	    
	    cmp ebx,61
	    cmove ebx,eax	    
	%elifidni %1,hh
	    sub eax,eax
	    cmp ebx,24
	    cmove ebx,eax
	%elifidni %1,mo
	    mov	eax,1
	    cmp ebx,13
	    cmove ebx,eax
	%elifidni %1,dd
	    mov	eax,1
	    cmp ebx,32
	    cmove ebx,eax	    
	%endif
    
	cmp ebx,dword[edi + tmfmt.%2]
	jbe .lp
    .nx_eq:
	;;;
	ret
    .nx2:
%endmacro
%macro .DEBUG 1-*
    %if %1=0
     pusha
     mov ecx,esi
     mov edx,0x100
     call debugP
     popa    
    %elif %1=1
     pusha
     mov ecx,esi
     mov edx,1
     call debugP
     popa
    %elif %1=2
     mov ecx,esi
     mov edx,0x100
     call debugP
     call @exit
    %elif %1=3
     mov ecx,%2
     mov edx,0x100
     call debugP
     call @exit
    %elif %1=4
     mov ecx,%2
     mov edx,%3
     call debugP
     call @exit
    %elif %1=5
     pusha
     mov ecx,%2
     mov edx,0x100
     call debugP
     popa
    %elif %1=6
     pusha
     mov ecx,%2
     mov edx,%3
     call debugP
     popa    
    %endif
%endmacro