;;func_time_stamp;
	cmp byte[time_stamp_buffer+5],'y'
	jnz	.nx
	setz	byte[use_time_stamp]
    .nx:
	;;;
        ret
	
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	