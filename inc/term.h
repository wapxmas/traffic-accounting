%assign NCCS 19
struc termios
.c_iflag	resd	1	; input mode flags
.c_oflag	resd	1	; output mode flags
.c_cflag	resd	1	; control mode flags
.c_lflag	resd	1	; local mode flags
.c_line		resb	1	; line discipline
.c_cc		resb	NCCS	; control characters
endstruc

%assign ISIG	0000001q
%assign ICANON	0000002q
%assign XCASE	0000004q
%assign ECHO	0000010q
%assign ECHOE	0000020q
%assign ECHOK	0000040q
%assign ECHONL	0000100q
%assign NOFLSH	0000200q
%assign TOSTOP	0000400q
%assign ECHOCTL	0001000q
%assign ECHOPRT	0002000q
%assign ECHOKE	0004000q
%assign FLUSHO	0010000q
%assign PENDIN	0040000q
%assign IEXTEN	0100000q

%assign	TCGETS	0x5401
%assign	TCSETS	0x5402
%assign	TCSETSW	0x5403
