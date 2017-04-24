#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <netinet/if_ether.h>
#include <string.h>
#include <term.h>
#include <asm/ioctls.h>
#include "server.h"
#include <signal.h>
#include <net/if.h>
#include <linux/sockios.h>
#include <netpacket/packet.h>

#define MAXBUFSIZE	0x1000
#define ARPHRD_ETHER 	1
#define ARPHRD_LOOPBACK	772
#define ARPHRD_FDDI	774
#define ETH_HLEN	14

struct dpack {
	long sip;
	long dip;
	short sp;
	short dp;
	char proto;
};

    void *link_types[] = { (void *)ARPHRD_ETHER,(void *)ETH_HLEN,
			   (void *)ARPHRD_LOOPBACK,(void *)ETH_HLEN,
			   (void *)ARPHRD_FDDI,(void *)21,
			   0,0
			 };


int getarguments(int count, char *argv_struct[], void *ps_argv);
int getargc(long *ps_argv);
char * findargv(char *argv, long *ps_argv);
unsigned long strtodec(char *value);
void strcpyt(char *to, char *from);
void tstrcat(char *tostr, char *str);
unsigned long tozero(char *str);
unsigned long strlent(char *str);
int strcmpt(char *str1, char *str2);
int argexists(char *arg, long *ps_argv);
char *getargval(char *arg, long *ps_argv, int num);
unsigned long sIPtoN(char *value);
unsigned long chstrdec(char *value, char ch);
char *gen_loginp(char *name, char *pass);
void SIGPIPE_handler(void);
int trafinit(char *iface, int domain, int type);
void get_packet_p(char *buf, struct dpack *diff_pack);
int another_header(short *htype, long *link_types);
int check_packet(short *hatype, char *buffer, struct dpack *pdiff);

