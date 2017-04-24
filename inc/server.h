struc server_entry
    ;;struc srv_phead;
    .p_length:	resd	1
    .p_type:	resb	1
    ;;endstruc;
    .e_pack_l:	resd	1
    .ifname:	resb	IFMAXNAME
    .sll_htype: resw	1
endstruc
%assign	FD_SETSIZE	1024

struc fd_set
	resd	FD_SETSIZE / 32
endstruc

%define MAXSRVPACKLEN	0x1000
%define SRVTIMEOUT	2+SECONDSA
%define SECONDSA	2

;;struct of the packet header;

struc srv_phead
    .p_length:	resd	1
    .p_type:	resb	1
endstruc

;;packet types;
%define SCNT_TYPES	8

%define PTYPE_LOGIN	1
%define PTYPE_ERROR	2
%define	PTYPE_LOGOUT	3
%define PTYPE_ENTRY	4
%define PTYPE_TIMEOUT	5
%define PTYPE_ELOGN	6
%define PTYPE_ERRTP	7
%define PTYPE_CHKLOGIN	8