;/* Socket types. */
%define SOCK_STREAM	1		;/* stream (connection) socket	*/
%define SOCK_DGRAM	2		;/* datagram (conn.less) socket	*/
%define SOCK_RAW	3		;/* raw socket			*/
%define SOCK_RDM	4		;/* reliably-delivered message	*/
%define SOCK_SEQPACKET	5		;/* sequential packet socket	*/
%define SOCK_PACKET	10		;/* linux specific way of	*/
					;/* getting packets at the dev	*/
					;/* level.  For writing rarp and	*/
					;/* other similar things on the	*/
					;/* user level.			*/
;/* Supported address families. */
%define AF_UNSPEC	0
%define AF_UNIX		1	;/* Unix domain sockets 		*/
%define AF_LOCAL	1	;/* POSIX name for AF_UNIX	*/
%define AF_INET		2	;/* Internet IP Protocol 	*/
%define AF_AX25		3	;/* Amateur Radio AX.25 		*/
%define AF_IPX		4	;/* Novell IPX 			*/
%define AF_APPLETALK	5	;/* AppleTalk DDP 		*/
%define AF_NETROM	6	;/* Amateur Radio NET/ROM 	*/
%define AF_BRIDGE	7	;/* Multiprotocol bridge 	*/
%define AF_ATMPVC	8	;/* ATM PVCs			*/
%define AF_X25		9	;/* Reserved for X.25 project 	*/
%define AF_INET6	10	;/* IP version 6			*/
%define AF_ROSE		11	;/* Amateur Radio X.25 PLP	*/
%define AF_DECnet	12	;/* Reserved for DECnet project	*/
%define AF_NETBEUI	13	;/* Reserved for 802.2LLC project*/
%define AF_SECURITY	14	;/* Security callback pseudo AF */
%define AF_KEY		15      ;/* PF_KEY key management API */
%define AF_NETLINK	16
%define AF_ROUTE	AF_NETLINK ;/* Alias to emulate 4.4BSD */
%define AF_PACKET	17	;/* Packet family		*/
%define AF_ASH		18	;/* Ash				*/
%define AF_ECONET	19	;/* Acorn Econet			*/
%define AF_ATMSVC	20	;/* ATM SVCs			*/
%define AF_SNA		22	;/* Linux SNA Project (nutters!) */
%define AF_IRDA		23	;/* IRDA sockets			*/
%define AF_PPPOX	24	;/* PPPoX sockets		*/
%define AF_MAX		32	;/* For now.. */

;;/* Protocol families, same as address families. */
%define PF_UNSPEC	AF_UNSPEC
%define PF_UNIX		AF_UNIX
%define PF_LOCAL	AF_LOCAL
%define PF_INET		AF_INET
%define PF_AX25		AF_AX25
%define PF_IPX		AF_IPX
%define PF_APPLETALK	AF_APPLETALK
%define	PF_NETROM	AF_NETROM
%define PF_BRIDGE	AF_BRIDGE
%define PF_ATMPVC	AF_ATMPVC
%define PF_X25		AF_X25
%define PF_INET6	AF_INET6
%define PF_ROSE		AF_ROSE
%define PF_DECnet	AF_DECnet
%define PF_NETBEUI	AF_NETBEUI
%define PF_SECURITY	AF_SECURITY
%define PF_KEY		AF_KEY
%define PF_NETLINK	AF_NETLINK
%define PF_ROUTE	AF_ROUTE
%define PF_PACKET	AF_PACKET
%define PF_ASH		AF_ASH
%define PF_ECONET	AF_ECONET
%define PF_ATMSVC	AF_ATMSVC
%define PF_SNA		AF_SNA
%define PF_IRDA		AF_IRDA
%define PF_PPPOX	AF_PPPOX
%define PF_MAX		AF_MAX

;/* Address to accept any incoming messages. */
%define	INADDR_ANY		0x00000000

;;/* Address to send to all hosts. */
%define	INADDR_BROADCAST	0xffffffff

;/* Address indicating an error return. */
%define	INADDR_NONE		0xffffffff

