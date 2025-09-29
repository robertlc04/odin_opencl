package cl


import clc "./core"

// Platform
Platform :: struct {
	id:   clc.PlatformId,
	info: PlatformInfo,
}

PlatformInfo :: struct {
	profile:    cstring,
	version:    cstring,
	name:       cstring,
	vendor:     cstring,
	extensions: cstring,
}

// Device
Device :: struct {
	id:   clc.DeviceId,
	info: DeviceInfo,
}

DeviceInfo :: struct {
	name:             cstring,
	vendor:           cstring,
	profile:          cstring,
	version:          cstring,
	driver_version:   cstring,
	extensions:       cstring,
	// For specifig working
	il_version:       cstring,
	little_endian:    b8,
	available:        b8,
	parent:           clc.DeviceId, // If parent it's null this it's a root device
	single_fp_config: u64, // This it's configured for bit shifting if available
	svm_capabilities: u64, // This it's configured for bit shifting if available
}

// Context
Context :: struct {
	id:   clc.Context,
	info: ContextInfo,
}

ContextInfo :: struct {
	ref_count:   u32,
	num_devices: u32,
	properties:  []clc.ContextProperties, // Can be 0
}

