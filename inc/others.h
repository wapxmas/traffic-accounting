%define	PRIO_MIN	(-20)
%define	PRIO_MAX	20

%define	PRIO_PROCESS	0
%define	PRIO_PGRP	1
%define	PRIO_USER	2

%define F_DUPFD		0	;/* dup */
%define F_GETFD		1	;/* get close_on_exec */
%define F_SETFD		2	;/* set/clear close_on_exec */
%define F_GETFL		3	;/* get file->f_flags */
%define F_SETFL		4	;/* set file->f_flags */
%define F_GETLK		5
%define F_SETLK		6
%define F_SETLKW	7

%define F_SETOWN	8	;/*  for sockets. */
%define F_GETOWN	9	;/*  for sockets. */
%define F_SETSIG	10	;/*  for sockets. */
%define F_GETSIG	11	;/*  for sockets. */

%define F_GETLK64	12	;/*  using 'struct flock64' */
%define F_SETLK64	13
%define F_SETLKW64	14

%assign ITIMER_REAL	0
%assign ITIMER_VIRTUAL	1
%assign ITIMER_PROF	2

%assign	SIGHUP		1	; Hangup (POSIX)
%assign	SIGINT		2	; Interrupt (ANSI)
%assign	SIGQUIT		3	; Quit (POSIX)
%assign	SIGILL		4	; Illegal instruction (ANSI)
%assign	SIGTRAP		5	; Trace trap (POSIX)
%assign	SIGABRT		6	; Abort (ANSI)
%assign	SIGIOT		6	; IOT trap (4.2 BSD)
%assign	SIGBUS		7	; BUS error (4.2 BSD)
%assign	SIGFPE		8	; Floating-point exception (ANSI)
%assign	SIGKILL		9	; Kill, unblockable (POSIX)
%assign	SIGUSR1		10	; User-defined signal 1 (POSIX)
%assign	SIGSEGV		11	; Segmentation violation (ANSI)
%assign	SIGUSR2		12	; User-defined signal 2 (POSIX)
%assign	SIGPIPE		13	; Broken pipe (POSIX)
%assign	SIGALRM		14	; Alarm clock (POSIX)
%assign	SIGTERM		15	; Termination (ANSI)
%assign	SIGSTKFLT	16	; Stack fault
%assign	SIGCHLD		17	; Child status has changed (POSIX)
%assign	SIGCLD		SIGCHLD	; Same as SIGCHLD (System V)
%assign	SIGCONT		18	; Continue (POSIX)
%assign	SIGSTOP		19	; Stop, unblockable (POSIX)
%assign	SIGTSTP		20	; Keyboard stop (POSIX)
%assign	SIGTTIN		21	; Background read from tty (POSIX)
%assign	SIGTTOU		22	; Background write to tty (POSIX)
%assign	SIGURG		23	; Urgent condition on socket (4.2 BSD)
%assign	SIGXCPU		24	; CPU limit exceeded (4.2 BSD)
%assign	SIGXFSZ		25	; File size limit exceeded (4.2 BSD)
%assign	SIGVTALRM	26	; Virtual alarm clock (4.2 BSD)
%assign	SIGPROF		27	; Profiling alarm clock (4.2 BSD)
%assign	SIGWINCH	28	; Window size change (4.3 BSD, Sun)
%assign	SIGIO		29	; I/O now possible (4.2 BSD)
%assign	SIGPOLL		SIGIO	; Pollable event occurred (System V)
%assign	SIGPWR		30	; Power failure restart (System V)
%assign SIGUNUSED	31
%assign	_NSIG		64	; Biggest signal number + 1
