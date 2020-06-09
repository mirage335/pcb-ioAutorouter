##### Core

_pcb-ioAutorouter() {
	
	"$scriptLib"/pcb/src/pcb "$@"
	return
}


_test_build-app_pcb() {
	_wantGetDep /usr/include/glib-2.0/glib.h
	_wantGetDep glib-2.0/glib.h
	
	_wantGetDep /usr/include/gtk-2.0/gdk/gdk.h
	_wantGetDep gtk-2.0/gdk/gdk.h
	
	_wantGetDep /usr/include/gtkglext-1.0/gdk/gdkgl.h
	_wantGetDep gtkglext-1.0/gdk/gdkgl.h
	
	_wantGetDep /usr/include/Mrm/MrmPublic.h
	_wantGetDep Mrm/MrmPublic.h
	_wantGetDep /usr/include/Xm/Xm.h
	_wantGetDep Xm/Xm.h
	_wantGetDep /usr/include/uil/Uil.h
	_wantGetDep uil/Uil.h
	
	_wantGetDep /usr/include/gd.h
	_wantGetDep gd.h
	
	
	_wantGetDep flex
	_wantGetDep flex++
	
	_wantGetDep bison
	
	_wantGetDep /usr/lib/x86_64-linux-gnu/liby.a
	_wantGetDep liby.a
	
	
	
	# Needed by fungw .
	
	# CAUTION: Version 1.0.1 is delcared 'too old' by 'pcb-rnd' project.
	#_wantGetDep /usr/include/genht/ht.h
	#_wantGetDep genht/ht.h
	#_wantDep /usr/include/genht/ht.h && _messagePlain_request 'request: ensure libgenht is newer than 1.0.1'
	#_wantDep genht/ht.h && _messagePlain_request 'request: ensure libgenht is newer than 1.0.1'
	
	# CAUTION: "At the moment libmawk must be installed as root into /usr"... (pcb-rnd project)
	_wantGetDep /usr/include/libmawk.h
	#_wantGetDep libmawk.h
	
	
	
	# Needed specifically by stock 'pcb' with patch to support io with autorouter formats.
	
	_getDep intltoolize
	_getDep kpsewhich
	
	_getDep /usr/share/texlive/texmf-dist/tex/generic/epsf/epsf.tex
	
	_getDep pdflatex
	_getDep texi2dvi
	_getDep ps2pdf
	_getDep gschem
	
	_getDep /usr/include/gtsconfig.h
	_getDep gtsconfig.h
	
	_getDep /usr/lib/x86_64-linux-gnu/pkgconfig/gts.pc
	_getDep pkgconfig/gts.pc
}

_build-app_pcb_genht() {
	_wantGetDep /usr/lib/libgenht.so.1.1.1 && return 0
	
	cd "$scriptLib"/genht
	
	make -j$(nprocs)
	sudo -n make install
	
	cd "$scriptLib"
	return 0
}


# WARNING: Not verified if fungw will obtain crucial scripting languages (e.g. python, lua, perl, tcl, mawk) when compiled on a typical system.
# http://repo.hu/projects/pcb/user/06_feature/scripting/install.txt
# svn co svn://repo.hu/genht/trunk genht
_build-app_pcb_fungw() {
	_wantGetDep /usr/local/lib/libfungw.so && return 0
	_wantGetDep fungw && return 0
	
	_test_build-app_pcb
	
	_mustGetSudo
	
	_build-app_pcb_genht
	
	
	
	cd "$scriptLib"/fungw
	
	./configure
	make -j 4
	sudo -n make install
	
	cd "$scriptLib"
	return 0
}

_build-app_pcb() {
	_test_build-app_pcb
	
	_mustGetSudo
	
	#_build-app_pcb_fungw
	
	
	
	cd "$scriptLib"/pcb
	
	./autogen.sh
	
	#./configure --all=buildin --buildin-lib_compat_help --buildin-lib_gensexpr --buildin-lib_gtk_common --buildin-lib_hid_common --buildin-lib_hid_gl --buildin-lib_hid_pcbui --buildin-lib_netmap --buildin-lib_polyhelp --buildin-lib_vfs --buildin-lib_wget --buildin-acompnet --buildin-act_draw --buildin-act_read --buildin-ar_cpcb --buildin-asm --buildin-autocrop --buildin-autoplace --buildin-autoroute --buildin-dialogs --buildin-distalign --buildin-distaligntext --buildin-djopt --buildin-draw_csect --buildin-draw_fab --buildin-draw_fontsel --buildin-drc_orig --buildin-drc_query --buildin-exto_std --buildin-fontmode --buildin-jostle --buildin-millpath --buildin-mincut --buildin-oldactions --buildin-order_pcbway --buildin-order --buildin-polycombine --buildin-polystitch --buildin-propedit --buildin-puller --buildin-query --buildin-renumber --buildin-report --buildin-rubberband_orig --buildin-script --buildin-serpentine --buildin-shand_cmd --buildin-shape --buildin-sketch_route --buildin-smartdisperse --buildin-stroke --buildin-teardrops --buildin-tool_std --buildin-vendordrill --buildin-fp_board --buildin-fp_fs --buildin-fp_wget --buildin-import_dsn --buildin-import_gnetlist --buildin-import_hpgl --buildin-import_net_cmd --buildin-import_net_action --buildin-import_netlist --buildin-import_pxm_gd --buildin-import_pxm_pnm --buildin-import_sch2 --buildin-import_sch --buildin-import_ttf --buildin-cam --buildin-export_bom --buildin-export_dsn --buildin-export_dxf --buildin-export_excellon --buildin-export_fidocadj --buildin-export_gcode --buildin-export_gerber --buildin-export_lpr --buildin-export_oldconn --buildin-export_openems --buildin-export_openscad --buildin-export_png --buildin-export_ps --buildin-export_stat --buildin-export_stl --buildin-export_svg --buildin-export_test --buildin-export_xy --buildin-io_dsn --buildin-io_kicad_legacy --buildin-io_kicad --buildin-io_pcb
	
	./configure --with-gui=gtk --with-x --with-printer=lpr --with-exporters=dsn,bom,gerber,png,ps,gcode,nelma --enable-doc --enable-toporouter --enable-toporouter-output --enable-gl --enable-m4lib-png
	
	make -j$(nproc)
	
	# WARNING: May be unnecessary, and may cause conflicts with distro package.
	# WARNING: Not adequately tested - "make uninstall" .
	#sudo -n make install
	
	
	# Apparently unnecessary files cause git submodule problems.
	_safeRMR "$scriptLib"/pcb/doc/pcb.t2p
	
	cd "$scriptLib"
	return 0
}
























# # ATTENTION: Add to ops!
_refresh_anchors_task() {
	true
	#cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_task_pcb-ioAutorouter_30MHzLowPass
}

_refresh_anchors_specific() {
	true
	
	_refresh_anchors_specific_single_procedure _pcb-ioAutorouter
}

_refresh_anchors_user() {
	true
	
	_refresh_anchors_user_single_procedure _pcb-ioAutorouter
}

_associate_anchors_request() {
	if type "_refresh_anchors_user" > /dev/null 2>&1
	then
		_tryExec "_refresh_anchors_user"
		#return
	fi
	
	
	_messagePlain_request 'association: dir, *.pcb'
	echo _pcb-ioAutorouter"$ub_anchor_suffix"
}


_refresh_anchors() {
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_pcb-ioAutorouter
	
	_tryExec "_refresh_anchors_task"
	
	return 0
}


