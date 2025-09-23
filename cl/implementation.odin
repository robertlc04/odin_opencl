#+private
package cl

import "core:dynlib"

loaded_up_to: [2]int
loaded_up_to_major := 0
loaded_up_to_minor := 0

Set_Proc_Address_Type :: #type proc(p: rawptr, name: cstring, lib: dynlib.Library = nil)

// Deprecated List
DeprecatedInVersion :: enum {
	/* Deprecated OpenCL 1.1 APIs */
	CL_CREATE_IMAGE_2D                = 11,
	CL_CREATE_IMAGE_3D                = 11,
	CL_ENQUEUE_MARKER                 = 11,
	CL_ENQUEUE_WAIT_FOR_EVENTS        = 11,
	CL_ENQUEUE_BARRIER                = 11,
	CL_UNLOAD_COMPILER                = 11,
	CL_GET_EXTENSION_FUNCTION_ADDRESS = 11,

	/* Deprecated OpenCL 2.0 APIs */
	CL_CREATE_COMMAND_QUEUE           = 20,
	CL_CREATE_SAMPLER                 = 20,
	CL_ENQUEUE_TASK                   = 20,
}
// Loading
load_up_to :: proc(
	major, minor: int,
	set_proc_address: Set_Proc_Address_Type,
	lib: dynlib.Library = nil,
) {
	loaded_up_to = {0, 0}
	loaded_up_to[0] = major
	loaded_up_to[1] = minor
	loaded_up_to_major = major
	loaded_up_to_minor = minor

	switch major * 10 + minor {
	case:
		fallthrough
	// case 46: load_4_6(set_proc_address); fallthrough;
	// case 45: load_4_5(set_proc_address); fallthrough;
	// case 44: load_4_4(set_proc_address); fallthrough;
	// case 43: load_4_3(set_proc_address); fallthrough;
	// case 42: load_4_2(set_proc_address); fallthrough;
	// case 41: load_4_1(set_proc_address); fallthrough;
	// case 40: load_4_0(set_proc_address); fallthrough;
	// case 33: load_3_3(set_proc_address); fallthrough;
	// case 32: load_3_2(set_proc_address); fallthrough;
	// case 31: load_3_1(set_proc_address); fallthrough;
	// case 30: load_3_0(set_proc_address); fallthrough;
	// case 15: load_1_5(set_proc_address); fallthrough;
	// case 14: load_1_4(set_proc_address); fallthrough;
	// case 13: load_1_3(set_proc_address); fallthrough;
	case 22:
		load_2_2(set_proc_address);fallthrough
	case 21:
		load_2_1(set_proc_address);fallthrough
	case 20:
		load_2_0(set_proc_address);fallthrough
	case 12:
		load_1_2(set_proc_address);fallthrough
	case 11:
		load_1_1(set_proc_address);fallthrough
	case 10:
		load_1_0(set_proc_address)
	}
}


// Callbacks
CreateContextCallback :: #type proc "system" (
	errinfo: cstring,
	private_info: rawptr,
	cb: uint,
	user_data: rawptr,
)

ProcPfnNotify :: #type proc "system" (
	errinfo: cstring,
	private_info: rawptr,
	cb: uint,
	user_data: rawptr,
)

ProgramCallback :: #type proc "system" (program: Program, user_data: rawptr)

MemFreeCallback :: #type proc "system" (
	queue: CommandQueue,
	num_svm_pointers: u32,
	svm_pointers: [^]rawptr,
	user_data: rawptr,
)

EventCallback :: #type proc "system" (event: Event, event_command_status: i32, user_data: rawptr)

// CL_VERSION_1_0

// Platform
impl_GetPlatformIDs: proc "c" (
	num_entries: u32,
	platforms: ^PlatformId,
	num_platforms: ^u32,
) -> i32


