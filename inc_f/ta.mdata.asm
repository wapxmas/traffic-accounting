;;addons to data;
server_timeout:
	dd	5
	dd	0
server_login	db	0
err_fl		db	"Password db doesn`t exists",0xA,0
server_socket:	dd	0
server_sockcon:	dd	0
;sys_setsockopt ebp,SOL_SOCKET,SO_REUSEADDR,setsockoptvals,4		
args_opt:
	    .sock:	dd	0
	    .level:	dd	SOL_SOCKET
	    .optname:	dd	SO_REUSEADDR
	    .optval:	dd	.setsockoptvals
	    .optlen:	dd	4
 .setsockoptvals:	dd	1

sockaddr_in:
		.sin_family:	dw	0
		.sin_port:	dw	0
		.sin_addr:	dd	0
.__pad:		
		times	__ASOCK_SIZE__	db	0    
args_sock_srv_1:
		dd	PF_INET
		dd	SOCK_STREAM
		dd	IPPROTO_TCP
ssize: dd __STRUCT_S_SIZE__
args_sock_srv_2:
		.sock:	dd	0
		dd	sockaddr_in
		.s_size:
		dd __STRUCT_S_SIZE__
args_sock_srv_3:
		.sock:		dd	0
		.maxcon:	dw	0
args_sock_srv_4:
		.sock:		dd	0
		dd	sockaddr_in
		dd	ssize
	