int main(int argc, char *argv[])
{
    
    void *ps_argv[] = {
	"-s",(char *)1,0,0,
	"-p",(char *)1,0,0,
	"-d",(char *)0,0,0,
	"--user",(char *)1,0,0,
	"--pass",(char *)1,0,0,
	0
	    };
    char *usage = "\nUsage: tsclient -s IP -p PORT --user USER [--pass PASS] [-d]\n\n"
		"   -s        <server>: ip of wich the talinux server is running\n"
		"   -p          <port>: port on the talinux server\n"
		"   -d                : daemonized mode\n"
		"   --user <user_name>: user wich will be logged in\n"
		"   --pass  <password>: password for user, if that has absent then password \n"
		"		       will to be reading from input\n";				

    long *p, server_ip, len, len2,len3,len4,len5;
    short server_port, *typeh;
    struct termios ti;
    char *buf1, *pb, *buf2, *buf3, *buf4, *buf5;
    int client_socket, socket1, socket2;
    struct sockaddr_in sock;
    struct sockaddr_ll sock1;
    struct dpack diff_pack;
    struct ifreq ifr;
    
    argc--;
    getarguments(argc, argv, ps_argv);
    if(!argexists("-s", (long *)ps_argv)) {
pusage:
	printf("%s",usage);
	exit(1);
    } else if (!getargval("-s", (long *)ps_argv, 1)) {
	goto pusage;
    }
    if(!inet_aton(getargval("-s", (long *)ps_argv, 1),(struct in_addr *)&server_ip)) goto pusage;
    
    if(!argexists("-p", (long *)ps_argv)) {
	goto pusage;
    } else if (!getargval("-p", (long *)ps_argv, 1)) {
	goto pusage;
    }
    server_port = strtodec(getargval("-p", (long *)ps_argv, 1));
    server_port = htons((u_int16_t)server_port);
    if(!argexists("--user", (long *)ps_argv)) {
	goto pusage;
    } else if (!getargval("--user", (long *)ps_argv, 1)) {
	goto pusage;
    }    
    if(!argexists("--pass", (long *)ps_argv)) {	
	write(1,"Password :",10);
	//off the echo
        ioctl(0, TCGETS, &ti);
	ti.c_lflag &= ~ECHO;
	ioctl(0, TCSETS, &ti);	
	
	  buf1 = malloc(MAXBUFSIZE);
	  read(0,buf1,MAXBUFSIZE);	
	  
	//on the echo
        ioctl(0, TCGETS, &ti);
	ti.c_lflag |= ECHO;
	ioctl(0, TCSETS, &ti);
	printf("\n");
    } else if (!getargval("--pass", (long *)ps_argv, 1)) {
	goto pusage;
    } else {
	buf1 = getargval("--pass", (long *)ps_argv, 1);
    }
    pb = buf1;
    for(;*pb;pb++) {
	if(*pb == '\n') *pb = 0;
    }    
    if((client_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0){
	perror("Error socket(): "); exit(1);
    };
    sock.sin_family = AF_INET;
    sock.sin_port = server_port;
    sock.sin_addr.s_addr = server_ip;
    if(connect(client_socket,&sock,sizeof(struct sockaddr_in)) < 0) {
	perror("Error connect(): "); exit(1);
    };
    buf2 = gen_loginp(getargval("--user", (long *)ps_argv, 1), buf1);
    signal(SIGPIPE,(void *)SIGPIPE_handler);
    socket1 = trafinit("lo",AF_PACKET,SOCK_DGRAM); len = sizeof(struct sockaddr);
    write(client_socket,buf2,(long)*buf2);
    if(recvfrom(socket1,buf2,MAXBUFSIZE,0,(struct sockaddr *)&sock1,(socklen_t *)&len) < 0) {
	perror("ERROR: recvfrom(): "); exit(2);
    }
    get_packet_p(buf2, (struct dpack *) &diff_pack);
    close(socket1);        
    socket1 = trafinit("lo",AF_PACKET,SOCK_RAW);
	buf3 = malloc(MAXBUFSIZE);
	buf4 = buf3;
	buf5 = buf2;
	if(argexists("-d", (long *)ps_argv)) if(fork()) exit(0);
    for(;;) {
	len2 = 0;
	len4 = 0;
	buf3 = buf4;
	buf2 = buf5;
	if((len3 =recvfrom(socket1,buf2,MAXBUFSIZE,0,(struct sockaddr *)&sock1,(socklen_t *)&len)) < 0) {
	    perror("ERROR: recvfrom(): "); exit(2);
	};	
	ifr.ifr_flags = sock1.sll_ifindex;
	if(ioctl(socket1, SIOCGIFNAME, &ifr) < 0) {
	    perror("ERROR: ioctl SIOCGIFNAME : "); exit(1);
	}
	len2 = strlen(ifr.ifr_name) + 1;
	pb = ifr.ifr_name;
	(long *)buf3+=1;
	(char)*buf3 = PTYPE_ENTRY;(char *)buf3++;
	(long)*buf3 = len3; (long *)buf3+=1;
	for(;*pb; pb++, buf3++) *buf3 = *pb; *buf3 = 0; buf3++;
	len2 = sizeof(struct iphdr) + \
		sizeof(struct tcphdr) + \
		    4+1+4+2+1;
	typeh = (short *)buf3;
	*typeh = sock1.sll_hatype; (short *)buf3+=1;
	(char)*buf3 = (char)sock1.sll_pkttype; (char *)buf3++;
	len2 += 50;
	len4 = len2 + 0x50;
	len5 = len4;	
	for(;len4;len4--,(char *)buf3++, (char *)buf2++) (char)*buf3 = \
							    (char)*buf2;
	if(check_packet((short *)&sock1.sll_hatype, buf5, &diff_pack) == 0) {
	    if(write(client_socket,buf4,len5) < 0) {
		perror("Error: write to server: "); exit(1);
	    }
	}
    }
    return 0;
}
int check_packet(short *hatype, char *buffer, struct dpack *pdiff)
{
    struct tcphdr *tcphead;
    struct iphdr *iphead;
    long i;
    buffer +=another_header(hatype, (long *)link_types);
    iphead = (struct iphdr *)buffer;
    if(iphead->protocol != pdiff->proto) return 0;	
    (char *)buffer += sizeof(struct iphdr);
    tcphead = (struct tcphdr *)buffer;
    if(iphead->saddr != pdiff->sip) return 0;	
    if(iphead->daddr != pdiff->dip) return 0;
    if((u_int16_t)tcphead->source != (u_int16_t)pdiff->sp ) goto chk_next;
    if((u_int16_t)tcphead->dest != (u_int16_t)pdiff->dp) return 0;
	return 1;
chk_next:
    if((u_int16_t)tcphead->source != (u_int16_t)pdiff->dp) return 0;
	return 1;
}
int another_header(short *htype, long *link_types)
{
    for(;(long)*link_types;(long *)link_types+=1) {
	if(*link_types == (short)*htype) {
	    (long *)link_types+=1;
	    return *link_types;
	};
	(long *)link_types+=1;
    }
    return 0;
}
void get_packet_p(char *buf, struct dpack *diff_pack)
{
    struct iphdr *iphead;
    struct tcphdr *tcphead;
    
    
    iphead = (struct iphdr *)buf;
    diff_pack->sip = iphead->saddr;
    diff_pack->dip = iphead->daddr;
    diff_pack->proto = iphead->protocol;    
    (char *)iphead += sizeof(struct iphdr);
    tcphead = (struct tcphdr *)iphead;    
    diff_pack->sp = tcphead->source;
    diff_pack->dp = tcphead->dest;
}
int trafinit(char *iface, int domain, int type)
{
    struct ifreq ifr;
    int sock;
    if((sock = socket(domain,type,htons((u_int16_t)ETH_P_ALL)))<0) {
	perror("Error socket(): "); exit(1);
    }
    strcpy(ifr.ifr_name, iface);
    if(ioctl(sock, SIOCGIFFLAGS, &ifr) < 0) {
	perror("ERROR: ioctl SIOCGIFFLAGS : "); exit(1);
    }
    ifr.ifr_flags |= IFF_PROMISC;
    if(ioctl(sock, SIOCSIFFLAGS, &ifr) < 0) {
	perror("ERROR: ioctl SIOCSIFFLAGS : "); exit(1);
    }
    return sock;        
}
void SIGPIPE_handler(void)
{
    printf("ERROR: Server access denied!\n"); exit(1);
}
char *gen_loginp(char *name, char *pass)
{
    char *p, *a;
    unsigned long length;
    
    length = strlen(name); length+=strlen(pass); length +=2+5;        
    p = malloc(MAXBUFSIZE);
    a = p;
    (long)*p = 0;
    (long *)p += 1;
    *p = PTYPE_LOGIN; p++;
    for(;*name;name++,p++) *p = *name; *p = 0;p++;
    for(;*pass;pass++,p++) *p = *pass; *p = 0;
    (long)*a = length;
    return (char *)a;
}
char *getargval(char *arg, long *ps_argv, int num)
{
    long *p, i;
    p = (long *)ps_argv;
    for(;;) {
	if(*p == 0) return 0;	
	if(!strcmp((char *)*p, arg)) {
	    p+=2;
	    for(i = 1; i <= num; i++) p++;
	    return (char *)*p;
	} else p+=2;
	p+=2;
    }    
}
int argexists(char *arg, long *ps_argv)
{
    long *p;
    p = (long *)ps_argv;
    for(;;) {
	if(*p == 0) return 0;	
	if(!strcmp((char *)*p, arg)) {
	    p+=2;
	    if((unsigned long)*p) return 1;
	    return 0;
	} else p+=2;
	p+=2;
    }
}
int getarguments(int count, char *argv_struct[], void *ps_argv)
{
	int argc = getargc(ps_argv), c, a, b;
	char *argv;
	long *p;
	if(count <= 1) return 1;
		
	for(c = 1;c <= count;c++) {
	    argv = findargv(argv_struct[c], ps_argv);
	    if(argv) {
		p = (long *)argv;p++;
		if(*p) {
		    b = *p; p += 1; *p = 1;
		    for(a = 1; a <= b; a++) {
			p++;c++;*p = (long)argv_struct[c];
		    }
		} else {
		    p +=1;*p = 1;
		}
	    }
	}
}
char * findargv(char *argv, long *ps_argv)
{
    for(;;) {
	if(!strcmp(argv,(char *)*ps_argv)) return (char *)ps_argv;
	ps_argv+=4;
	if((unsigned long)*ps_argv == 0) return 0;
    }    
}
int getargc(long *ps_argv)
{
    long c = 0;
    
    for(;;) {
	c++;ps_argv++;
	c+=(unsigned long)*ps_argv;ps_argv+=3;
	if((unsigned long)*ps_argv == 0) break;
    }
    return c;
}
int strcmpt(char *str1, char *str2) {
    int i = strlent(str1);
    if( i != strlent(str2)) return -1;
    for(; i > 0; i--) {
	if(*str1 != *str2) return -1;
	str1++; str2++;
    }
    return 0;
}
void strcpyt(char *to, char *from) {
    for(;*from;to++,from++) *to = *from;
}
void tstrcat(char *tostr, char *str) {
    strcpyt((char *)tozero(tostr), str);
}
unsigned long tozero(char *str) {
    for(;*str;str++);
    return (unsigned long)str;
}
unsigned long strlent(char *str) {
    unsigned long res = 0;
    for(;*str;res++) str++;
    return (res);
}
unsigned long strtodec(char *value) {
    
    unsigned long o = 0;
    for(;*value;value++) {
	o += ((unsigned long)(*value)&0xf); o *=10;
    } o /=10;
    return o;
}
unsigned long chstrdec(char *value, char ch) {
    
    unsigned long o = 0;
    for(;*value;value++) {
	if(*value == ch) return o;
	o += ((unsigned long)(*value)&0xf); o *=10;
    } o /=10;
    return o;
}