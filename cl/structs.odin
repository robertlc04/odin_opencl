package cl
import "base:runtime"
import "core:reflect"

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

// make equivalence with: https://registry.khronos.org/OpenCL/sdk/3.0/docs/man/html/scalarDataTypes.html
KernelArg_t :: enum u64 {
	// Scalar types
	BOOL,
	CHAR,
	UNSIGNED_CHAR,
	UCHAR,
	SHORT,
	UNSIGNED_SHORT,
	USHORT,
	INT,
	UNSIGNED_INT,
	UINT,
	LONG,
	UNSIGNED_LONG,
	ULONG,
	FLOAT,
	DOUBLE,
	HALF,
	SIZE_T,
	PTRDIFF_T,
	INTPTR_T,
	UINTPTR_T,
	VOID,
}
// TODO: Improve needed
// use reflect.Type_Info for this type of parsing maybe use a typeif as args?
KernelArgDesc_t := #sparse[KernelArg_t]^runtime.Type_Info {
	.BOOL           = type_info_of(bool),
	.CHAR           = type_info_of(i8),
	.UCHAR          = type_info_of(u8),
	.UNSIGNED_CHAR  = type_info_of(u8),
	.SHORT          = type_info_of(i16),
	.USHORT         = type_info_of(u16),
	.UNSIGNED_SHORT = type_info_of(u16),
	.INT            = type_info_of(i32),
	.UINT           = type_info_of(u32),
	.UNSIGNED_INT   = type_info_of(u32),
	.LONG           = type_info_of(i64),
	.UNSIGNED_LONG  = type_info_of(u64),
	.ULONG          = type_info_of(u64),
	.FLOAT          = type_info_of(f32),
	.DOUBLE         = type_info_of(f64),
	.HALF           = type_info_of(f16),
	.SIZE_T         = type_info_of(u64),
	.PTRDIFF_T      = type_info_of(rawptr),
	.INTPTR_T       = type_info_of(rawptr),
	.UINTPTR_T      = type_info_of(uintptr),
	.VOID           = type_info_of(rawptr),
}

Tokens: []string = {
	"bool",
	"char",
	"unsigned_char",
	"uchar",
	"short",
	"unsigned_short",
	"ushort",
	"int",
	"unsigned_int",
	"uint",
	"long",
	"unsigned_long",
	"ulong",
	"float",
	"double",
	"half",
	"size_t",
	"ptrdiff_t",
	"intptr_t",
	"uintptr_t",
	"void",
}