;/* Network number for local host loopback. */
%define	IN_LOOPBACKNET		127

;/* Address to loopback in software to local host.  */
%define	INADDR_LOOPBACK		0x7f000001	;/* 127.0.0.1   */

;/* Defines for Multicast INADDR */
%define INADDR_UNSPEC_GROUP   	0xe0000000	;/* 224.0.0.0   */
%define INADDR_ALLHOSTS_GROUP 	0xe0000001	;/* 224.0.0.1   */
%define INADDR_ALLRTRS_GROUP    0xe0000002	;/* 224.0.0.2 */
%define INADDR_MAX_LOCAL_GROUP  0xe00000ff	;/* 224.0.0.255 */

%define SYS_SOCKET	1		;/* sys_socket(2)		*/
%define SYS_BIND	2		;/* sys_bind(2)			*/
%define SYS_CONNECT	3		;/* sys_connect(2)		*/
%define SYS_LISTEN	4		;/* sys_listen(2)		*/
%define SYS_ACCEPT	5		;/* sys_accept(2)		*/
%define SYS_GETSOCKNAME	6		;/* sys_getsockname(2)		*/
%define SYS_GETPEERNAME	7		;/* sys_getpeername(2)		*/
%define SYS_SOCKETPAIR	8		;/* sys_socketpair(2)		*/
%define SYS_SEND	9		;/* sys_send(2)			*/
%define SYS_RECV	10		;/* sys_recv(2)			*/
%define SYS_SENDTO	11		;/* sys_sendto(2)		*/
%define SYS_RECVFROM	12		;/* sys_recvfrom(2)		*/
%define SYS_SHUTDOWN	13		;/* sys_shutdown(2)		*/
%define SYS_SETSOCKOPT	14		;/* sys_setsockopt(2)		*/
%define SYS_GETSOCKOPT	15		;/* sys_getsockopt(2)		*/
%define SYS_SENDMSG	16		;/* sys_sendmsg(2)		*/
%define SYS_RECVMSG	17		;/* sys_recvmsg(2)		*/
					
%define   IPPROTO_IP  0		;/* Dummy protocol for TCP		*/
%define   IPPROTO_ICMP  1		;/* Internet Control Message Protocol	*/
%define   IPPROTO_IGMP  2		;/* Internet Group Management Protocol	*/
%define   IPPROTO_IPIP  4		;/* IPIP tunnels (older KA9Q tunnels use 94) */
%define   IPPROTO_TCP  6		;/* Transmission Control Protocol	*/
%define   IPPROTO_EGP  8		;/* Exterior Gateway Protocol		*/
%define   IPPROTO_PUP  12		;/* PUP protocol				*/
%define   IPPROTO_UDP  17		;/* User Datagram Protocol		*/
%define   IPPROTO_IDP  22		;/* XNS IDP protocol			*/
%define   IPPROTO_RSVP  46		;/* RSVP protocol			*/
%define   IPPROTO_GRE  47		;/* Cisco GRE tunnels (rfc 17011702)	*/
%define   IPPROTO_IPV6	  41		;/* IPv6-in-IPv4 tunnelling		*/
%define   IPPROTO_PIM     103		;/* Protocol Independent Multicast	*/
%define   IPPROTO_ESP  50            ;/* Encapsulation Security Payload protocol */
%define   IPPROTO_AH  51             ;/* Authentication Header protocol       */
%define   IPPROTO_COMP    108                ;/* Compression Header protocol */
%define   IPPROTO_RAW	  255		;/* Raw IP packets			*/
;/* For setsockoptions(2) */
%define SOL_SOCKET	1

