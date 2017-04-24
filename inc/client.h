%define	IFMAXNAME 16
%define  __SOCK_SIZE__	16
%define  __ASOCK_SIZE__ (__SOCK_SIZE__ -  2 - 2 - 4)
%define  __STRUCT_S_SIZE__ (__ASOCK_SIZE__ + 2 + 2 + 4)
%define  SYS_SOCK	102
%define	MAXIPPACKLEN	8192
