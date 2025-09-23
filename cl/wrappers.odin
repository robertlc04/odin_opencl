package cl

// TODO: Make a when ODIN_DEBUG for easy debuging with message error no handler needed for now

// CL_VERSION_1_0
GetPlatformIDs :: #force_inline proc "c" (
	num_entries: u32,
	platforms: ^PlatformId,
	num_platforms: ^u32,
) -> i32 {return impl_GetPlatformIDs(num_entries, platforms, num_platforms)}

GetPlatformInfo :: #force_inline proc "c" (
	platform: PlatformId,
	param_name: PlatformInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {return impl_GetPlatformInfo(
		platform,
		uint(param_name),
		param_value_size,
		param_value,
		param_value_size_ret,
	)}

GetDeviceIDs :: #force_inline proc "c" (
	platform: PlatformId,
	device_type: DeviceType,
	num_entries: u32,
	devices: [^]DeviceId,
	num_devices: ^u32,
) -> i32 {return impl_GetDeviceIDs(platform, device_type, num_entries, devices, num_devices)}

GetDeviceInfo :: #force_inline proc "c" (
	device: DeviceId,
	param_name: DeviceInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {return impl_GetDeviceInfo(
		device,
		uint(param_name),
		param_value_size,
		param_value,
		param_value_size_ret,
	)}


CreateContext :: #force_inline proc "c" (
	properties: ^ContextProperties,
	num_devices: u32,
	devices: [^]DeviceId,
	pfn_notify: ^CreateContextCallback,
	user_data: rawptr,
	errcode_ret: ^i32,
) -> Context {
	return impl_CreateContext(properties, num_devices, devices, pfn_notify, user_data, errcode_ret)
}
CreateContextFromType :: #force_inline proc "c" (
	properties: ^ContextProperties,
	device_type: DeviceType,
	pfn_notify: ^CreateContextCallback,
	user_data: rawptr,
	errcode_ret: ^i32,
) -> rawptr {
	return impl_CreateContextFromType(properties, device_type, pfn_notify, user_data, errcode_ret)
}

GetContextInfo :: #force_inline proc "c" (
	cl_context: Context,
	param_name: ContextInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {
	return impl_GetContextInfo(
		cl_context,
		uint(param_name),
		param_value_size,
		param_value,
		param_value_size_ret,
	)
}

RetainContext :: #force_inline proc "c" (cl_context: Context) -> i32 {return impl_RetainContext(
		cl_context,
	)}
ReleaseContext :: #force_inline proc "c" (cl_context: Context) -> i32 {return impl_ReleaseContext(
		cl_context,
	)}

/* Deprecated OpenCL 2.0 APIs */
CreateCommandQueue :: #force_inline proc "c" (
	cl_context: Context,
	device: DeviceId,
	properties: ^CommandQueueProperties,
	errcode_ret: ^i32,
) -> CommandQueue {
	return impl_CreateCommandQueue(cl_context, device, properties, errcode_ret)
}


GetCommandQueueInfo :: #force_inline proc "c" (
	command_queue: CommandQueue,
	param_name: CommandQueueInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {
	return impl_GetCommandQueueInfo(
		command_queue,
		param_name,
		param_value_size,
		param_value,
		param_value_size_ret,
	)
}


RetainCommandQueue :: #force_inline proc "c" (
	command_queue: CommandQueue,
) -> i32 {return impl_RetainCommandQueue(command_queue)}
ReleaseCommandQueue :: #force_inline proc "c" (
	command_queue: CommandQueue,
) -> i32 {return impl_ReleaseCommandQueue(command_queue)}


CreateProgramWithSource :: #force_inline proc "c" (
	cl_context: Context,
	count: i32,
	strings: [^]cstring,
	lengths: [^]uint,
	errcode_ret: ^i32,
) -> Program {return impl_CreateProgramWithSource(
		cl_context,
		count,
		strings,
		lengths,
		errcode_ret,
	)}