%define SO_DEBUG	1
%define SO_REUSEADDR	2
%define SO_TYPE		3
%define SO_ERROR	4
%define SO_DONTROUTE	5
%define SO_BROADCAST	6
%define SO_SNDBUF	7
%define SO_RCVBUF	8
%define SO_KEEPALIVE	9
%define SO_OOBINLINE	10
%define SO_NO_CHECK	11
%define SO_PRIORITY	12
%define SO_LINGER	13
%define SO_BSDCOMPAT	14
;/* To add :%define SO_REUSEPORT 15 */
%define SO_PASSCRED	16
%define SO_PEERCRED	17
%define SO_RCVLOWAT	18
%define SO_SNDLOWAT	19
%define SO_RCVTIMEO	20
%define SO_SNDTIMEO	21
;/* Security levels - as per NRL IPv6 - don't actually do anything */
%define SO_SECURITY_AUTHENTICATION		22
%define SO_SECURITY_ENCRYPTION_TRANSPORT	23
%define SO_SECURITY_ENCRYPTION_NETWORK		24

%define SO_BINDTODEVICE	25
;/* Socket filtering */
%define SO_ATTACH_FILTER        26
%define SO_DETACH_FILTER        27
%define SO_PEERNAME		28
%define SO_TIMESTAMP		29
%define SCM_TIMESTAMP		SO_TIMESTAMP
;/* Nasty libc5 fixup - bletch */
;/* Socket types. */
%define SOCK_STREAM	1		;/* stream (connection) socket	*/
%define SOCK_DGRAM	2		;/* datagram (conn.less) socket	*/
%define SOCK_RAW	3		;/* raw socket			*/
%define SOCK_RDM	4		;/* reliably-delivered message	*/
%define SOCK_SEQPACKET	5		;/* sequential packet socket	*/
%define SOCK_PACKET	10		;/* linux specific way of	*/
					;/* getting packets at the dev	*/
					;/* level.  For writing rarp and	*/
					;/* other similar things on the	*/
					;/* user level.			*/

;/*
; * INET		An implementation of the TCP/IP protocol suite for the LINUX
; *		operating system.  INET is implemented using the  BSD Socket
; *		interface as the means of communication with the user level.
; *
; *		Global definitions for the Ethernet IEEE 802.3 interface.
; *
; * Version:	@(#)if_ether.h	1.0.1a	02/08/94
; *
; * Author:	Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
; *		Donald Becker, <becker@super.org>
; *		Alan Cox, <alan@redhat.com>
; *		Steve Whitehouse, <gw7rrm@eeshack3.swan.ac.uk>
; *
; *		This program is free software; you can redistribute it and/or
; *		modify it under the terms of the GNU General Public License
; *		as published by the Free Software Foundation; either version
; *		2 of the License, or (at your option) any later version.
; */
; 
;/*
; *	IEEE 802.3 Ethernet magic constants.  The frame sizes omit the preamble
; *	and FCS/CRC (frame check sequence). 
; */

%define ETH_ALEN	6		;/* Octets in one ethernet addr	 */
%define ETH_HLEN	14		;/* Total octets in header.	 */
%define ETH_ZLEN	60		;/* Min. octets in frame sans FCS */
%define ETH_DATA_LEN	1500		;/* Max. octets in payload	 */
%define ETH_FRAME_LEN	1514		;/* Max. octets in frame sans FCS */

;/*
; *	These are the defined Ethernet Protocol ID's.
; */

