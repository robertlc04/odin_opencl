package cl

import "core:c"
import "core:fmt"

import "core:dynlib"

// FIXME: Problems with the implementation of Creating a program from IL

// Types for helping with possible pointers errors
PlatformId :: distinct rawptr
DeviceId :: distinct rawptr
Context :: distinct rawptr
CommandQueue :: distinct rawptr
Program :: distinct rawptr
Kernel :: distinct rawptr
Memory :: distinct rawptr
Event :: distinct rawptr

load_proc :: proc(p: rawptr, name: cstring, libcl: dynlib.Library = nil) {
	// Default loading in case of no provide lib
	if libcl != nil {
		ptr := dynlib.symbol_address(libcl, string(name))
		if ptr == nil {
			fmt.printf("Warning: Could not load procedure %s\n", name)
		}
		(^rawptr)(p)^ = ptr
		return
	}
	lib, lib_ok := dynlib.load_library("libOpenCL.so.1")
	if !lib_ok {
		// Try alternative names
		lib, lib_ok = dynlib.load_library("libOpenCL.so")
		if !lib_ok {
			lib, lib_ok = dynlib.load_library("OpenCL")
			if !lib_ok {
				fmt.println("Failed to load OpenCL library")
				return
			}
		}
	}

	ptr := dynlib.symbol_address(lib, string(name))
	if ptr == nil {
		fmt.printf("Warning: Could not load procedure %s\n", name)
	}
	(^rawptr)(p)^ = ptr

}

load_opencl_procedures :: proc() {
	// Load all OpenCL procedures
	load_up_to(3, 0, load_proc)
}


import "core:log"

check :: proc(result: i32, location := #caller_location) {
	#partial switch ErrorCodes(result) {
	case .SUCCESS:
		return
	case:
		log.panicf(
			"OpenCL failure: {}",
			ErrorCodes_Descriptions[ErrorCodes(result)],
			location = location,
		)
	}
}
