;;configurations of each function;
    skin_conf:
	db	"ip_skin",0
	    db	MAXPC_IP_SKIN
	    dw	MAXL_IP_SKIN
	    db	MAXC_IP_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	ip_skin_buffer
	    db	TFUNC_NULL
	db	"dev_skin",0
	    db	MAXPC_DEV_SKIN
	    dw	MAXL_DEV_SKIN
	    db	MAXC_DEV_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	dev_skin_buffer
	    db	TFUNC_NULL
	db	"io_skin",0
	    db	MAXPC_IO_SKIN
	    dw	MAXL_IO_SKIN
	    db	MAXC_IO_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	io_skin_buffer
	    db	TFUNC_NULL	    
	db	"head_skin",0
	    db	MAXPC_HEAD_SKIN
	    dw	MAXL_HEAD_SKIN
	    db	MAXC_HEAD_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	head_skin_buffer
	    db	TFUNC_NULL
	db	"end_skin",0
	    db	MAXPC_END_SKIN
	    dw	MAXL_END_SKIN
	    db	MAXC_END_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	end_skin_buffer
	    db	TFUNC_NULL
	db	"table_skin",0
	    db	MAXPC_TABLE_SKIN
	    dw	MAXL_TABLE_SKIN
	    db	MAXC_TABLE_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	table_skin_buffer
	    db	TFUNC_NULL		    
	db	"table_end_skin",0
	    db	MAXPC_TABLE_END_SKIN
	    dw	MAXL_TABLE_END_SKIN
	    db	MAXC_TABLE_END_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	table_end_skin_buffer
	    db	TFUNC_NULL
	db	"trow_skin",0
	    db	MAXPC_TROW_SKIN
	    dw	MAXL_TROW_SKIN
	    db	MAXC_TROW_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	trow_skin_buffer
	    db	TFUNC_NULL
	db	"tcol_skin",0
	    db	MAXPC_TCOL_SKIN
	    dw	MAXL_TCOL_SKIN
	    db	MAXC_TCOL_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	tcol_skin_buffer
	    db	TFUNC_NULL
	db	"end_trow_skin",0
	    db	MAXPC_END_TROW_SKIN
	    dw	MAXL_END_TROW_SKIN
	    db	MAXC_END_TROW_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	end_trow_skin_buffer
	    db	TFUNC_NULL
	db	"end_tcol_skin",0
	    db	MAXPC_END_TCOL_SKIN
	    dw	MAXL_END_TCOL_SKIN
	    db	MAXC_END_TCOL_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	end_tcol_skin_buffer
	    db	TFUNC_NULL	    
	db	"cr_traf_skin",0
	    db	MAXPC_CR_TRAF_SKIN
	    dw	MAXL_CR_TRAF_SKIN
	    db	MAXC_CR_TRAF_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	cr_traf_skin_buffer
	    db	TFUNC_NULL	    
	db	"jt_traf_skin",0
	    db	MAXPC_JT_TRAF_SKIN
	    dw	MAXL_JT_TRAF_SKIN
	    db	MAXC_JT_TRAF_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	jt_traf_skin_buffer
	    db	TFUNC_NULL	    
	db	"port_skin",0
	    db	MAXPC_PORT_SKIN
	    dw	MAXL_PORT_SKIN
	    db	MAXC_PORT_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	port_skin_buffer
	    db	TFUNC_NULL	    
	db	"proto_skin",0
	    db	MAXPC_PROTO_SKIN
	    dw	MAXL_PROTO_SKIN
	    db	MAXC_PROTO_SKIN
	    db	TYPE_RAW
	    dd	func_null
	    dd	proto_skin_buffer
	    db	TFUNC_NULL	    
	db	0
    main_conf:
    .vdev:
	db	"dev",0
	    db	MAXPC_MC_DEV
	    dw	MAXL_MC_DEV
	    db	MAXC_MC_DEV
	    db	TYPE_PATTERN
	    dd	func_null
	    dd	mc_dev_buffer
	    db	TFUNC_NULL
    .vdir:
	db	"dir",0
	    db	MAXPC_MC_DIR
	    dw	MAXL_MC_DIR
	    db	MAXC_MC_DIR
	    db	TYPE_STRING
	    dd	func_null
	    dd	mc_dir_buffer
	    db	TFUNC_NULL
	db	"mlog",0
	    db	MAXPC_MC_MLOG
	    dw	MAXL_MC_MLOG
	    db	MAXC_MC_MLOG
	    db	TYPE_FILE
	    dd	func_null
	    dd	mlogf
	    db	TFUNC_NULL
	db	"spec_ch",0
	    db	MAXPC_MC_SPC
	    dw	MAXL_MC_SPC
	    db	MAXC_MC_SPC
	    db	TYPE_STRING
	    dd	func_null
	    dd	spc_char
	    db	TFUNC_NULL
	db	"server_port",0
	    db	MAXPC_MC_SERVER_PORT
	    dw	MAXL_MC_SERVER_PORT
	    db	MAXC_MC_SERVER_PORT
	    db	TYPE_NUM
	    dd	func_null
	    dd	server_port_buffer
	    db	TFUNC_NULL
	db	"skin_path",0
	    db	MAXPC_MC_SKIN_PATH
	    dw	MAXL_MC_SKIN_PATH
	    db	MAXC_MC_SKIN_PATH
	    db	TYPE_STRING
	    dd	func_null
	    dd	skin_path_buffer
	    db	TFUNC_NULL
	db	0
    strings:
	db	"log_file",0
	    db	MAXPC_LOG_FILE	;max parametres count
	    dw	MAXL_LOG_FILE	;max length of parameter
	    db	MAXC_LOG_FILE	;max count of string
	    db	TYPE_FILE, TYPE_PATTERN, TYPE_STRING;parametres	    
	    dd	func_log_file
	    dd	log_file_buffer
	    db	TFUNC_NORMAL
	db	"stat_global",0
	    db	MAXPC_STAT_GLOBAL	;max parametres count
	    dw	MAXL_STAT_GLOBAL
	    db	MAXC_STAT_GLOBAL
	    db	TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_stat_global
	    dd	stat_global_buffer
	    db	TFUNC_NORMAL
	db	"stat_by_dev",0
	    db	MAXPC_STAT_BY_DEV
	    dw	MAXL_STAT_BY_DEV
	    db	MAXC_STAT_BY_DEV
	    db	TYPE_PATTERN, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_stat_by_dev
	    dd	stat_by_dev_buffer
	    db	TFUNC_NORMAL
	db	"stat_by_ip_global",0
	    db	MAXPC_STAT_BY_IP_GLOBAL
	    dw	MAXL_STAT_BY_IP_GLOBAL
	    db	MAXC_STAT_BY_IP_GLOBAL
	    db	TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_stat_by_ip_global
	    dd	stat_by_ip_global_buffer
	    db	TFUNC_NORMAL
	db	"stat_by_ip_dev",0
	    db	MAXPC_STAT_BY_IP_DEV
	    dw	MAXL_STAT_BY_IP_DEV
	    db	MAXC_STAT_BY_IP_DEV
	    db	TYPE_PATTERN, TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_stat_by_ip_dev
	    dd	stat_by_ip_dev_buffer
	    db	TFUNC_NORMAL
	db	"deny_ip_global",0
	    db	MAXPC_DENY_IP_GLOBAL
	    dw	MAXL_DENY_IP_GLOBAL
	    db	MAXC_DENY_IP_GLOBAL
	    db	TYPE_IP
	    dd	func_deny_ip_global
	    dd	deny_ip_global_buffer
	    db	TFUNC_DENY
	db	"deny_ip_in_type",0
	    db	MAXPC_DENY_IP_IN_TYPE
	    dw	MAXL_DENY_IP_IN_TYPE
	    db	MAXC_DENY_IP_IN_TYPE
	    db	TYPE_PATTERN, TYPE_IP
	    dd	func_deny_ip_in_type
	    dd	deny_ip_in_type_buffer
	    db	TFUNC_DENY
	db	"deny_ip_in_name",0
	    db	MAXPC_DENY_IP_IN_NAME
	    dw	MAXL_DENY_IP_IN_NAME
	    db	MAXC_DENY_IP_IN_NAME
	    db	TYPE_STRING, TYPE_IP
	    dd	func_deny_ip_in_name
	    dd	deny_ip_in_name_buffer
	    db	TFUNC_DENY_BY_NAME
	db	"deny_ip_in_dev",0
	    db	MAXPC_DENY_IP_IN_DEV
	    dw	MAXL_DENY_IP_IN_DEV
	    db	MAXC_DENY_IP_IN_DEV
	    db	TYPE_PATTERN, TYPE_IP
	    dd	func_deny_ip_in_dev
	    dd	deny_ip_in_dev_buffer
	    db	TFUNC_DENY
	db	"deny_dev",0
	    db	MAXPC_DENY_DEV
	    dw	MAXL_DENY_DEV
	    db	MAXC_DENY_DEV
	    db	TYPE_PATTERN
	    dd	func_deny_dev
	    dd	deny_dev_buffer
	    db	TFUNC_DENY
	db	"time_stamp",0
	    db	MAXPC_TIME_STAMP
	    dw	MAXL_TIME_STAMP
	    db	MAXC_TIME_STAMP
	    db	TYPE_STRING
	    dd	func_time_stamp
	    dd	time_stamp_buffer
	    db	TFUNC_INIT
	db	"log_by_ip",0
	    db	MAXPC_LOG_BY_IP
	    dw	MAXL_LOG_BY_IP
	    db	MAXC_LOG_BY_IP
	    db	TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_ip
	    dd	log_by_ip_buffer
	    db	TFUNC_NORMAL
	db	"stat_time_on",0
	    db	MAXPC_STAT_TIME_ON
	    dw	MAXL_STAT_TIME_ON
	    db	MAXC_STAT_TIME_ON
	    db	TYPE_STRING, TYPE_FILE, TYPE_STRING, TYPE_PATTERN
	    dd	func_stat_time_on
	    dd	stat_time_on_buffer
	    db	TFUNC_DENY_BY_NAME
	db	"log_by_each_ip",0
	    db	MAXPC_LOG_BY_EACH_IP
	    dw	MAXL_LOG_BY_EACH_IP
	    db	MAXC_LOG_BY_EACH_IP
	    db	TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_each_ip
	    dd	log_by_each_ip_buffer
	    db	TFUNC_NORMAL	    
	db	"save_on_time",0
	    db	MAXPC_SAVE_ON_TIME
	    dw	MAXL_SAVE_ON_TIME
	    db	MAXC_SAVE_ON_TIME
	    db	TYPE_STRING
	    dd	func_save_on_time
	    dd	save_on_time_buffer
	    db	TFUNC_INIT
	db	"rs_by_proto_global",0
	    db	MAXPC_RS_BY_PROTO_GLOBAL
	    dw	MAXL_RS_BY_PROTO_GLOBAL
	    db	MAXC_RS_BY_PROTO_GLOBAL
	    db	TYPE_SYNUM
	    dd	func_rs_by_proto_global
	    dd	rs_by_proto_global_buffer
	    db	TFUNC_DENY
	db	"al_only_proto_global",0
	    db	MAXPC_AL_ONLY_PROTO_GLOBAL
	    dw	MAXL_AL_ONLY_PROTO_GLOBAL
	    db	MAXC_AL_ONLY_PROTO_GLOBAL
	    db	TYPE_SYNUM
	    dd	func_al_only_proto_global
	    dd	al_only_proto_global_buffer
	    db	TFUNC_DENY	    
	db	"rs_by_proto_idev",0
	    db	MAXPC_RS_BY_PROTO_IDEV
	    dw	MAXL_RS_BY_PROTO_IDEV
	    db	MAXC_RS_BY_PROTO_IDEV
	    db	TYPE_PATTERN, TYPE_SYNUM
	    dd	func_rs_by_proto_idev
	    dd	rs_by_proto_idev_buffer
	    db	TFUNC_DENY	    
	db	"rs_by_proto_name",0
	    db	MAXPC_RS_BY_PROTO_NAME
	    dw	MAXL_RS_BY_PROTO_NAME
	    db	MAXC_RS_BY_PROTO_NAME
	    db	TYPE_STRING, TYPE_SYNUM
	    dd	func_rs_by_proto_name
	    dd	rs_by_proto_name_buffer
	    db	TFUNC_DENY_BY_NAME
	db	"al_by_proto_idev",0
	    db	MAXPC_AL_BY_PROTO_IDEV
	    dw	MAXL_AL_BY_PROTO_IDEV
	    db	MAXC_AL_BY_PROTO_IDEV
	    db	TYPE_PATTERN, TYPE_SYNUM
	    dd	func_al_by_proto_idev
	    dd	al_by_proto_idev_buffer
	    db	TFUNC_DENY
	db	"al_by_proto_name",0
	    db	MAXPC_AL_BY_PROTO_NAME
	    dw	MAXL_AL_BY_PROTO_NAME
	    db	MAXC_AL_BY_PROTO_NAME
	    db	TYPE_STRING, TYPE_SYNUM
	    dd	func_al_by_proto_name
	    dd	al_by_proto_name_buffer
	    db	TFUNC_DENY_BY_NAME
	db	"rs_by_port_global",0
	    db	MAXPC_RS_BY_PORT_GLOBAL
	    dw	MAXL_RS_BY_PORT_GLOBAL
	    db	MAXC_RS_BY_PORT_GLOBAL
	    db	TYPE_NUM, TYPE_PORT
	    dd	func_rs_by_port_global
	    dd	rs_by_port_global_buffer
	    db	TFUNC_DENY
	db	"al_by_port_global",0
	    db	MAXPC_AL_BY_PORT_GLOBAL
	    dw	MAXL_AL_BY_PORT_GLOBAL
	    db	MAXC_AL_BY_PORT_GLOBAL
	    db	TYPE_NUM, TYPE_PORT
	    dd	func_al_by_port_global
	    dd	al_by_port_global_buffer
	    db	TFUNC_DENY	
	db	"al_by_port_itype",0
	    db	MAXPC_AL_BY_PORT_ITYPE
	    dw	MAXL_AL_BY_PORT_ITYPE
	    db	MAXC_AL_BY_PORT_ITYPE
	    db	TYPE_PATTERN, TYPE_NUM, TYPE_PORT
	    dd	func_al_by_port_itype
	    dd	al_by_port_itype_buffer
	    db	TFUNC_DENY	    
	db	"rs_by_port_itype",0
	    db	MAXPC_RS_BY_PORT_ITYPE
	    dw	MAXL_RS_BY_PORT_ITYPE
	    db	MAXC_RS_BY_PORT_ITYPE
	    db	TYPE_PATTERN, TYPE_NUM, TYPE_PORT
	    dd	func_rs_by_port_itype
	    dd	rs_by_port_itype_buffer
	    db	TFUNC_DENY	    
	db	"rs_by_proto_itype",0
	    db	MAXPC_RS_BY_PROTO_ITYPE
	    dw	MAXL_RS_BY_PROTO_ITYPE
	    db	MAXC_RS_BY_PROTO_ITYPE
	    db	TYPE_PATTERN, TYPE_SYNUM
	    dd	func_rs_by_proto_itype
	    dd	rs_by_proto_itype_buffer
	    db	TFUNC_DENY
	db	"rs_by_port_idev",0
	    db	MAXPC_RS_BY_PORT_IDEV
	    dw	MAXL_RS_BY_PORT_IDEV
	    db	MAXC_RS_BY_PORT_IDEV
	    db	TYPE_PATTERN, TYPE_NUM, TYPE_PORT
	    dd	func_rs_by_port_idev
	    dd	rs_by_port_idev_buffer
	    db	TFUNC_DENY	    
	db	"al_by_port_idev",0
	    db	MAXPC_AL_BY_PORT_IDEV
	    dw	MAXL_AL_BY_PORT_IDEV
	    db	MAXC_AL_BY_PORT_IDEV
	    db	TYPE_PATTERN, TYPE_NUM, TYPE_PORT
	    dd	func_al_by_port_idev
	    dd	al_by_port_idev_buffer
	    db	TFUNC_DENY
	db	"al_by_proto_itype",0
	    db	MAXPC_AL_BY_PROTO_ITYPE
	    dw	MAXL_AL_BY_PROTO_ITYPE
	    db	MAXC_AL_BY_PROTO_ITYPE
	    db	TYPE_PATTERN, TYPE_SYNUM
	    dd	func_al_by_proto_itype
	    dd	al_by_proto_itype_buffer
	    db	TFUNC_DENY
	db	"rs_by_port_name",0
	    db	MAXPC_RS_BY_PORT_NAME
	    dw	MAXL_RS_BY_PORT_NAME
	    db	MAXC_RS_BY_PORT_NAME
	    db	TYPE_STRING, TYPE_NUM, TYPE_PORT
	    dd	func_rs_by_port_name
	    dd	rs_by_port_name_buffer
	    db	TFUNC_DENY_BY_NAME	    
	db	"al_by_port_name",0
	    db	MAXPC_AL_BY_PORT_NAME
	    dw	MAXL_AL_BY_PORT_NAME
	    db	MAXC_AL_BY_PORT_NAME
	    db	TYPE_STRING, TYPE_NUM, TYPE_PORT
	    dd	func_al_by_port_name
	    dd	al_by_port_name_buffer
	    db	TFUNC_DENY_BY_NAME	    
	db	"bin_stat_global",0
	    db	MAXPC_BIN_STAT_GLOBAL	;max parametres count
	    dw	MAXL_BIN_STAT_GLOBAL
	    db	MAXC_BIN_STAT_GLOBAL
	    db	TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_bin_stat_global
	    dd	bin_stat_global_buffer
	    db	TFUNC_NORMAL
	db	"bin_stat_by_dev",0
	    db	MAXPC_BIN_STAT_BY_DEV
	    dw	MAXL_BIN_STAT_BY_DEV
	    db	MAXC_BIN_STAT_BY_DEV
	    db	TYPE_PATTERN, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_bin_stat_by_dev
	    dd	bin_stat_by_dev_buffer
	    db	TFUNC_NORMAL
	db	"bin_stat_by_ip_global",0
	    db	MAXPC_BIN_STAT_BY_IP_GLOBAL
	    dw	MAXL_BIN_STAT_BY_IP_GLOBAL
	    db	MAXC_BIN_STAT_BY_IP_GLOBAL
	    db	TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_bin_stat_by_ip_global
	    dd	bin_stat_by_ip_global_buffer
	    db	TFUNC_NORMAL	    
	db	"bin_stat_by_ip_dev",0
	    db	MAXPC_BIN_STAT_BY_IP_DEV
	    dw	MAXL_BIN_STAT_BY_IP_DEV
	    db	MAXC_BIN_STAT_BY_IP_DEV
	    db	TYPE_PATTERN, TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_bin_stat_by_ip_dev
	    dd	bin_stat_by_ip_dev_buffer
	    db	TFUNC_NORMAL	    
	db	"full_stat_global",0
	    db	MAXPC_FULL_STAT_GLOBAL
	    dw	MAXL_FULL_STAT_GLOBAL
	    db	MAXC_FULL_STAT_GLOBAL
	    db	TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_full_stat_global
	    dd	full_stat_global_buffer
	    db	TFUNC_NORMAL
	db	"full_stat_by_dev",0
	    db	MAXPC_FULL_STAT_BY_DEV
	    dw	MAXL_FULL_STAT_BY_DEV
	    db	MAXC_FULL_STAT_BY_DEV
	    db	TYPE_PATTERN, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_full_stat_by_dev
	    dd	full_stat_by_dev_buffer
	    db	TFUNC_NORMAL
	db	"full_stat_by_ip_global",0
	    db	MAXPC_FULL_STAT_BY_IP_GLOBAL
	    dw	MAXL_FULL_STAT_BY_IP_GLOBAL
	    db	MAXC_FULL_STAT_BY_IP_GLOBAL
	    db	TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_full_stat_by_ip_global
	    dd	full_stat_by_ip_global_buffer
	    db	TFUNC_NORMAL
	db	"full_stat_by_ip_dev",0
	    db	MAXPC_FULL_STAT_BY_IP_DEV
	    dw	MAXL_FULL_STAT_BY_IP_DEV
	    db	MAXC_FULL_STAT_BY_IP_DEV
	    db	TYPE_PATTERN, TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_full_stat_by_ip_dev
	    dd	full_stat_by_ip_dev_buffer
	    db	TFUNC_NORMAL
	db	"bin_full_stat_global",0
	    db	MAXPC_BIN_FULL_STAT_GLOBAL
	    dw	MAXL_BIN_FULL_STAT_GLOBAL
	    db	MAXC_BIN_FULL_STAT_GLOBAL
	    db	TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_bin_full_stat_global
	    dd	bin_full_stat_global_buffer
	    db	TFUNC_NORMAL
	db	"bin_full_stat_by_dev",0
	    db	MAXPC_BIN_FULL_STAT_BY_DEV
	    dw	MAXL_BIN_FULL_STAT_BY_DEV
	    db	MAXC_BIN_FULL_STAT_BY_DEV
	    db	TYPE_PATTERN, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_bin_full_stat_by_dev
	    dd	bin_full_stat_by_dev_buffer
	    db	TFUNC_NORMAL	    
	db	"bin_full_stat_by_ip_global",0
	    db	MAXPC_BIN_FULL_STAT_BY_IP_GLOBAL
	    dw	MAXL_BIN_FULL_STAT_BY_IP_GLOBAL
	    db	MAXC_BIN_FULL_STAT_BY_IP_GLOBAL
	    db	TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_bin_full_stat_by_ip_global
	    dd	bin_full_stat_by_ip_global_buffer
	    db	TFUNC_NORMAL	    
	db	"bin_full_stat_by_ip_dev",0
	    db	MAXPC_BIN_FULL_STAT_BY_IP_DEV
	    dw	MAXL_BIN_FULL_STAT_BY_IP_DEV
	    db	MAXC_BIN_FULL_STAT_BY_IP_DEV
	    db	TYPE_PATTERN, TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_bin_full_stat_by_ip_dev
	    dd	bin_full_stat_by_ip_dev_buffer
	    db	TFUNC_NORMAL	    
	db	"priority",0
	    db	MAXPC_PRIORITY
	    dw	MAXL_PRIORITY
	    db	MAXC_PRIORITY
	    db	TYPE_STRING
	    dd	func_priority
	    dd	priority_buffer
	    db	TFUNC_INIT
	db	"log_by_port",0
	    db	MAXPC_LOG_BY_PORT
	    dw	MAXL_LOG_BY_PORT
	    db	MAXC_LOG_BY_PORT
	    db	TYPE_NUM, TYPE_PORT, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_port
	    dd	log_by_port_buffer
	    db	TFUNC_NORMAL	    
	db	"log_by_each_port",0
	    db	MAXPC_LOG_BY_EACH_PORT
	    dw	MAXL_LOG_BY_EACH_PORT
	    db	MAXC_LOG_BY_EACH_PORT
	    db	TYPE_NUM, TYPE_PORT, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_each_port
	    dd	log_by_each_port_buffer
	    db	TFUNC_NORMAL
	db	"log_by_proto",0
	    db	MAXPC_LOG_BY_PROTO
	    dw	MAXL_LOG_BY_PROTO
	    db	MAXC_LOG_BY_PROTO
	    db	TYPE_SYNUM, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_proto
	    dd	log_by_proto_buffer
	    db	TFUNC_NORMAL
	db	"log_by_each_proto",0
	    db	MAXPC_LOG_BY_EACH_PROTO
	    dw	MAXL_LOG_BY_EACH_PROTO
	    db	MAXC_LOG_BY_EACH_PROTO
	    db	TYPE_SYNUM, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_each_proto
	    dd	log_by_each_proto_buffer
	    db	TFUNC_NORMAL
	db	"log_by_port_ip",0
	    db	MAXPC_LOG_BY_PORT_IP
	    dw	MAXL_LOG_BY_PORT_IP
	    db	MAXC_LOG_BY_PORT_IP
	    db	TYPE_NUM, TYPE_IP, TYPE_PORT, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_port_ip
	    dd	log_by_port_ip_buffer
	    db	TFUNC_NORMAL	    
	db	"log_by_port_ip_each",0
	    db	MAXPC_LOG_BY_PORT_IP_EACH
	    dw	MAXL_LOG_BY_PORT_IP_EACH
	    db	MAXC_LOG_BY_PORT_IP_EACH
	    db	TYPE_NUM, TYPE_IP, TYPE_PORT, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_port_ip_each
	    dd	log_by_port_ip_each_buffer
	    db	TFUNC_NORMAL	    
	db	"log_by_eport_eip",0
	    db	MAXPC_LOG_BY_EPORT_EIP
	    dw	MAXL_LOG_BY_EPORT_EIP
	    db	MAXC_LOG_BY_EPORT_EIP
	    db	TYPE_NUM, TYPE_IP, TYPE_PORT, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_eport_eip
	    dd	log_by_eport_eip_buffer
	    db	TFUNC_NORMAL	    
	db	"log_by_each_ip_local",0
	    db	MAXPC_LOG_BY_EACH_IP_LOCAL
	    dw	MAXL_LOG_BY_EACH_IP_LOCAL
	    db	MAXC_LOG_BY_EACH_IP_LOCAL
	    db	TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_each_ip_local
	    dd	log_by_each_ip_local_buffer
	    db	TFUNC_NORMAL
	db	"log_by_ip_local",0
	    db	MAXPC_LOG_BY_IP_LOCAL
	    dw	MAXL_LOG_BY_IP_LOCAL
	    db	MAXC_LOG_BY_IP_LOCAL
	    db	TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_ip_local
	    dd	log_by_ip_local_buffer
	    db	TFUNC_NORMAL
	db	"deny_ip_ptype_iname",0
	    db	MAXPC_DENY_IP_PTYPE_IN
	    dw	MAXL_DENY_IP_PTYPE_IN
	    db	MAXC_DENY_IP_PTYPE_IN
	    db	TYPE_STRING, TYPE_IP, TYPE_PATTERN
	    dd	func_deny_ip_ptype_iname
	    dd	deny_ip_ptype_iname_buffer
	    db	TFUNC_DENY_BY_NAME
	db	"log_by_proto_ip",0
	    db	MAXPC_LOG_BY_PROTO_IP
	    dw	MAXL_LOG_BY_PROTO_IP
	    db	MAXC_LOG_BY_PROTO_IP
	    db	TYPE_IP, TYPE_SYNUM, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_proto_ip
	    dd	log_by_proto_ip_buffer
	    db	TFUNC_NORMAL	    
	db	"log_by_proto_ip_each",0
	    db	MAXPC_LOG_BY_PROTO_IP_EACH
	    dw	MAXL_LOG_BY_PROTO_IP_EACH
	    db	MAXC_LOG_BY_PROTO_IP_EACH
	    db	TYPE_IP, TYPE_SYNUM, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_proto_ip_each
	    dd	log_by_proto_ip_each_buffer
	    db	TFUNC_NORMAL
	db	"log_by_eproto_eip",0
	    db	MAXPC_LOG_BY_EPROTO_EIP
	    dw	MAXL_LOG_BY_EPROTO_EIP
	    db	MAXC_LOG_BY_EPROTO_EIP
	    db	TYPE_IP, TYPE_SYNUM, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_log_by_eproto_eip
	    dd	log_by_eproto_eip_buffer
	    db	TFUNC_NORMAL	    
	db	"ls_by_iface",0
	    db	MAXPC_LS_BY_IFACE
	    dw	MAXL_LS_BY_IFACE
	    db	MAXC_LS_BY_IFACE
	    db	TYPE_STRING, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_iface
	    dd	ls_by_iface_buffer
	    db	TFUNC_NORMAL
	db	"ls_by_each_ip",0
	    db	MAXPC_LS_BY_EACH_IP
	    dw	MAXL_LS_BY_EACH_IP
	    db	MAXC_LS_BY_EACH_IP
	    db	TYPE_STRING, TYPE_IP, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_each_ip
	    dd	ls_by_each_ip_buffer
	    db	TFUNC_NORMAL
	db	"ip_entry_list",0
	    db	MAXPC_IP_ENTRY_LIST
	    dw	MAXL_IP_ENTRY_LIST
	    db	MAXC_IP_ENTRY_LIST
	    db	TYPE_NUM, TYPE_FILE
	    dd	func_ip_entry_list
	    dd	ip_entry_list_buffer
	    db	TFUNC_NORMAL
	db	"alo_ip_global",0
	    db	MAXPC_ALO_IP_GLOBAL
	    dw	MAXL_ALO_IP_GLOBAL
	    db	MAXC_ALO_IP_GLOBAL
	    db	TYPE_IP
	    dd	func_alo_ip_global
	    dd	alo_ip_global_buffer
	    db	TFUNC_DENY
	db	"alo_ip_in_type",0
	    db	MAXPC_ALO_IP_IN_TYPE
	    dw	MAXL_ALO_IP_IN_TYPE
	    db	MAXC_ALO_IP_IN_TYPE
	    db	TYPE_PATTERN, TYPE_IP
	    dd	func_alo_ip_in_type
	    dd	alo_ip_in_type_buffer
	    db	TFUNC_DENY
	db	"alo_ip_in_name",0
	    db	MAXPC_ALO_IP_IN_NAME
	    dw	MAXL_ALO_IP_IN_NAME
	    db	MAXC_ALO_IP_IN_NAME
	    db	TYPE_STRING, TYPE_IP
	    dd	func_alo_ip_in_name
	    dd	alo_ip_in_name_buffer
	    db	TFUNC_DENY_BY_NAME
	db	"alo_ip_in_dev",0
	    db	MAXPC_ALO_IP_IN_DEV
	    dw	MAXL_ALO_IP_IN_DEV
	    db	MAXC_ALO_IP_IN_DEV
	    db	TYPE_PATTERN, TYPE_IP
	    dd	func_alo_ip_in_dev
	    dd	alo_ip_in_dev_buffer
	    db	TFUNC_DENY
	db	"alo_dev",0
	    db	MAXPC_ALO_DEV
	    dw	MAXL_ALO_DEV
	    db	MAXC_ALO_DEV
	    db	TYPE_PATTERN
	    dd	func_alo_dev
	    dd	alo_dev_buffer
	    db	TFUNC_DENY
	db	"alo_ip_ptype_iname",0
	    db	MAXPC_ALO_IP_PTYPE_IN
	    dw	MAXL_ALO_IP_PTYPE_IN
	    db	MAXC_ALO_IP_PTYPE_IN
	    db	TYPE_STRING, TYPE_IP, TYPE_PATTERN
	    dd	func_alo_ip_ptype_iname
	    dd	alo_ip_ptype_iname_buffer
	    db	TFUNC_DENY_BY_NAME	    	    
	db	"ip_range_traf_limit",0
	    db	MAXPC_IP_RANGE_TL
	    dw	MAXL_IP_RANGE_TL
	    db	MAXC_IP_RANGE_TL
	    db	TYPE_TLIMIT, TYPE_IP, TYPE_RAW, TYPE_STRING
	    dd	func_ip_range_traf_limit
	    dd	ip_range_traf_limit_buffer
	    db	TFUNC_NORMAL
	db	"ip_each_traf_limit",0
	    db	MAXPC_IPE_RANGE_TL
	    dw	MAXL_IPE_RANGE_TL
	    db	MAXC_IPE_RANGE_TL
	    db	TYPE_TLIMIT, TYPE_IP, TYPE_RAW, TYPE_STRING
	    dd	func_ipe_range_traf_limit
	    dd	ipe_range_traf_limit_buffer
	    db	TFUNC_NORMAL
	db	"port_range_limit",0
	    db	MAXPC_PR_RANGE_TL
	    dw	MAXL_PR_RANGE_TL
	    db	MAXC_PR_RANGE_TL
	    db	TYPE_TLIMIT, TYPE_NUM, TYPE_PORT, TYPE_RAW, TYPE_STRING
	    dd	func_pr_range_limit
	    dd	pr_range_limit_buffer
	    db	TFUNC_NORMAL
	db	"each_port_limit",0
	    db	MAXPC_EACH_PR_RANGE_TL
	    dw	MAXL_EACH_PR_RANGE_TL
	    db	MAXC_EACH_PR_RANGE_TL
	    db	TYPE_TLIMIT, TYPE_NUM, TYPE_PORT, TYPE_RAW, TYPE_STRING
	    dd	func_each_pr_range_limit
	    dd	each_pr_range_limit_buffer
	    db	TFUNC_NORMAL	    
	db	"proto_range_limit",0
	    db	MAXPC_PROTO_RANGE_TL
	    dw	MAXL_PROTO_RANGE_TL
	    db	MAXC_PROTO_RANGE_TL
	    db	TYPE_TLIMIT, TYPE_SYNUM, TYPE_RAW, TYPE_STRING
	    dd	func_proto_range_limit
	    dd	proto_range_limit_buffer
	    db	TFUNC_NORMAL	    
	db	"proto_each_limit",0
	    db	MAXPC_PROTO_EACH_TL
	    dw	MAXL_PROTO_EACH_TL
	    db	MAXC_PROTO_EACH_TL
	    db	TYPE_TLIMIT, TYPE_SYNUM, TYPE_RAW, TYPE_STRING
	    dd	func_proto_each_limit
	    dd	proto_each_limit_buffer
	    db	TFUNC_NORMAL
	db	"port_ip_limit",0
	    db	MAXPC_LM_BY_PORT_IP
	    dw	MAXL_LM_BY_PORT_IP
	    db	MAXC_LM_BY_PORT_IP
	    db	TYPE_TLIMIT, TYPE_NUM, TYPE_IP, TYPE_PORT, TYPE_RAW, TYPE_STRING
	    dd	func_lm_by_port_ip
	    dd	lm_by_port_ip_buffer
	    db	TFUNC_NORMAL
	db	"port_ip_each_limit",0
	    db	MAXPC_LM_BY_PORT_IP_EACH
	    dw	MAXL_LM_BY_PORT_IP_EACH
	    db	MAXC_LM_BY_PORT_IP_EACH
	    db	TYPE_TLIMIT, TYPE_NUM, TYPE_IP, TYPE_PORT, TYPE_RAW, TYPE_STRING
	    dd	func_lm_by_port_ip_each
	    dd	lm_by_port_ip_each_buffer
	    db	TFUNC_NORMAL	    
	db	"eport_eip_limit",0
	    db	MAXPC_LM_BY_EPORT_EIP
	    dw	MAXL_LM_BY_EPORT_EIP
	    db	MAXC_LM_BY_EPORT_EIP
	    db	TYPE_TLIMIT, TYPE_NUM, TYPE_IP, TYPE_PORT, TYPE_RAW, TYPE_STRING
	    dd	func_lm_by_eport_eip
	    dd	lm_by_eport_eip_buffer
	    db	TFUNC_NORMAL
	db	"proto_ip_limit",0
	    db	MAXPC_PROTO_IP_TL
	    dw	MAXL_PROTO_IP_TL
	    db	MAXC_PROTO_IP_TL
	    db	TYPE_TLIMIT, TYPE_IP, TYPE_SYNUM, TYPE_RAW, TYPE_STRING
	    dd	func_proto_ip_limit
	    dd	proto_ip_limit_buffer
	    db	TFUNC_NORMAL
	db	"proto_ip_each_limit",0
	    db	MAXPC_PROTO_IP_EACH_TL
	    dw	MAXL_PROTO_IP_EACH_TL
	    db	MAXC_PROTO_IP_EACH_TL
	    db	TYPE_TLIMIT, TYPE_IP, TYPE_SYNUM, TYPE_RAW, TYPE_STRING
	    dd	func_proto_ip_each_limit
	    dd	proto_ip_each_limit_buffer
	    db	TFUNC_NORMAL
	db	"eproto_eip_limit",0
	    db	MAXPC_EPROTO_EIP_TL
	    dw	MAXL_EPROTO_EIP_TL
	    db	MAXC_EPROTO_EIP_TL
	    db	TYPE_TLIMIT, TYPE_IP, TYPE_SYNUM, TYPE_RAW, TYPE_STRING
	    dd	func_eproto_eip_limit
	    dd	eproto_eip_limit_buffer
	    db	TFUNC_NORMAL	    
	db	"iface_limit",0
	    db	MAXPC_IFACE_TL
	    dw	MAXL_IFACE_TL
	    db	MAXC_IFACE_TL
	    db	TYPE_TLIMIT, TYPE_PATTERN, TYPE_RAW, TYPE_STRING
	    dd	func_iface_limit
	    dd	iface_limit_buffer
	    db	TFUNC_NORMAL	    
	db	"ls_by_port_ip_each",0
	    db	MAXPC_LS_BY_PORT_EIP
	    dw	MAXL_LS_BY_PORT_EIP
	    db	MAXC_LS_BY_PORT_EIP
	    db	TYPE_STRING, TYPE_NUM, TYPE_IP, TYPE_PORT, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_port_ip_each
	    dd	ls_by_port_ip_each_buffer
	    db	TFUNC_NORMAL	    
	db	"ls_by_eport_eip",0
	    db	MAXPC_LS_BY_EPORT_EIP
	    dw	MAXL_LS_BY_EPORT_EIP
	    db	MAXC_LS_BY_EPORT_EIP
	    db	TYPE_STRING, TYPE_NUM, TYPE_IP, TYPE_PORT, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_eport_eip
	    dd	ls_by_eport_eip_buffer
	    db	TFUNC_NORMAL	    
	db	"ls_by_proto_ip_each",0
	    db	MAXPC_LS_BY_PROTO_EIP
	    dw	MAXL_LS_BY_PROTO_EIP
	    db	MAXC_LS_BY_PROTO_EIP
	    db	TYPE_STRING, TYPE_IP, TYPE_SYNUM, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_proto_ip_each
	    dd	ls_by_proto_ip_each_buffer
	    db	TFUNC_NORMAL
	db	"ls_by_eproto_eip",0
	    db	MAXPC_LS_BY_EPROTO_EIP
	    dw	MAXL_LS_BY_EPROTO_EIP
	    db	MAXC_LS_BY_EPROTO_EIP
	    db	TYPE_STRING, TYPE_IP, TYPE_SYNUM, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_eproto_eip
	    dd	ls_by_eproto_eip_buffer
	    db	TFUNC_NORMAL	    
	db	"full_log_by_each_ip",0
	    db	MAXPC_FULL_LOG_BY_EACH_IP
	    dw	MAXL_FULL_LOG_BY_EACH_IP
	    db	MAXC_FULL_LOG_BY_EACH_IP
	    db	TYPE_IP, TYPE_FILE, TYPE_PATTERN, TYPE_STRING
	    dd	func_full_log_by_each_ip
	    dd	full_log_by_each_ip_buffer
	    db	TFUNC_NORMAL	    
	db	"ls_full_by_each_ip",0
	    db	MAXPC_LS_FULL_BY_EACH_IP
	    dw	MAXL_LS_FULL_BY_EACH_IP
	    db	MAXC_LS_FULL_BY_EACH_IP
	    db	TYPE_STRING, TYPE_IP, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_full_by_each_ip
	    dd	ls_full_by_each_ip_buffer
	    db	TFUNC_NORMAL
	db	"ls_by_each_ip_local",0
	    db	MAXPC_LS_BY_EACH_IP_LOCAL
	    dw	MAXL_LS_BY_EACH_IP_LOCAL
	    db	MAXC_LS_BY_EACH_IP_LOCAL
	    db	TYPE_STRING, TYPE_IP, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_each_ip_local
	    dd	ls_by_each_ip_local_buffer
	    db	TFUNC_NORMAL
	db	"deny_dev_in_name",0
	    db	MAXPC_DENY_DEV_IN_NAME
	    dw	MAXL_DENY_DEV_IN_NAME
	    db	MAXC_DENY_DEV_IN_NAME
	    db	TYPE_STRING, TYPE_PATTERN
	    dd	func_deny_dev_in_name
	    dd	deny_dev_in_name_buffer
	    db	TFUNC_DENY_BY_NAME	    	    
	db	"alo_dev_in_name",0
	    db	MAXPC_ALO_DEV_IN_NAME
	    dw	MAXL_ALO_DEV_IN_NAME
	    db	MAXC_ALO_DEV_IN_NAME
	    db	TYPE_STRING, TYPE_PATTERN
	    dd	func_alo_dev_in_name
	    dd	alo_dev_in_name_buffer
	    db	TFUNC_DENY_BY_NAME
	db	"ls_by_ip",0
	    db	MAXPC_LS_BY_IP
	    dw	MAXL_LS_BY_IP
	    db	MAXC_LS_BY_IP
	    db	TYPE_STRING, TYPE_IP, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_ip
	    dd	ls_by_ip_buffer
	    db	TFUNC_NORMAL
	db	"ls_by_proto_ip",0
	    db	MAXPC_LS_BY_PROTO_IP
	    dw	MAXL_LS_BY_PROTO_IP
	    db	MAXC_LS_BY_PROTO_IP
	    db	TYPE_STRING, TYPE_IP, TYPE_SYNUM, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_proto_ip
	    dd	ls_by_proto_ip_buffer
	    db	TFUNC_NORMAL	    
	db	"ls_by_eproto_ip",0
	    db	MAXPC_LS_BY_EPROTO_IP
	    dw	MAXL_LS_BY_EPROTO_IP
	    db	MAXC_LS_BY_EPROTO_IP
	    db	TYPE_STRING, TYPE_IP, TYPE_SYNUM, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_eproto_ip
	    dd	ls_by_eproto_ip_buffer
	    db	TFUNC_NORMAL	    
	db	"ls_by_port_ip",0
	    db	MAXPC_LS_BY_PORT_IP
	    dw	MAXL_LS_BY_PORT_IP
	    db	MAXC_LS_BY_PORT_IP
	    db	TYPE_STRING, TYPE_NUM, TYPE_IP, TYPE_PORT, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_port_ip
	    dd	ls_by_port_ip_buffer
	    db	TFUNC_NORMAL
	db	"ls_by_eport_ip",0
	    db	MAXPC_LS_BY_EPORT_IP
	    dw	MAXL_LS_BY_EPORT_IP
	    db	MAXC_LS_BY_EPORT_IP
	    db	TYPE_STRING, TYPE_NUM, TYPE_IP, TYPE_PORT, TYPE_STRING, TYPE_PATTERN, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	    dd	func_ls_by_eport_ip
	    dd	ls_by_eport_ip_buffer
	    db	TFUNC_NORMAL	    	    
	db	0

;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>