%define ETH_P_LOOP	0x0060		;/* Ethernet Loopback packet	*/
%define ETH_P_PUP	0x0200		;/* Xerox PUP packet		*/
%define ETH_P_PUPAT	0x0201		;/* Xerox PUP Addr Trans packet	*/
%define ETH_P_IP	0x0800		;/* Internet Protocol packet	*/
%define ETH_P_X25	0x0805		;/* CCITT X.25			*/
%define ETH_P_ARP	0x0806		;/* Address Resolution packet	*/
%define	ETH_P_BPQ	0x08FF		;/* G8BPQ AX.25 Ethernet Packet	[ NOT AN OFFICIALLY REGISTERED ID ] */
%define ETH_P_IEEEPUP	0x0a00		;/* Xerox IEEE802.3 PUP packet */
%define ETH_P_IEEEPUPAT	0x0a01		;/* Xerox IEEE802.3 PUP Addr Trans packet */
%define ETH_P_DEC       0x6000          ;/* DEC Assigned proto           */
%define ETH_P_DNA_DL    0x6001          ;/* DEC DNA Dump/Load            */
%define ETH_P_DNA_RC    0x6002          ;/* DEC DNA Remote Console       */
%define ETH_P_DNA_RT    0x6003          ;/* DEC DNA Routing              */
%define ETH_P_LAT       0x6004          ;/* DEC LAT                      */
%define ETH_P_DIAG      0x6005          ;/* DEC Diagnostics              */
%define ETH_P_CUST      0x6006          ;/* DEC Customer use             */
%define ETH_P_SCA       0x6007          ;/* DEC Systems Comms Arch       */
%define ETH_P_RARP      0x8035		;/* Reverse Addr Res packet	*/
%define ETH_P_ATALK	0x809B		;/* Appletalk DDP		*/
%define ETH_P_AARP	0x80F3		;/* Appletalk AARP		*/
%define ETH_P_8021Q	0x8100          ;/* 802.1Q VLAN Extended Header  */
%define ETH_P_IPX	0x8137		;/* IPX over DIX			*/
%define ETH_P_IPV6	0x86DD		;/* IPv6 over bluebook		*/
%define ETH_P_PPP_DISC	0x8863		;/* PPPoE discovery messages     */
%define ETH_P_PPP_SES	0x8864		;/* PPPoE session messages	*/
%define ETH_P_ATMMPOA	0x884c		;/* MultiProtocol Over ATM	*/
%define ETH_P_ATMFATE	0x8884		;/* Frame-based ATM Transport
					; * over Ethernet
					; */

;/*
; *	Non DIX types. Won't clash for 1500 types.
; */
 
%define ETH_P_802_3	0x0001		;/* Dummy type for 802.3 frames  */
%define ETH_P_AX25	0x0002		;/* Dummy protocol id for AX.25  */
%define ETH_P_ALL	0x0003		;/* Every packet (be careful!!!) */
%define ETH_P_802_2	0x0004		;/* 802.2 frames 		*/
%define ETH_P_SNAP	0x0005		;/* Internal only		*/
%define ETH_P_DDCMP     0x0006          ;/* DEC DDCMP: Internal only     */
%define ETH_P_WAN_PPP   0x0007          ;/* Dummy type for WAN PPP frames*/
%define ETH_P_PPP_MP    0x0008          ;/* Dummy type for PPP MP frames */
%define ETH_P_LOCALTALK 0x0009		;/* Localtalk pseudo type 	*/
%define ETH_P_PPPTALK	0x0010		;/* Dummy type for Atalk over PPP*/
%define ETH_P_TR_802_2	0x0011		;/* 802.2 frames 		*/
%define ETH_P_MOBITEX	0x0015		;/* Mobitex (kaz@cafe.net)	*/
%define ETH_P_CONTROL	0x0016		;/* Card specific control frames */
%define ETH_P_IRDA	0x0017		;/* Linux-IrDA			*/
%define ETH_P_ECONET	0x0018		;/* Acorn Econet			*/

;/*
; *	This is an Ethernet frame header.
; */
;/* Standard interface flags (netdevice->flags). */
%define	IFF_UP		0x1		;/* interface is up		*/
%define	IFF_BROADCAST	0x2		;/* broadcast address valid	*/
%define	IFF_DEBUG	0x4		;/* turn on debugging		*/
%define	IFF_LOOPBACK	0x8		;/* is a loopback net		*/
%define	IFF_POINTOPOINT	0x10		;/* interface is has p-p link	*/
%define	IFF_NOTRAILERS	0x20		;/* avoid use of trailers	*/
%define	IFF_RUNNING	0x40		;/* resources allocated		*/
%define	IFF_NOARP	0x80		;/* no ARP protocol		*/
%define	IFF_PROMISC	0x100		;/* receive all packets		*/
%define	IFF_ALLMULTI	0x200		;/* receive all multicast packets*/

%define IFF_MASTER	0x400		;/* master of a load balancer 	*/
%define IFF_SLAVE	0x800		;/* slave of a load balancer	*/

%define IFF_MULTICAST	0x1000		;/* Supports multicast		*/

