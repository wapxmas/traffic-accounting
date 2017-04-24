func_log_file:
    %include	"inc_f/ta.f1.asm"
    ;;;
    ret
func_stat_global:
    %include	"inc_f/ta.f2.asm"
    ;;;
    ret
func_stat_by_dev:
    %include	"inc_f/ta.f3.asm"
    ;;;
    ret
func_stat_by_ip_global:
    %include	"inc_f/ta.f4.asm"
    ;;;
    ret
func_stat_by_ip_dev:
    %include	"inc_f/ta.f5.asm"
    ;;;
    ret
func_deny_ip_global:
    %include	"inc_f/ta.f6.asm"
    ;;;
    ret
func_deny_ip_in_type:
    %include	"inc_f/ta.f7.asm"
    ;;;
    ret
func_deny_ip_in_name:
    %include	"inc_f/ta.f10.asm"
    ;;;
    ret
func_deny_ip_in_dev:
    %include	"inc_f/ta.f8.asm"
    ;;;
    ret
func_deny_dev:
    %include	"inc_f/ta.f9.asm"
    ;;;
    ret
func_time_stamp:
    %include	"inc_f/ta.f11.asm"
    ;;;
    ret
func_log_by_ip:
    %include	"inc_f/ta.f12.asm"
    ;;;
    ret
func_stat_time_on:
    %include	"inc_f/ta.f13.asm"
    ;;;
    ret
func_log_by_each_ip:
    %include	"inc_f/ta.f14.asm"
    ;;;
    ret
func_save_on_time:
    %include	"inc_f/ta.f15.asm"
    ;;;
    ret
func_rs_by_proto_global:
    %include	"inc_f/ta.f16.asm"
    ;;;
    ret

func_al_only_proto_global:
    %include	"inc_f/ta.f17.asm"
    ;;;
    ret
func_rs_by_proto_idev:
    %include	"inc_f/ta.f18.asm"
    ;;;
    ret
func_rs_by_proto_name:
    %include	"inc_f/ta.f19.asm"
    ;;;
    ret
func_al_by_proto_idev:
    %include	"inc_f/ta.f20.asm"
    ;;;
    ret
func_al_by_proto_name:
    %include	"inc_f/ta.f21.asm"
    ;;;
    ret
func_rs_by_port_global:
    %include	"inc_f/ta.f22.asm"
    ;;;
    ret   
func_al_by_port_global:
    %include	"inc_f/ta.f23.asm"
    ;;;
    ret     
func_al_by_port_itype:
    %include	"inc_f/ta.f24.asm"
    ;;;
    ret
func_rs_by_port_itype:
    %include	"inc_f/ta.f25.asm"
    ;;;
    ret    
func_rs_by_proto_itype:
    %include	"inc_f/ta.f26.asm"
    ;;;
    ret        
func_rs_by_port_idev:
    %include	"inc_f/ta.f27.asm"
    ;;;
    ret
func_al_by_port_idev:
    %include	"inc_f/ta.f28.asm"
    ;;;
    ret    
func_al_by_proto_itype:
    %include	"inc_f/ta.f29.asm"
    ;;;
    ret
func_rs_by_port_name:
    %include	"inc_f/ta.f30.asm"
    ;;;
    ret
func_al_by_port_name:
    %include	"inc_f/ta.f31.asm"
    ;;;
    ret    
func_bin_stat_global:
    %include	"inc_f/ta.f32.asm"
    ;;;
    ret
func_bin_stat_by_dev:
    %include	"inc_f/ta.f33.asm"
    ;;;
    ret
func_bin_stat_by_ip_global:
    %include	"inc_f/ta.f34.asm"
    ;;;
    ret
func_bin_stat_by_ip_dev:
    %include	"inc_f/ta.f35.asm"
    ;;;
    ret
func_full_stat_global:
    %include "inc_f/ta.f36.asm"
    ;;;
    ret
func_full_stat_by_dev:
    %include "inc_f/ta.f37.asm"
    ;;;
    ret
func_full_stat_by_ip_global:
    %include "inc_f/ta.f38.asm"
    ;;;
    ret
func_full_stat_by_ip_dev:
    %include "inc_f/ta.f39.asm"
    ;;;
    ret
func_bin_full_stat_global:
    %include "inc_f/ta.f40.asm"
    ;;;
    ret
func_bin_full_stat_by_dev:
    %include "inc_f/ta.f41.asm"
    ;;;
    ret
func_bin_full_stat_by_ip_global:
    %include "inc_f/ta.f42.asm"
    ;;;
    ret
func_bin_full_stat_by_ip_dev:
    %include "inc_f/ta.f43.asm"
    ;;;
    ret
func_priority:
    %include "inc_f/ta.f44.asm"
    ;;;
    ret
func_log_by_port:
    %include "inc_f/ta.f45.asm"
    ;;;
    ret
func_log_by_each_port:
    %include "inc_f/ta.f46.asm"
    ;;;
    ret    