CreateProgramWithBinary :: #force_inline proc "c" (
	cl_context: Context,
	num_devices: u32,
	device_list: [^]DeviceId,
	lengths: [^]uint,
	binaries: [^][^]u8,
	binary_status: ^i32,
	errcode_ret: ^i32,
) -> Program {return impl_CreateProgramWithBinary(
		cl_context,
		num_devices,
		device_list,
		lengths,
		binaries,
		binary_status,
		errcode_ret,
	)}
GetProgramInfo :: #force_inline proc "c" (
	program: Program,
	param_name: ProgramInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {return impl_GetProgramInfo(
		program,
		param_name,
		param_value_size,
		param_value,
		param_value_size_ret,
	)}
GetProgramBuildInfo :: #force_inline proc "c" (
	program: Program,
	device: DeviceId,
	param_name: ProgramBuildInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {return impl_GetProgramBuildInfo(
		program,
		device,
		param_name,
		param_value_size,
		param_value,
		param_value_size_ret,
	)}

RetainProgram :: #force_inline proc "c" (program: Program) -> i32 {
	return impl_RetainProgram(program)
}
ReleaseProgram :: #force_inline proc "c" (program: Program) -> i32 {
	return impl_ReleaseProgram(program)
}
BuildProgram :: #force_inline proc "c" (
	program: Program,
	num_devices: u32,
	device_list: [^]DeviceId,
	options: cstring,
	pfn_notify: ^ProgramCallback,
	user_data: rawptr,
) -> i32 {
	return impl_BuildProgram(program, num_devices, device_list, options, pfn_notify, user_data)
}

CreateKernel :: #force_inline proc "c" (
	program: Program,
	kernel_name: cstring,
	errcode_ret: ^i32,
) -> Kernel {
	return impl_CreateKernel(program, kernel_name, errcode_ret)
}

CreateKernelsInProgram :: #force_inline proc "c" (
	program: Program,
	num_kernels: u32,
	kernels: [^]Kernel,
	num_kernels_ret: ^u32,
) -> i32 {
	return impl_CreateKernelsInProgram(program, num_kernels, kernels, num_kernels_ret)
}

GetKernelInfo :: #force_inline proc "c" (
	kernel: Kernel,
	param_name: KernelArgInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {
	return impl_GetKernelInfo(
		kernel,
		param_name,
		param_value_size,
		param_value,
		param_value_size_ret,
	)
}
SetKernelArg :: #force_inline proc "c" (
	kernel: Kernel,
	arg_index: u32,
	arg_size: uint,
	arg_value: rawptr,
) -> i32 {
	return impl_SetKernelArg(kernel, arg_index, arg_size, arg_value)
}

GetKernelWorkGroupInfo :: #force_inline proc "c" (
	kernel: Kernel,
	device: DeviceId,
	param_name: KernelWorkGroupInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {
	return impl_GetKernelWorkGroupInfo(
		kernel,
		device,
		param_name,
		param_value_size,
		param_value,
		param_value_size_ret,
	)
}

RetainKernel :: #force_inline proc "c" (kernel: Kernel) -> i32 {return impl_RetainKernel(kernel)}
ReleaseKernel :: #force_inline proc "c" (kernel: Kernel) -> i32 {return impl_ReleaseKernel(kernel)}

CreateBuffer :: #force_inline proc "c" (
	cl_context: Context,
	flags: MemFlags,
	size: uint,
	host_ptr: rawptr,
	errcode_ret: ^i32,
) -> Memory {
	return impl_CreateBuffer(cl_context, flags, size, host_ptr, errcode_ret)
}

RetainMemObject :: #force_inline proc "c" (memobj: Memory) -> i32 {return impl_RetainMemObject(
		memobj,
	)}
ReleaseMemObject :: #force_inline proc "c" (memobj: Memory) -> i32 {return impl_ReleaseMemObject(
		memobj,
	)}


