package cl

import "core:c"
import "core:fmt"
import "core:slice"

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


lib_g: dynlib.Library

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

	lib_g = lib
	ptr := dynlib.symbol_address(lib, string(name))
	if ptr == nil {
		fmt.printf("Warning: Could not load procedure %s\n", name)
	}
	(^rawptr)(p)^ = ptr

}

load_opencl_procedures :: proc(major_version: uint = 2, minor_version: uint = 2) {
	// Load all OpenCL procedures
	load_up_to(major_version, minor_version, load_proc)

}

unload_opencl_procedures :: proc() {
	if lib_g == nil do return
	dynlib.unload_library(lib_g)
}


import "core:log"

check :: proc(result: ErrorCodes, location := #caller_location) {
	#partial switch result {
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


debug_get_informations :: proc(structure: any, error: ErrorCodes, location := #caller_location) {
	log.debugf("Called from %d: %s", location.line, location.procedure)
	log.debugf("Structure: %v", structure)
	log.debugf("Error desc: %s", ErrorCodes_Descriptions[error])
}

compile_to_spirv :: proc(file_path: string) {

}