func_log_by_proto:
    %include "inc_f/ta.f47.asm"
    ;;;
    ret
func_log_by_each_proto:
    %include "inc_f/ta.f48.asm"
    ;;;
    ret
func_log_by_port_ip:
    %include "inc_f/ta.f49.asm"
    ;;;
    ret
func_log_by_port_ip_each:
    %include "inc_f/ta.f50.asm"
    ;;;
    ret    
func_log_by_eport_eip:
    %include "inc_f/ta.f51.asm"
    ;;;
    ret
func_log_by_each_ip_local:
    %include "inc_f/ta.f52.asm"
    ;;;
    ret
func_log_by_ip_local:
    %include "inc_f/ta.f53.asm"
    ;;;
    ret
func_deny_ip_ptype_iname:
    %include "inc_f/ta.f54.asm"
    ;;;
    ret
func_log_by_proto_ip:
    %include "inc_f/ta.f55.asm"
    ;;;
    ret
func_log_by_proto_ip_each:
    %include "inc_f/ta.f56.asm"
    ;;;
    ret
func_log_by_eproto_eip:
    %include "inc_f/ta.f57.asm"
    ;;;
    ret
func_ls_by_iface:
    %include "inc_f/ta.f58.asm"
    ;;;
    ret
func_ls_by_each_ip:
    %include "inc_f/ta.f59.asm"
    ;;;
    ret
func_ip_entry_list:
    %include "inc_f/ta.f60.asm"
    ;;;
    ret
func_alo_ip_global:
    %include "inc_f/ta.f61.asm"
    ;;;
    ret
func_alo_ip_in_type:
    %include "inc_f/ta.f62.asm"
    ;;;
    ret
func_alo_ip_in_name:
    %include "inc_f/ta.f63.asm"
    ;;;
    ret
func_alo_ip_in_dev:
    %include "inc_f/ta.f64.asm"
    ;;;
    ret
func_alo_dev:
    %include "inc_f/ta.f65.asm"
    ;;;
    ret
func_alo_ip_ptype_iname:
    %include "inc_f/ta.f66.asm"
    ;;;
    ret
func_ip_range_traf_limit:
    %include "inc_f/ta.f67.asm"
    ;;;
    ret
func_ipe_range_traf_limit:
    %include "inc_f/ta.f68.asm"
    ;;;
    ret    
func_pr_range_limit:
    %include "inc_f/ta.f69.asm"
    ;;;
    ret
func_each_pr_range_limit:
    %include "inc_f/ta.f70.asm"
    ;;;
    ret
func_proto_range_limit:
    %include "inc_f/ta.f71.asm"
    ;;;
    ret
func_proto_each_limit:
    %include "inc_f/ta.f72.asm"
    ;;;
    ret
func_lm_by_port_ip:
    %include "inc_f/ta.f73.asm"
    ;;;
    ret
func_lm_by_port_ip_each:
    %include "inc_f/ta.f74.asm"
    ;;;
    ret
func_lm_by_eport_eip:
    %include "inc_f/ta.f75.asm"
    ;;;
    ret
func_proto_ip_limit:
    %include "inc_f/ta.f76.asm"
    ;;;
    ret
func_proto_ip_each_limit:
    %include "inc_f/ta.f77.asm"
    ;;;
    ret
func_eproto_eip_limit:
    %include "inc_f/ta.f78.asm"
    ;;;
    ret
func_iface_limit:
    %include "inc_f/ta.f79.asm"
    ;;;
    ret
func_ls_by_port_ip_each:
    %include "inc_f/ta.f80.asm"
    ;;;
    ret
func_ls_by_eport_eip:
    %include "inc_f/ta.f81.asm"
    ;;;
    ret
func_ls_by_proto_ip_each:
    %include "inc_f/ta.f82.asm"
    ;;;
    ret
func_ls_by_eproto_eip:
    %include "inc_f/ta.f83.asm"
    ;;;
    ret
func_full_log_by_each_ip:
    %include "inc_f/ta.f84.asm"
    ;;;
    ret
func_ls_full_by_each_ip:
    %include "inc_f/ta.f85.asm"
    ;;;
    ret
func_ls_by_each_ip_local:
    %include "inc_f/ta.f86.asm"
    ;;;
    ret
func_deny_dev_in_name:
    %include "inc_f/ta.f87.asm"
    ;;;
    ret
func_alo_dev_in_name:
    %include "inc_f/ta.f88.asm"
    ;;;
    ret
func_ls_by_ip:
    %include "inc_f/ta.f89.asm"
    ;;;
    ret
func_ls_by_proto_ip:
    %include "inc_f/ta.f90.asm"
    ;;;
    ret
func_ls_by_eproto_ip:
    %include "inc_f/ta.f91.asm"
    ;;;
    ret
func_ls_by_port_ip:
    %include "inc_f/ta.f92.asm"
    ;;;
    ret
func_ls_by_eport_ip:
    %include "inc_f/ta.f93.asm"
    ;;;
    ret
func_null:
    ;;;
    ret