%define IFF_VOLATILE	(IFF_LOOPBACK|IFF_POINTOPOINT|IFF_BROADCAST|IFF_MASTER|IFF_SLAVE|IFF_RUNNING)

%define IFF_PORTSEL	0x2000          ;/* can set media type		*/
%define IFF_AUTOMEDIA	0x4000		;/* auto media select active	*/
%define IFF_DYNAMIC	0x8000		;/* dialup device with changing addresses*/

;/* Private (from user) interface flags (netdevice->priv_flags). */
%define IFF_802_1Q_VLAN 0x1             ;/* 802.1Q VLAN device.          */
%define SIOCADDRT	0x890B		;/* add routing table entry	*/
%define SIOCDELRT	0x890C		;/* delete routing table entry	*/
%define SIOCRTMSG	0x890D		;/* call to routing system	*/

;/* Socket configuration controls. */
%define SIOCGIFNAME	0x8910		;/* get iface name		*/
%define SIOCSIFLINK	0x8911		;/* set iface channel		*/
%define SIOCGIFCONF	0x8912		;/* get iface list		*/
%define SIOCGIFFLAGS	0x8913		;/* get flags			*/
%define SIOCSIFFLAGS	0x8914		;/* set flags			*/
%define SIOCGIFADDR	0x8915		;/* get PA address		*/
%define SIOCSIFADDR	0x8916		;/* set PA address		*/
%define SIOCGIFDSTADDR	0x8917		;/* get remote PA address	*/
%define SIOCSIFDSTADDR	0x8918		;/* set remote PA address	*/
%define SIOCGIFBRDADDR	0x8919		;/* get broadcast PA address	*/
%define SIOCSIFBRDADDR	0x891a		;/* set broadcast PA address	*/
%define SIOCGIFNETMASK	0x891b		;/* get network PA mask		*/
%define SIOCSIFNETMASK	0x891c		;/* set network PA mask		*/
%define SIOCGIFMETRIC	0x891d		;/* get metric			*/
%define SIOCSIFMETRIC	0x891e		;/* set metric			*/
%define SIOCGIFMEM	0x891f		;/* get memory address (BSD)	*/
%define SIOCSIFMEM	0x8920		;/* set memory address (BSD)	*/
%define SIOCGIFMTU	0x8921		;/* get MTU size			*/
%define SIOCSIFMTU	0x8922		;/* set MTU size			*/
%define SIOCSIFNAME	0x8923		;/* set interface name */
%define	SIOCSIFHWADDR	0x8924		;/* set hardware address 	*/
%define SIOCGIFENCAP	0x8925		;/* get/set encapsulations       */
%define SIOCSIFENCAP	0x8926		
%define SIOCGIFHWADDR	0x8927		;/* Get hardware address		*/
%define SIOCGIFSLAVE	0x8929		;/* Driver slaving support	*/
%define SIOCSIFSLAVE	0x8930
%define SIOCADDMULTI	0x8931		;/* Multicast address lists	*/
%define SIOCDELMULTI	0x8932
%define SIOCGIFINDEX	0x8933		;/* name -> if_index mapping	*/
%define SIOGIFINDEX	SIOCGIFINDEX	;/* misprint compatibility :-)	*/
%define SIOCSIFPFLAGS	0x8934		;/* set/get extended flags set	*/
%define SIOCGIFPFLAGS	0x8935
%define SIOCDIFADDR	0x8936		;/* delete PA address		*/
%define	SIOCSIFHWBROADCAST	0x8937	;/* set hardware broadcast addr	*/
%define SIOCGIFCOUNT	0x8938		;/* get number of devices */

%define SIOCGIFBR	0x8940		;/* Bridging support		*/
%define SIOCSIFBR	0x8941		;/* Set bridging options 	*/

%define SIOCGIFTXQLEN	0x8942		;/* Get the tx queue length	*/
%define SIOCSIFTXQLEN	0x8943		;/* Set the tx queue length 	*/

%define SIOCGIFDIVERT	0x8944		;/* Frame diversion support */
%define SIOCSIFDIVERT	0x8945		;/* Set frame diversion options */

%define SIOCETHTOOL	0x8946		;/* Ethtool interface		*/

