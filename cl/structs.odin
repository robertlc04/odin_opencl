package cl

// Platform
Platform_t :: struct {
	id:   PlatformId,
	info: PlatformInfo_t,
}

PlatformInfo_t :: struct {
	profile:    string,
	version:    string,
	name:       string,
	vendor:     string,
	extensions: string,
}

// Device
Device_t :: struct {
	id:   DeviceId,
	info: DeviceInfo_t,
}

DeviceInfo_t :: struct {
	name:             string,
	vendor:           string,
	profile:          string,
	version:          string,
	driver_version:   string,
	extensions:       string,
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
	id:         Program,
	info:       ProgramInfo_t,
	build_info: ProgramBuildInfo_t,
	kernels:    []Kernel_t,
}

ProgramInfo_t :: struct {
	ctx:  Context,
	devs: []DeviceId,
}

ProgramBuildInfo_t :: struct {
	status:      BuildStatus,
	logs:        string,
	binary_type: ProgramBinaryType,
}


Kernel_t :: struct {
	id:   Kernel,
	args: []KernelArgsInfo_t,
	info: KernelInfo_t,
}
KernelInfo_t :: struct {
	name:      string,
	ref_count: u32, // Ref: https://registry.khronos.org/OpenCL/sdk/3.0/docs/man/html/clGetKernelInfo.html#_footnotedef_1
}
KernelArg_t :: struct {
	value: any,
	type:  typeid,
}

KernelArgsInfo_t :: struct {
	type:      string,
	name:      string,
	qualifier: KernelArgAddressQualifier,
}

Buffer_t :: struct {
	id:    Memory,
	flags: []MemFlags,
	size:  uint,
	type:  typeid,
}

Event_t :: struct {}
EventInfo_t :: struct {}

