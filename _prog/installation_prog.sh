# ATTENTION: Overload with 'ops.sh' or similar. Cause to not to call "_wantGetDep" and immediately fail (return 1) in all cases if system instaltion in undesired.
# Unusual. Attempt to install distribution 'pcb' .
# Unusual. Possibly no need to continue checking build dependencies if system installation exists.
# No need to rebuild if a valid system installation exists.
# WARNING: Distribution version might not supply essential features.
# CAUTION: No distribution version of 'pcb' is known to supply essential 'dsn' autorouter format support.
# _accept_system-pcb() {
# 	_wantGetDep /usr/bin/pcb && return 0
# 	type 'pcb' && _wantGetDep pcb && return 0
# 	return 1
# }
_accept_system-pcb() {
	return 1
}

_test_prog() {
	true
	
	_accept_system-pcb
	return 0
}


_test_build_prog() {
	_accept_system-pcb && return 0
	
	_test_build-app_pcb
}

_testBuilt_prog() {
	_accept_system-pcb && return 0
	
	# ATTENTION: Disable ONLY for development testing purposes.
	# Limited test of self-built PCB binary.
	# CAUTION: Copying to an alternate distro or otherwise possibly binary incompatible system may allow possibility of untested failures!
	if [[ -e "$scriptLib"/pcb/src/pcb ]] && "$scriptLib"/pcb/src/pcb --help 2>&1 | grep 'SPECCTRA' > /dev/null 2>&1
	then
		return 0
	fi
	
	_stop 1
}

_build_prog() {
	_test_build-app_pcb
	
	"$scriptAbsoluteLocation" _build-app_pcb
}

_setup_prog() {
	true
}