%define SIOCGMIIPHY	0x8947		;/* Get address of MII PHY in use. */
%define SIOCGMIIREG	0x8948		;/* Read MII PHY register.	*/
%define SIOCSMIIREG	0x8949		;/* Write MII PHY register.	*/

;/* ARP cache control calls. */
;		    /*  0x8950 - 0x8952  * obsolete calls, don't re-use */
%define SIOCDARP	0x8953		;/* delete ARP table entry	*/
%define SIOCGARP	0x8954		;/* get ARP table entry		*/
%define SIOCSARP	0x8955		;/* set ARP table entry		*/

;/* RARP cache control calls. */
%define SIOCDRARP	0x8960		;/* delete RARP table entry	*/
%define SIOCGRARP	0x8961		;/* get RARP table entry		*/
%define SIOCSRARP	0x8962		;/* set RARP table entry		*/

;/* Driver configuration calls */

%define SIOCGIFMAP	0x8970		;/* Get device parameters	*/
%define SIOCSIFMAP	0x8971		;/* Set device parameters	*/

;/* DLCI configuration calls */

%define SIOCADDDLCI	0x8980		;/* Create new DLCI device	*/
%define SIOCDELDLCI	0x8981		;/* Delete DLCI device		*/

%define SIOCGIFVLAN	0x8982		;/* 802.1Q VLAN support		*/
%define SIOCSIFVLAN	0x8983		;/* Set 802.1Q VLAN options 	*/

;/* bonding calls */

%define SIOCBONDENSLAVE	0x8990		;/* enslave a device to the bond */
%define SIOCBONDRELEASE 0x8991		;/* release a slave from the bond*/
%define SIOCBONDSETHWADDR      0x8992	;/* set the hw addr of the bond  */
%define SIOCBONDSLAVEINFOQUERY 0x8993   ;/* rtn info about slave state   */
%define SIOCBONDINFOQUERY      0x8994	;/* rtn info about bond state    */
%define SIOCBONDCHANGEACTIVE   0x8995   ;/* update to a new active slave */
			
;/* Device private ioctl calls */

;*
;*	These 16 ioctls are available to devices via the do_ioctl() device
;*	vector. Each device should include this file and redefine these names
;*	as their own. Because these are device dependent it is a good idea
;*	_NOT_ to issue them to random objects and hope.
;*
;*	THESE IOCTLS ARE _DEPRECATED_ AND WILL DISAPPEAR IN 2.5.X -DaveM
;*/
 
%define SIOCDEVPRIVATE	0x89F0	;* to 89FF */

;*
;These 16 ioctl calls are protocol private
;*/
 
%define ETH_ALEN	6		;/* Octets in one ethernet addr	 */
%define ETH_HLEN	14		;/* Total octets in header.	 */
%define ETH_ZLEN	60		;/* Min. octets in frame sans FCS */
%define ETH_DATA_LEN	1500		;/* Max. octets in payload	 */
%define ETH_FRAME_LEN	1514		;/* Max. octets in frame sans FCS */

%define ARPHRD_NETROM	0		;/* from KA9Q: NET/ROM pseudo	*/
%define ARPHRD_ETHER 	1		;/* Ethernet 10Mbps		*/
%define	ARPHRD_EETHER	2		;/* Experimental Ethernet	*/
%define	ARPHRD_AX25	3		;/* AX.25 Level 2		*/
%define	ARPHRD_PRONET	4		;/* PROnet token ring		*/
%define	ARPHRD_CHAOS	5		;/* Chaosnet			*/
%define	ARPHRD_IEEE802	6		;/* IEEE 802.2 Ethernet/TR/TB	*/
%define	ARPHRD_ARCNET	7		;/* ARCnet			*/
%define	ARPHRD_APPLETLK	8		;/* APPLEtalk			*/
%define ARPHRD_DLCI	15		;/* Frame Relay DLCI		*/
%define ARPHRD_ATM	19		;/* ATM 				*/
%define ARPHRD_METRICOM	23		;/* Metricom STRIP (new IANA id)	*/
%define	ARPHRD_IEEE1394	24		;/* IEEE 1394 IPv4 - RFC 2734	*/
%define ARPHRD_EUI64	27		;/* EUI-64                       */

