all: ta tuseradd tsclientASM tsclientC tmlogASM cutdb

ta: ta.asm inc/socket.h inc/others.h inc/protos.h inc/server.h inc/md5.h \
   inc/rc6.h inc_f/macro.asm inc_f/ta.srv.asm inc_f/ta.ad.asm \
   inc_f/ta.funcs.asm inc_f/ta.f1.asm inc_f/ta.f2.asm inc_f/ta.f3.asm \
   inc_f/ta.f4.asm inc_f/ta.f5.asm inc_f/ta.f6.asm inc_f/ta.f7.asm \
   inc_f/ta.f10.asm inc_f/ta.f8.asm inc_f/ta.f9.asm inc_f/ta.f11.asm \
   inc_f/ta.f12.asm inc_f/ta.f13.asm inc_f/ta.f14.asm inc_f/ta.f15.asm \
   inc_f/ta.f16.asm inc_f/ta.f17.asm inc_f/ta.f18.asm inc_f/ta.f19.asm \
   inc_f/ta.f20.asm inc_f/ta.f21.asm inc_f/ta.f22.asm inc_f/ta.f23.asm \
   inc_f/ta.f24.asm inc_f/ta.f25.asm inc_f/ta.f26.asm inc_f/ta.f27.asm \
   inc_f/ta.f28.asm inc_f/ta.f29.asm inc_f/ta.f30.asm inc_f/ta.f31.asm \
   inc_f/ta.f32.asm inc_f/ta.f33.asm inc_f/ta.f34.asm inc_f/ta.f35.asm \
   inc_f/ta.f36.asm inc_f/ta.f37.asm inc_f/ta.f38.asm inc_f/ta.f39.asm \
   inc_f/ta.f40.asm inc_f/ta.f41.asm inc_f/ta.f42.asm inc_f/ta.f43.asm \
   inc_f/ta.f44.asm inc_f/ta.f45.asm inc_f/ta.f46.asm inc_f/ta.f47.asm \
   inc_f/ta.f48.asm inc_f/ta.f49.asm inc_f/ta.f50.asm inc_f/ta.f51.asm \
   inc_f/ta.f52.asm inc_f/ta.f53.asm inc_f/ta.f54.asm inc_f/ta.f55.asm \
   inc_f/ta.f56.asm inc_f/ta.f57.asm inc_f/ta.f58.asm inc_f/ta.f59.asm \
   inc_f/ta.f60.asm inc_f/md5.f.asm inc_f/rc6.f.asm inc_f/errors.asm \
   inc_f/srverr.asm inc_f/ta.mdata.asm inc_f/ta.fL.asm inc_f/ta.fb.asm \
   inc_f/ta.bdata.asm

	nasm ta.asm && chmod a+x ta
tmlogASM:
	nasm tools/tmlog/asm/tmlog.asm && chmod a+x tools/tmlog/asm/tmlog
tuseradd: tools/tuseradd/tuseradd.asm inc/md5.h inc/rc6.h inc/term.h inc/others.h \
    inc_f/md5.f.asm inc_f/rc6.f.asm    
	nasm tools/tuseradd/tuseradd.asm && chmod a+x tools/tuseradd/tuseradd

tsclientASM: tools/tsclient/asm/tsclient.asm inc/socket.h inc/server.h inc/protos.h \
    inc/client.h        
	nasm tools/tsclient/asm/tsclient.asm && chmod a+x tools/tsclient/asm/tsclient

tsclientC:
	gcc -O3 -s tools/tsclient/C/tsclient.c -o tools/tsclient/C/tsclient

cutdb:
	nasm tools/cutdb/cutdb.asm && chmod a+x tools/cutdb/cutdb

clean:
	rm -f ta tools/tuseradd/tuseradd tools/tsclient/asm/tsclient \
	tools/tsclient/C/tsclient tools/tmlog/asm/tmlog

#Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>