impl_GetPlatformInfo: proc "c" (
	platform: PlatformId,
	param_name: uint,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32


// Device
impl_GetDeviceIDs: proc "c" (
	platform: PlatformId,
	device_type: DeviceType,
	num_entries: u32,
	devices: [^]DeviceId,
	num_devices: ^u32,
) -> i32

impl_GetDeviceInfo: proc "c" (
	device: DeviceId,
	param_name: uint,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32

// Context
impl_CreateContext: proc "c" (
	properties: ^ContextProperties,
	num_devices: u32,
	devices: [^]DeviceId,
	pfn_notify: ^CreateContextCallback,
	user_data: rawptr,
	errcode_ret: ^i32,
) -> Context

impl_CreateContextFromType: proc "c" (
	properties: ^ContextProperties,
	device_type: DeviceType,
	pfn_notify: ^CreateContextCallback,
	user_data: rawptr,
	errcode_ret: ^i32,
) -> Context

impl_GetContextInfo: proc "c" (
	cl_context: Context,
	param_name: uint,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32


impl_RetainContext: proc "c" (cl_context: Context) -> i32
impl_ReleaseContext: proc "c" (cl_context: Context) -> i32

// CommandQueue

/* Deprecated OpenCL 2.0 APIs */
impl_CreateCommandQueue: proc "c" (
	cl_context: Context,
	device: DeviceId,
	properties: ^CommandQueueProperties,
	errcode_ret: ^i32,
) -> CommandQueue


impl_GetCommandQueueInfo: proc "c" (
	command_queue: CommandQueue,
	param_name: CommandQueueInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32


impl_RetainCommandQueue: proc "c" (command_queue: CommandQueue) -> i32
impl_ReleaseCommandQueue: proc "c" (command_queue: CommandQueue) -> i32

// Program
impl_CreateProgramWithSource: proc "c" (
	cl_context: Context,
	count: i32,
	strings: [^]cstring,
	lengths: [^]uint,
	errcode_ret: ^i32,
) -> Program
impl_CreateProgramWithBinary: proc "c" (
	cl_context: Context,
	num_devices: u32,
	device_list: [^]DeviceId,
	lengths: [^]uint,
	binaries: [^][^]u8,
	binary_status: ^i32,
	errcode_ret: ^i32,
) -> Program
impl_GetProgramInfo: proc "c" (
	program: Program,
	param_name: ProgramInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32
impl_GetProgramBuildInfo: proc "c" (
	program: Program,
	device: DeviceId,
	param_name: ProgramBuildInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32

impl_RetainProgram: proc "c" (program: Program) -> i32
impl_ReleaseProgram: proc "c" (program: Program) -> i32
impl_BuildProgram: proc "c" (
	program: Program,
	num_devices: u32,
	device_list: [^]DeviceId,
	options: cstring,
	pfn_notify: ^ProgramCallback,
	user_data: rawptr,
) -> i32

// Kernel

impl_CreateKernel: proc "c" (program: Program, kernel_name: cstring, errcode_ret: ^i32) -> Kernel
impl_CreateKernelsInProgram: proc "c" (
	program: Program,
	num_kernels: u32,
	kernels: [^]Kernel,
	num_kernels_ret: ^u32,
) -> i32

impl_GetKernelInfo: proc "c" (
	kernel: Kernel,
	param_name: KernelArgInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32
impl_SetKernelArg: proc "c" (
	kernel: Kernel,
	arg_index: u32,
	arg_size: uint,
	arg_value: rawptr,
) -> i32
impl_GetKernelWorkGroupInfo: proc "c" (
	kernel: Kernel,
	device: DeviceId,
	param_name: KernelWorkGroupInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32

impl_RetainKernel: proc "c" (kernel: Kernel) -> i32
impl_ReleaseKernel: proc "c" (kernel: Kernel) -> i32


impl_CreateBuffer: proc "c" (
	cl_context: Context,
	flags: MemFlags,
	size: uint,
	host_ptr: rawptr,
	errcode_ret: ^i32,
) -> Memory

impl_RetainMemObject: proc "c" (memobj: Memory) -> i32
impl_ReleaseMemObject: proc "c" (memobj: Memory) -> i32

/* Enqueued Commands APIs */
impl_EnqueueCopyImage: proc "c" (
	command_queue: CommandQueue,
	src_image: Memory,
	dst_image: Memory,
	src_origin: ^uint,
	dst_origin: ^uint,
	region: ^uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueCopyImageToBuffer: proc "c" (
	command_queue: CommandQueue,
	src_image: Memory,
	dst_buffer: Memory,
	src_origin: ^uint,
	region: ^uint,
	dst_offset: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueCopyBufferToImage: proc "c" (
	command_queue: CommandQueue,
	src_buffer: Memory,
	dst_image: Memory,
	src_offset: uint,
	dst_origin: ^uint,
	region: ^uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueMapBuffer: proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	blocking_map: b8,
	map_flags: MapFlags,
	offset: uint,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
	errcode_ret: ^i32,
) -> rawptr
impl_EnqueueMapImage: proc "c" (
	command_queue: CommandQueue,
	image: Memory,
	blocking_map: b8,
	map_flags: MapFlags,
	origin: ^uint,
	region: ^uint,
	image_row_pitch: ^uint,
	image_slice_pitch: ^uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
	errcode_ret: ^i32,
) -> rawptr
impl_EnqueueUnmapMemObject: proc "c" (
	command_queue: CommandQueue,
	memobj: Memory,
	mapped_ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueNDRangeKernel: proc "c" (
	command_queue: CommandQueue,
	kernel: Kernel,
	work_dim: u32,
	global_work_offset: ^uint,
	global_work_size: ^uint,
	local_work_size: ^uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueNativeKernel: proc "c" (
	command_queue: CommandQueue,
	user_func: ^proc(),
	args: rawptr,
	cb_args: uint,
	num_mem_objects: u32,
	mem_list: Memory,
	args_mem_loc: ^rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueReadBuffer: proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	blocking_read: b8,
	offset: uint,
	size: uint,
	ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueWriteBuffer: proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	blocking_write: b8,
	offset: uint,
	size: uint,
	ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueCopyBuffer: proc "c" (
	command_queue: CommandQueue,
	src_buffer: Memory,
	dst_buffer: Memory,
	src_offset: uint,
	dst_offset: uint,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueReadImage: proc "c" (
	command_queue: CommandQueue,
	image: Memory,
	blocking_read: b8,
	origin: ^uint,
	region: ^uint,
	row_pitch: uint,
	slice_pitch: uint,
	ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueWriteImage: proc "c" (
	command_queue: CommandQueue,
	image: Memory,
	blocking_write: b8,
	origin: ^uint,
	region: ^uint,
	input_row_pitch: uint,
	input_slice_pitch: uint,
	ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32


/* Event Object APIs */
impl_WaitForEvents: proc "c" (num_events: u32, event_list: [^]Event) -> i32
impl_GetEventInfo: proc "c" (
	event: Event,
	param_name: EventInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32
impl_RetainEvent: proc "c" (event: Event) -> i32
impl_ReleaseEvent: proc "c" (event: Event) -> i32

/* Profiling APIs */
impl_GetEventProfilingInfo: proc "c" (
	event: Event,
	param_name: ProfilingInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32


/* Flush and Finish APIs */
impl_Flush: proc "c" (command_queue: CommandQueue) -> i32
impl_Finish: proc "c" (command_queue: CommandQueue) -> i32


load_1_0 :: proc(set_proc_address: Set_Proc_Address_Type) {
	set_proc_address(&impl_GetPlatformIDs, "clGetPlatformIDs")
	set_proc_address(&impl_GetPlatformInfo, "clGetPlatformInfo")

	set_proc_address(&impl_GetDeviceIDs, "clGetDeviceIDs")
	set_proc_address(&impl_GetDeviceInfo, "clGetDeviceInfo")

	set_proc_address(&impl_CreateContext, "clCreateContext")
	set_proc_address(&impl_CreateContextFromType, "clCreateContextFromType")
	set_proc_address(&impl_GetContextInfo, "clGetContextInfo")

	set_proc_address(&impl_RetainContext, "clRetainContext")
	set_proc_address(&impl_ReleaseContext, "clReleaseContext")


	/* Deprecated OpenCL 2.0 APIs */
	set_proc_address(&impl_CreateCommandQueue, "clCreateCommandQueue")

	set_proc_address(&impl_GetCommandQueueInfo, "clGetCommandQueueInfo")
	set_proc_address(&impl_RetainCommandQueue, "clRetainCommandQueue")
	set_proc_address(&impl_ReleaseCommandQueue, "clReleaseCommandQueue")

	set_proc_address(&impl_CreateProgramWithSource, "clCreateProgramWithSource")
	set_proc_address(&impl_CreateProgramWithBinary, "clCreateProgramWithBinary")
	set_proc_address(&impl_GetProgramInfo, "clGetProgramInfo")
	set_proc_address(&impl_GetProgramBuildInfo, "clGetProgramBuildInfo")

	set_proc_address(&impl_RetainProgram, "clRetainProgram")
	set_proc_address(&impl_ReleaseProgram, "clReleaseProgram")
	set_proc_address(&impl_BuildProgram, "clBuildProgram")

	set_proc_address(&impl_CreateKernel, "clCreateKernel")
	set_proc_address(&impl_CreateKernelsInProgram, "clCreateKernelsInProgram")

	set_proc_address(&impl_GetKernelInfo, "clGetKernelInfo")
	set_proc_address(&impl_SetKernelArg, "clSetKernelArg")
	set_proc_address(&impl_GetKernelWorkGroupInfo, "clGetKernelWorkGroupInfo")

	set_proc_address(&impl_RetainKernel, "clRetainKernel")
	set_proc_address(&impl_ReleaseKernel, "clReleaseKernel")

	set_proc_address(&impl_CreateBuffer, "clCreateBuffer")

	set_proc_address(&impl_RetainMemObject, "clRetainMemObject")
	set_proc_address(&impl_ReleaseMemObject, "clReleaseMemObject")

	set_proc_address(&impl_EnqueueCopyImage, "clEnqueueCopyImage")
	set_proc_address(&impl_EnqueueCopyImageToBuffer, "clEnqueueCopyImageToBuffer")
	set_proc_address(&impl_EnqueueCopyBufferToImage, "clEnqueueCopyBufferToImage")

	set_proc_address(&impl_EnqueueMapBuffer, "clEnqueueMapBuffer")
	set_proc_address(&impl_EnqueueMapImage, "clEnqueueMapImage")
	set_proc_address(&impl_EnqueueUnmapMemObject, "clEnqueueUnmapMemObject")
	set_proc_address(&impl_EnqueueNDRangeKernel, "clEnqueueNDRangeKernel")
	set_proc_address(&impl_EnqueueNativeKernel, "clEnqueueNativeKernel")
	set_proc_address(&impl_EnqueueReadBuffer, "clEnqueueReadBuffer")
	set_proc_address(&impl_EnqueueWriteBuffer, "clEnqueueWriteBuffer")
	set_proc_address(&impl_EnqueueCopyBuffer, "clEnqueueCopyBuffer")
	set_proc_address(&impl_EnqueueReadImage, "clEnqueueReadImage")
	set_proc_address(&impl_EnqueueWriteImage, "clEnqueueWriteImage")

	set_proc_address(&impl_WaitForEvents, "clWaitForEvents")
	set_proc_address(&impl_GetEventInfo, "clGetEventInfo")
	set_proc_address(&impl_RetainEvent, "clRetainEvent")
	set_proc_address(&impl_ReleaseEvent, "clReleaseEvent")

	set_proc_address(&impl_GetEventProfilingInfo, "clGetEventProfilingInfo")

	set_proc_address(&impl_Flush, "clFlush")
	set_proc_address(&impl_Finish, "clFinish")
}


// CL_VERSION_1_1
impl_EnqueueReadBufferRect: proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	blocking_read: b8,
	buffer_origin: ^uint,
	host_origin: ^uint,
	region: ^uint,
	buffer_row_pitch: uint,
	buffer_slice_pitch: uint,
	host_row_pitch: uint,
	host_slice_pitch: uint,
	ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueWriteBufferRect: proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	blocking_write: b8,
	buffer_origin: ^uint,
	host_origin: ^uint,
	region: ^uint,
	buffer_row_pitch: uint,
	buffer_slice_pitch: uint,
	host_row_pitch: uint,
	host_slice_pitch: uint,
	ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueCopyBufferRect: proc "c" (
	command_queue: CommandQueue,
	src_buffer: Memory,
	dst_buffer: Memory,
	src_origin: ^uint,
	dst_origin: ^uint,
	region: ^uint,
	src_row_pitch: uint,
	src_slice_pitch: uint,
	dst_row_pitch: uint,
	dst_slice_pitch: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32


/* Event Object APIs */

impl_CreateUserEvent: proc "c" (cl_context: Context, errcode_ret: ^i32) -> Event
impl_SetUserEventStatus: proc "c" (event: Event, execution_status: i32) -> i32
impl_SetEventCallback: proc "c" (
	event: Event,
	command_exec_callback_type: i32,
	pfn_notify: EventCallback,
	user_data: rawptr,
) -> i32


load_1_1 :: proc(set_proc_address: Set_Proc_Address_Type) {
	set_proc_address(&impl_EnqueueReadBufferRect, "clEnqueueReadBufferRect")
	set_proc_address(&impl_EnqueueWriteBufferRect, "clEnqueueWriteBufferRect")
	set_proc_address(&impl_EnqueueCopyBufferRect, "clEnqueueCopyBufferRect")

	set_proc_address(&impl_CreateUserEvent, "clCreateUserEvent")
	set_proc_address(&impl_SetUserEventStatus, "clSetUserEventStatus")
	set_proc_address(&impl_SetEventCallback, "clSetEventCallback")
}

// CL_VERSION_1_2

impl_CreateProgramWithBuiltInKernels: proc "c" (
	cl_context: Context,
	num_devices: u32,
	device_list: [^]DeviceId,
	kernel_names: cstring,
	errcode_ret: ^i32,
) -> Program
impl_CompileProgram: proc "c" (
	program: Program,
	num_devices: u32,
	device_list: [^]DeviceId,
	options: cstring,
	num_input_headers: u32,
	input_headers: [^]Program,
	header_include_names: [^]cstring,
	pfn_notify: ^ProgramCallback,
	user_data: rawptr,
) -> i32
impl_LinkProgram: proc "c" (
	cl_context: Context,
	num_devices: u32,
	device_list: [^]DeviceId,
	options: cstring,
	num_input_programs: u32,
	input_programs: [^]Program,
	pfn_notify: ^ProgramCallback,
	user_data: rawptr,
	errcode_ret: ^i32,
) -> Program


impl_GetKernelArgInfo: proc "c" (
	kernel: Kernel,
	arg_indx: u32,
	param_name: KernelArgInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32

// Enqueue
impl_EnqueueFillBuffer: proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	pattern: rawptr,
	pattern_size: uint,
	offset: uint,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueFillImage: proc "c" (
	command_queue: CommandQueue,
	image: Memory,
	fill_color: rawptr,
	origin: ^uint,
	region: ^uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueMigrateMemObjects: proc "c" (
	command_queue: CommandQueue,
	num_mem_objects: u32,
	mem_objects: [^]Memory,
	flags: MemMigrationFlags,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueMarkerWithWaitList: proc "c" (
	command_queue: CommandQueue,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueBarrierWithWaitList: proc "c" (
	command_queue: CommandQueue,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32


load_1_2 :: proc(set_proc_address: Set_Proc_Address_Type) {
	set_proc_address(&impl_CreateProgramWithBuiltInKernels, "clCreateProgramWithBuiltInKernels")
	set_proc_address(&impl_CompileProgram, "clCompileProgram")
	set_proc_address(&impl_LinkProgram, "clLinkProgram")
	set_proc_address(&impl_GetKernelArgInfo, "clGetKernelArgInfo")

	set_proc_address(&impl_EnqueueFillBuffer, "clEnqueueFillBuffer")
	set_proc_address(&impl_EnqueueFillImage, "clEnqueueFillImage")
	set_proc_address(&impl_EnqueueMigrateMemObjects, "clEnqueueMigrateMemObjects")
	set_proc_address(&impl_EnqueueMarkerWithWaitList, "clEnqueueMarkerWithWaitList")
	set_proc_address(&impl_EnqueueBarrierWithWaitList, "clEnqueueBarrierWithWaitList")
}

// CL_VERSION_2_0

impl_CreateCommandQueueWithProperties: proc "c" (
	cl_context: Context,
	device: DeviceId,
	properties: ^CommandQueueProperties,
	errcode_ret: ^i32,
) -> CommandQueue


impl_SetKernelArgSVMPointer: proc "c" (kernel: Kernel, arg_index: u32, arg_value: rawptr) -> i32
impl_SetKernelExecInfo: proc "c" (
	kernel: Kernel,
	param_name: KernelExecInfo,
	param_value_size: uint,
	param_value: rawptr,
) -> i32

// Enqueue
impl_EnqueueSVMFree: proc "c" (
	command_queue: CommandQueue,
	num_svm_pointers: u32,
	svm_pointers: [^]rawptr,
	pfn_free_func: ^MemFreeCallback,
	user_data: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueSVMMemcpy: proc "c" (
	command_queue: CommandQueue,
	blocking_copy: b8,
	dst_ptr: rawptr,
	src_ptr: rawptr,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueSVMMemFill: proc "c" (
	command_queue: CommandQueue,
	svm_ptr: rawptr,
	pattern: rawptr,
	pattern_size: uint,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueSVMMap: proc "c" (
	command_queue: CommandQueue,
	blocking_map: b8,
	flags: MapFlags,
	svm_ptr: rawptr,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32
impl_EnqueueSVMUnmap: proc "c" (
	command_queue: CommandQueue,
	svm_ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32


load_2_0 :: proc(set_proc_address: Set_Proc_Address_Type) {
	set_proc_address(&impl_CreateCommandQueueWithProperties, "clCreateCommandQueueWithProperties")
	set_proc_address(&impl_SetKernelArgSVMPointer, "clSetKernelArgSVMPointer")
	set_proc_address(&impl_SetKernelExecInfo, "clSetKernelExecInfo")

	set_proc_address(&impl_EnqueueSVMFree, "clEnqueueSVMFree")
	set_proc_address(&impl_EnqueueSVMMemcpy, "clEnqueueSVMMemcpy")
	set_proc_address(&impl_EnqueueSVMMemFill, "clEnqueueSVMMemFill")
	set_proc_address(&impl_EnqueueSVMMap, "clEnqueueSVMMap")
	set_proc_address(&impl_EnqueueSVMUnmap, "clEnqueueSVMUnmap")
}


// CL_VERSION_2_1

impl_CreateProgramWithIL: proc "c" (
	cl_context: Context,
	il: rawptr,
	length: uint,
	errcode_ret: ^i32,
) -> Program


impl_CloneKernel: proc "c" (source_kernel: Kernel, errcode_ret: ^i32) -> Kernel


impl_GetKernelSubGroupInfo: proc "c" (
	kernel: Kernel,
	device: DeviceId,
	param_name: KernelSubGroupInfo,
	input_value_size: uint,
	input_value: rawptr,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32


impl_EnqueueSVMMigrateMem: proc "c" (
	command_queue: CommandQueue,
	num_svm_pointers: u32,
	svm_pointers: [^]rawptr,
	sizes: [^]uint,
	flags: MemFlags,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32


load_2_1 :: proc(set_proc_address: Set_Proc_Address_Type) {
	set_proc_address(&impl_CreateProgramWithIL, "clCreateProgramWithIL")
	set_proc_address(&impl_CloneKernel, "clCloneKernel")
	set_proc_address(&impl_GetKernelSubGroupInfo, "clGetKernelSubGroupInfo")

	set_proc_address(&impl_EnqueueSVMMigrateMem, "clEnqueueSVMMigrateMem")
}


// CL_VERSION_2_2

// Deprecated in Version 2.2
impl_SetProgramReleaseCallback: proc "c" (
	program: Program,
	pfn_notify: ^ProgramCallback,
	user_data: rawptr,
) -> i32
impl_SetProgramSpecializationConstant: proc "c" (
	program: Program,
	spec_id: u32,
	spec_size: uint,
	spec_value: rawptr,
) -> i32

load_2_2 :: proc(set_proc_address: Set_Proc_Address_Type) {
	set_proc_address(&impl_SetProgramReleaseCallback, "clSetProgramReleaseCallback")
	set_proc_address(&impl_SetProgramSpecializationConstant, "clSetProgramSpecializationConstant")
}


// CL_VERSION_3_0
impl_CreateBufferWithProperties: proc "c" (
	cl_context: Context,
	properties: [^]u64,
	flags: MemFlags,
	size: uint,
	host_ptr: rawptr,
	errcode_ret: ^i32,
) -> Memory


load_3_0 :: proc(set_proc_address: Set_Proc_Address_Type) {
	set_proc_address(&impl_CreateBufferWithProperties, "clCreateBufferWithProperties")
}

