package cl

// Platform
Platform_t :: struct {
	id:   PlatformId,
	info: PlatformInfo_t,
}

PlatformInfo_t :: struct {
	profile:    cstring,
	version:    cstring,
	name:       cstring,
	vendor:     cstring,
	extensions: cstring,
}

// Device
Device_t :: struct {
	id:   DeviceId,
	info: DeviceInfo_t,
}

DeviceInfo_t :: struct {
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
	parent:           DeviceId, // If parent it's null this it's a root device
	single_fp_config: u64, // This it's configured for bit shifting if available
	svm_capabilities: u64, // This it's configured for bit shifting if available
}

// Context
Context_t :: struct {
	id:   Context,
	info: ContextInfo_t,
}

ContextInfo_t :: struct {
	ref_count:   u32,
	num_devices: u32,
	properties:  []ContextProperties, // Can be 0
}

CommandQueue_t :: struct {
	id:   CommandQueue,
	info: CommandQueueInfo_t,
}

CommandQueueInfo_t :: struct {
	ctx_id:     Context,
	dev_id:     DeviceId,
	properties: []CommandQueueProperties_t,
	size:       u32,
}

Program_t :: struct {
	id:           Program,
	kernels_name: []cstring,
	build_info:   ProgramBuildInfo_t,
}

ProgramBuildInfo_t :: struct {
	status:      BuildStatus,
	logs:        []cstring,
	binary_type: ProgramBinaryType,
}


Kernel_t :: struct {}
KernelInfo_t :: struct {}

Buffer_t :: struct {}
BufferInfo_t :: struct {}

Event_t :: struct {}
EventInfo_t :: struct {}