;/* Dummy types for non ARP hardware */
%define ARPHRD_SLIP	256
%define ARPHRD_CSLIP	257
%define ARPHRD_SLIP6	258
%define ARPHRD_CSLIP6	259
%define ARPHRD_RSRVD	260		;/* Notional KISS type 		*/
%define ARPHRD_ADAPT	264
%define ARPHRD_ROSE	270
%define ARPHRD_X25	271		;/* CCITT X.25			*/
%define ARPHRD_HWX25	272		;/* Boards with X.25 in firmware	*/
%define ARPHRD_PPP	512
%define ARPHRD_CISCO	513		;/* Cisco HDLC	 		*/
%define ARPHRD_HDLC	ARPHRD_CISCO
%define ARPHRD_LAPB	516		;/* LAPB				*/
%define ARPHRD_DDCMP    517		;/* Digital's DDCMP protocol     */
%define ARPHRD_RAWHDLC	518		;/* Raw HDLC			*/

%define ARPHRD_TUNNEL	768		;/* IPIP tunnel			*/
%define ARPHRD_TUNNEL6	769		;/* IPIP6 tunnel			*/
%define ARPHRD_FRAD	770             ;/* Frame Relay Access Device    */
%define ARPHRD_SKIP	771		;/* SKIP vif			*/
%define ARPHRD_LOOPBACK	772		;/* Loopback device		*/
%define ARPHRD_LOCALTLK 773		;/* Localtalk device		*/
%define ARPHRD_FDDI	774		;/* Fiber Distributed Data Interface */
%define ARPHRD_BIF      775             ;/* AP1000 BIF                   */
%define ARPHRD_SIT	776		;/* sit0 device - IPv6-in-IPv4	*/
%define ARPHRD_IPDDP	777		;/* IP over DDP tunneller	*/
%define ARPHRD_IPGRE	778		;/* GRE over IP			*/
%define ARPHRD_PIMREG	779		;/* PIMSM register interface	*/
%define ARPHRD_HIPPI	780		;/* High Performance Parallel Interface */
%define ARPHRD_ASH	781		;/* Nexus 64Mbps Ash		*/
%define ARPHRD_ECONET	782		;/* Acorn Econet			*/
%define ARPHRD_IRDA 	783		;/* Linux-IrDA			*/
;/* ARP works differently on different FC media .. so  */
%define ARPHRD_FCPP	784		;/* Point to point fibrechannel	*/
%define ARPHRD_FCAL	785		;/* Fibrechannel arbitrated loop */
%define ARPHRD_FCPL	786		;/* Fibrechannel public loop	*/
%define ARPHRD_FCFABRIC	787		;/* Fibrechannel fabric		*/
;	/* 787->799 reserved for fibrechannel media types */
%define ARPHRD_IEEE802_TR 800		;/* Magic type ident for TR	*/
%define ARPHRD_IEEE80211 801		;/* IEEE 802.11			*/

%define ARPHRD_VOID	  0xFFFF	;/* Void type, nothing is known */

%define PACKET_HOST		0		;/* To us		*/
%define PACKET_BROADCAST	1		;/* To all		*/
%define PACKET_MULTICAST	2		;/* To group		*/
%define PACKET_OTHERHOST	3		;/* To someone else 	*/
%define PACKET_OUTGOING		4		;/* Outgoing of any type */
;/* These ones are invisible by user level */
%define PACKET_LOOPBACK		5		;/* MC/BRD frame looped back */
%define PACKET_FASTROUTE	6		;/* Fastrouted frame	*/

;/* Packet socket options */

%define PACKET_ADD_MEMBERSHIP		1
%define PACKET_DROP_MEMBERSHIP		2
%define PACKET_RECV_OUTPUT		3
;/* Value 4 is still used by obsolete turbo-packet. */
%define PACKET_RX_RING			5
%define PACKET_STATISTICS		6
%define PACKET_COPY_THRESH		7