/* Enqueued Commands APIs */
EnqueueCopyImage :: #force_inline proc "c" (
	command_queue: CommandQueue,
	src_image: Memory,
	dst_image: Memory,
	src_origin: ^uint,
	dst_origin: ^uint,
	region: ^uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueCopyImage(
		command_queue,
		src_image,
		dst_image,
		src_origin,
		dst_origin,
		region,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueCopyImageToBuffer :: #force_inline proc "c" (
	command_queue: CommandQueue,
	src_image: Memory,
	dst_buffer: Memory,
	src_origin: ^uint,
	region: ^uint,
	dst_offset: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueCopyImageToBuffer(
		command_queue,
		src_image,
		dst_buffer,
		src_origin,
		region,
		dst_offset,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueCopyBufferToImage :: #force_inline proc "c" (
	command_queue: CommandQueue,
	src_buffer: Memory,
	dst_image: Memory,
	src_offset: uint,
	dst_origin: ^uint,
	region: ^uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueCopyBufferToImage(
		command_queue,
		src_buffer,
		dst_image,
		src_offset,
		dst_origin,
		region,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueMapBuffer :: #force_inline proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	blocking_map: bool,
	map_flags: MapFlags,
	offset: uint,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
	errcode_ret: ^i32,
) -> rawptr {
	return impl_EnqueueMapBuffer(
		command_queue,
		buffer,
		b8(blocking_map),
		map_flags,
		offset,
		size,
		num_events_in_wait_list,
		event_wait_list,
		event,
		errcode_ret,
	)
}

EnqueueMapImage :: #force_inline proc "c" (
	command_queue: CommandQueue,
	image: Memory,
	blocking_map: bool,
	map_flags: MapFlags,
	origin: ^uint,
	region: ^uint,
	image_row_pitch: ^uint,
	image_slice_pitch: ^uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
	errcode_ret: ^i32,
) -> rawptr {
	return impl_EnqueueMapImage(
		command_queue,
		image,
		b8(blocking_map),
		map_flags,
		origin,
		region,
		image_row_pitch,
		image_slice_pitch,
		num_events_in_wait_list,
		event_wait_list,
		event,
		errcode_ret,
	)
}

EnqueueUnmapMemObject :: #force_inline proc "c" (
	command_queue: CommandQueue,
	memobj: Memory,
	mapped_ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueUnmapMemObject(
		command_queue,
		memobj,
		mapped_ptr,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueNDRangeKernel :: #force_inline proc "c" (
	command_queue: CommandQueue,
	kernel: Kernel,
	work_dim: u32,
	global_work_offset: ^uint,
	global_work_size: ^uint,
	local_work_size: ^uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueNDRangeKernel(
		command_queue,
		kernel,
		work_dim,
		global_work_offset,
		global_work_size,
		local_work_size,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueNativeKernel :: #force_inline proc "c" (
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
) -> i32 {
	return impl_EnqueueNativeKernel(
		command_queue,
		user_func,
		args,
		cb_args,
		num_mem_objects,
		mem_list,
		args_mem_loc,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueReadBuffer :: #force_inline proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	blocking_read: bool,
	offset: uint,
	size: uint,
	ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueReadBuffer(
		command_queue,
		buffer,
		b8(blocking_read),
		offset,
		size,
		ptr,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueWriteBuffer :: #force_inline proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	blocking_write: bool,
	offset: uint,
	size: uint,
	ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueWriteBuffer(
		command_queue,
		buffer,
		b8(blocking_write),
		offset,
		size,
		ptr,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueCopyBuffer :: #force_inline proc "c" (
	command_queue: CommandQueue,
	src_buffer: Memory,
	dst_buffer: Memory,
	src_offset: uint,
	dst_offset: uint,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueCopyBuffer(
		command_queue,
		src_buffer,
		dst_buffer,
		src_offset,
		dst_offset,
		size,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueReadImage :: #force_inline proc "c" (
	command_queue: CommandQueue,
	image: Memory,
	blocking_read: bool,
	origin: ^uint,
	region: ^uint,
	row_pitch: uint,
	slice_pitch: uint,
	ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueReadImage(
		command_queue,
		image,
		b8(blocking_read),
		origin,
		region,
		row_pitch,
		slice_pitch,
		ptr,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueWriteImage :: #force_inline proc "c" (
	command_queue: CommandQueue,
	image: Memory,
	blocking_write: bool,
	origin: ^uint,
	region: ^uint,
	input_row_pitch: uint,
	input_slice_pitch: uint,
	ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueWriteImage(
		command_queue,
		image,
		b8(blocking_write),
		origin,
		region,
		input_row_pitch,
		input_slice_pitch,
		ptr,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}


/* Event Object APIs */
WaitForEvents :: #force_inline proc "c" (num_events: u32, event_list: [^]Event) -> i32 {
	return impl_WaitForEvents(num_events, event_list)
}

GetEventInfo :: #force_inline proc "c" (
	event: Event,
	param_name: EventInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {
	return impl_GetEventInfo(
		event,
		param_name,
		param_value_size,
		param_value,
		param_value_size_ret,
	)
}

RetainEvent :: #force_inline proc "c" (event: Event) -> i32 {return impl_RetainEvent(event)}
ReleaseEvent :: #force_inline proc "c" (event: Event) -> i32 {return impl_ReleaseEvent(event)}

/* Profiling APIs */
GetEventProfilingInfo :: #force_inline proc "c" (
	event: Event,
	param_name: ProfilingInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {
	return impl_GetEventProfilingInfo(
		event,
		param_name,
		param_value_size,
		param_value,
		param_value_size_ret,
	)
}


/* Flush and Finish APIs */
Flush :: #force_inline proc "c" (command_queue: CommandQueue) -> i32 {return impl_Flush(
		command_queue,
	)}
Finish :: #force_inline proc "c" (command_queue: CommandQueue) -> i32 {return impl_Finish(
		command_queue,
	)}


// CL_VERSION_1_1

EnqueueReadBufferRect :: #force_inline proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	blocking_read: bool,
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
) -> i32 {
	return impl_EnqueueReadBufferRect(
		command_queue,
		buffer,
		b8(blocking_read),
		buffer_origin,
		host_origin,
		region,
		buffer_row_pitch,
		buffer_slice_pitch,
		host_row_pitch,
		host_slice_pitch,
		ptr,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueWriteBufferRect :: #force_inline proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	blocking_write: bool,
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
) -> i32 {
	return impl_EnqueueWriteBufferRect(
		command_queue,
		buffer,
		b8(blocking_write),
		buffer_origin,
		host_origin,
		region,
		buffer_row_pitch,
		buffer_slice_pitch,
		host_row_pitch,
		host_slice_pitch,
		ptr,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueCopyBufferRect :: #force_inline proc "c" (
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
) -> i32 {
	return impl_EnqueueCopyBufferRect(
		command_queue,
		src_buffer,
		dst_buffer,
		src_origin,
		dst_origin,
		region,
		src_row_pitch,
		src_slice_pitch,
		dst_row_pitch,
		dst_slice_pitch,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}


/* Event Object APIs */

CreateUserEvent :: #force_inline proc "c" (
	cl_context: Context,
	errcode_ret: ^i32,
) -> Event {return impl_CreateUserEvent(cl_context, errcode_ret)}

SetUserEventStatus :: #force_inline proc "c" (
	event: Event,
	execution_status: i32,
) -> i32 {return impl_SetUserEventStatus(event, execution_status)}

SetEventCallback :: #force_inline proc "c" (
	event: Event,
	command_exec_callback_type: i32,
	pfn_notify: EventCallback,
	user_data: rawptr,
) -> i32 {
	return impl_SetEventCallback(event, command_exec_callback_type, pfn_notify, user_data)
}


// CL_VERSION_1_2

CreateProgramWithBuiltInKernels :: #force_inline proc "c" (
	cl_context: Context,
	num_devices: u32,
	device_list: [^]DeviceId,
	kernel_names: cstring,
	errcode_ret: ^i32,
) -> Program {
	return impl_CreateProgramWithBuiltInKernels(
		cl_context,
		num_devices,
		device_list,
		kernel_names,
		errcode_ret,
	)
}


CompileProgram :: #force_inline proc "c" (
	program: Program,
	num_devices: u32,
	device_list: [^]DeviceId,
	options: cstring,
	num_input_headers: u32,
	input_headers: [^]Program,
	header_include_names: [^]cstring,
	pfn_notify: ^ProgramCallback,
	user_data: rawptr,
) -> i32 {
	return impl_CompileProgram(
		program,
		num_devices,
		device_list,
		options,
		num_input_headers,
		input_headers,
		header_include_names,
		pfn_notify,
		user_data,
	)

}

