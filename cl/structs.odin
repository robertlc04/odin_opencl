package cl


import clc "./core"

// Platform
Platform :: struct {
	id:   clc.PlatformId,
	info: PlatformInfo,
}

// BASIC INFORMATION
// CL_PLATFORM_PROFILE
// CL_PLATFORM_VERSION
// CL_PLATFORM_NAME
// CL_PLATFORM_VENDOR
// CL_PLATFORM_EXTENSIONS

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
	max_work_items:   u32,
	il_version:       cstring,
	single_fp_config: u64, // This it's configured for bit shifting if available
	little_endian:    bool,
	available:        bool,
	svm_capabilities: u64, // This it's configured for bit shifting if available
}

