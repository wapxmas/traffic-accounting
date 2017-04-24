;;Error defs;
%include	"inc_f/srverr.asm"
txt1:		db	"Error: ",0
txt2:		db	"file ",0
txt3:		db	" doesn`t exists.",0
txt4:		db	0xA,0
txt5:		db	"variable ",0
txt6:		db	"in config file ",0
txt7:		db	": path too long",0
txt8:		db	"Interface: ",0
txt9:		db	": ",0
txt10:		db	"socket()",0
txt11:		db	"ioctl SIOCGIFFLAGS",0
txt12:		db	"ioctl SIOCSIFFLAGS",0
txt13:		db	"recvfrom()",0
txt14:		db	"ioctl SIOCGIFNAME",0
txt15:		db	"mmap() ",0
txt16:		db	"System: ",0
txt17:		db	'"',0
txt18:		db	"on line ",0
txt19:		db	" ",0
txt20:		db	"Syntax error: ",0
txt21:		db	"fseek() ",0
txt22:		db	"open() ",0
txt23:		db	"write() ",0
txt24:		db	"setitimer() ",0
c_file:		dd	0
error_m:
	.s1:
	    dd	txt8
	    dd	process.dev
	    dd	txt9
	    dd	txt10
	    dd	txt9
	    dd	0
	.s2:
	    dd	txt8
	    dd	iface_main
	    dd	txt9
	    dd	txt11
	    dd	txt9
	    dd	0
	.s3:
	    dd	txt8
	    dd	iface_main
	    dd	txt9
	    dd	txt12
	    dd	txt9
	    dd	0
	.s4:
	    dd	txt8
	    dd	process.dev
	    dd	txt9
	    dd	txt13
	    dd	txt9
	    dd	0
	.s5:
	    dd	txt8
	    dd	process.dev
	    dd	txt9
	    dd	txt14
	    dd	txt9
	    dd	0
	.s6:
	    dd	txt16
	    dd	txt22
	    dd	txt2
	    dd	txt17
	    dd	0
	    dd	txt17
	    dd	txt9
	    dd	0
	.s7:
	    dd	txt20
	    dd	txt18
	    dd	main_buffer
	    dd	txt19
	    dd	txt6
	    dd	txt17
	    dd	0
	    dd	txt17
	    dd	txt4
	    dd	0
	.s8:
	    dd	txt16
	    dd	txt15
	    dd	txt9
	    dd	txt21
	    dd	txt9
	    dd	0
	.s9:
	    dd	txt16
	    dd	txt15
	    dd	txt9
	    dd	0
	.s10:
	    dd	txt16
	    dd	txt22
	    dd	txt2
	    dd	txt17
	    dd	0
	    dd	txt17
	    dd	txt9
	    dd	0
	.s11:
	    dd	txt16
	    dd	txt23
	    dd	txt9
	    dd	0
	.s12:
	    dd	txt16
	    dd	txt24
	    dd	txt9
	    dd	0	    
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>		    