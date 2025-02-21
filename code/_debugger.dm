//Datum used to init Auxtools debugging as early as possible
//Datum gets created in master.dm because for whatever reason global code in there gets runs first
//In case we ever figure out how to manipulate global init order please move the datum creation into this file
/datum/debugger

/datum/debugger/New()
		enable_debugger()

/datum/debugger/proc/enable_debugger()
	var/dll = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if(dll)
		LIBCALL(dll, "auxtools_init")()
		enable_debugging()

/proc/auxtools_stack_trace(msg)
	CRASH(msg)

/proc/auxtools_expr_stub()
	CRASH("auxtools not loaded")

/proc/enable_debugging(mode, port)
	CRASH("auxtools not loaded")