LinkProgram :: #force_inline proc "c" (
	cl_context: Context,
	num_devices: u32,
	device_list: [^]DeviceId,
	options: cstring,
	num_input_programs: u32,
	input_programs: [^]Program,
	pfn_notify: ^ProgramCallback,
	user_data: rawptr,
	errcode_ret: ^i32,
) -> Program {
	return impl_LinkProgram(
		cl_context,
		num_devices,
		device_list,
		options,
		num_input_programs,
		input_programs,
		pfn_notify,
		user_data,
		errcode_ret,
	)
}

GetKernelArgInfo :: #force_inline proc "c" (
	kernel: Kernel,
	arg_indx: u32,
	param_name: KernelArgInfo,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {
	return impl_GetKernelArgInfo(
		kernel,
		arg_indx,
		param_name,
		param_value_size,
		param_value,
		param_value_size_ret,
	)
}

// Enqueue
EnqueueFillBuffer :: #force_inline proc "c" (
	command_queue: CommandQueue,
	buffer: Memory,
	pattern: rawptr,
	pattern_size: uint,
	offset: uint,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueFillBuffer(
		command_queue,
		buffer,
		pattern,
		pattern_size,
		offset,
		size,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueFillImage :: #force_inline proc "c" (
	command_queue: CommandQueue,
	image: Memory,
	fill_color: rawptr,
	origin: ^uint,
	region: ^uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueFillImage(
		command_queue,
		image,
		fill_color,
		origin,
		region,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueMigrateMemObjects :: #force_inline proc "c" (
	command_queue: CommandQueue,
	num_mem_objects: u32,
	mem_objects: [^]Memory,
	flags: MemMigrationFlags,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueMigrateMemObjects(
		command_queue,
		num_mem_objects,
		mem_objects,
		flags,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueMarkerWithWaitList :: #force_inline proc "c" (
	command_queue: CommandQueue,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueMarkerWithWaitList(
		command_queue,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueBarrierWithWaitList :: #force_inline proc "c" (
	command_queue: CommandQueue,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueBarrierWithWaitList(
		command_queue,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}


// CL_VERSION_2_0
CreateCommandQueueWithProperties :: #force_inline proc "c" (
	cl_context: Context,
	device: DeviceId,
	properties: ^CommandQueueProperties,
	errcode_ret: ^i32,
) -> CommandQueue {return impl_CreateCommandQueueWithProperties(
		cl_context,
		device,
		properties,
		errcode_ret,
	)}


SetKernelArgSVMPointer :: #force_inline proc "c" (
	kernel: Kernel,
	arg_index: u32,
	arg_value: rawptr,
) -> i32 {
	return impl_SetKernelArgSVMPointer(kernel, arg_index, arg_value)
}

SetKernelExecInfo :: #force_inline proc "c" (
	kernel: Kernel,
	param_name: KernelExecInfo,
	param_value_size: uint,
	param_value: rawptr,
) -> i32 {
	return impl_SetKernelExecInfo(kernel, param_name, param_value_size, param_value)
}


// Enqueue
EnqueueSVMFree :: #force_inline proc "c" (
	command_queue: CommandQueue,
	num_svm_pointers: u32,
	svm_pointers: [^]rawptr,
	pfn_free_func: ^MemFreeCallback,
	user_data: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueSVMFree(
		command_queue,
		num_svm_pointers,
		svm_pointers,
		pfn_free_func,
		user_data,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueSVMMemcpy :: #force_inline proc "c" (
	command_queue: CommandQueue,
	blocking_copy: bool,
	dst_ptr: rawptr,
	src_ptr: rawptr,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueSVMMemcpy(
		command_queue,
		b8(blocking_copy),
		dst_ptr,
		src_ptr,
		size,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueSVMMemFill :: #force_inline proc "c" (
	command_queue: CommandQueue,
	svm_ptr: rawptr,
	pattern: rawptr,
	pattern_size: uint,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueSVMMemFill(
		command_queue,
		svm_ptr,
		pattern,
		pattern_size,
		size,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueSVMMap :: #force_inline proc "c" (
	command_queue: CommandQueue,
	blocking_map: bool,
	flags: MapFlags,
	svm_ptr: rawptr,
	size: uint,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueSVMMap(
		command_queue,
		b8(blocking_map),
		flags,
		svm_ptr,
		size,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

EnqueueSVMUnmap :: #force_inline proc "c" (
	command_queue: CommandQueue,
	svm_ptr: rawptr,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueSVMUnmap(
		command_queue,
		svm_ptr,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

// CL_VERSION_2_1

CreateProgramWithIL :: #force_inline proc "c" (
	cl_context: Context,
	il: rawptr,
	length: uint,
	errcode_ret: ^i32,
) -> Program {
	return impl_CreateProgramWithIL(cl_context, il, length, errcode_ret)
}


CloneKernel :: #force_inline proc "c" (source_kernel: Kernel, errcode_ret: ^i32) -> Kernel {
	return impl_CloneKernel(source_kernel, errcode_ret)
}

GetKernelSubGroupInfo :: #force_inline proc "c" (
	kernel: Kernel,
	device: DeviceId,
	param_name: KernelSubGroupInfo,
	input_value_size: uint,
	input_value: rawptr,
	param_value_size: uint,
	param_value: rawptr,
	param_value_size_ret: ^uint,
) -> i32 {
	return impl_GetKernelSubGroupInfo(
		kernel,
		device,
		param_name,
		input_value_size,
		input_value,
		param_value_size,
		param_value,
		param_value_size_ret,
	)
}

EnqueueSVMMigrateMem :: #force_inline proc "c" (
	command_queue: CommandQueue,
	num_svm_pointers: u32,
	svm_pointers: [^]rawptr,
	sizes: [^]uint,
	flags: MemFlags,
	num_events_in_wait_list: u32,
	event_wait_list: [^]Event,
	event: ^Event,
) -> i32 {
	return impl_EnqueueSVMMigrateMem(
		command_queue,
		num_svm_pointers,
		svm_pointers,
		sizes,
		flags,
		num_events_in_wait_list,
		event_wait_list,
		event,
	)
}

// CL_VERSION_2_2

// Deprecated in Version 2.2
SetProgramReleaseCallback :: #force_inline proc "c" (
	program: Program,
	pfn_notify: ^ProgramCallback,
	user_data: rawptr,
) -> i32 {
	return impl_SetProgramReleaseCallback(program, pfn_notify, user_data)
}
SetProgramSpecializationConstant :: #force_inline proc "c" (
	program: Program,
	spec_id: u32,
	spec_size: uint,
	spec_value: rawptr,
) -> i32 {
	return impl_SetProgramSpecializationConstant(program, spec_id, spec_size, spec_value)
}

// CL_VERSION_3_0

CreateBufferWithProperties :: #force_inline proc "c" (
	cl_context: Context,
	properties: [^]u64,
	flags: MemFlags,
	size: uint,
	host_ptr: rawptr,
	errcode_ret: ^i32,
) -> Memory {
	return impl_CreateBufferWithProperties(
		cl_context,
		properties,
		flags,
		size,
		host_ptr,
		errcode_ret,
	)
}

