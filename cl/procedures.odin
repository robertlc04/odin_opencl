package cl

import "base:runtime"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:reflect"
import "core:strings"
import "core:text/regex"

// Just one mode: Use directly the wrapper functions without abstractions layers for the user (easy too but a little repetitive)

// Platform
get_available_platforms :: proc(
	allocator: mem.Allocator = context.temp_allocator,
) -> (
	result: []Platform_t,
	err: ErrorCodes,
) {

	// Get Platforms
	numPlatforms: u32
	// TODO: Make a Custom ErrorCodes for cases in numPlatform it's 0

	err = ErrorCodes(GetPlatformIDs(0, nil, &numPlatforms))
	if err != ErrorCodes.SUCCESS do return nil, err

	if numPlatforms == 0 do return nil, ErrorCodes.SUCCESS

	platforms := make([]PlatformId, numPlatforms, context.temp_allocator)
	err = ErrorCodes(GetPlatformIDs(numPlatforms, &platforms[0], nil))
	if err != ErrorCodes.SUCCESS do return nil, err

	result = make([]Platform_t, numPlatforms, allocator)

	// Get the basic Information
	for &platform, i in result {
		platform.id = platforms[i]

		get_platform_field(&platform, .NAME, "name", []u8) or_return
		get_platform_field(&platform, .PROFILE, "profile", []u8) or_return
		get_platform_field(&platform, .VENDOR, "vendor", []u8) or_return
		get_platform_field(&platform, .VERSION, "version", []u8) or_return
		get_platform_field(&platform, .EXTENSIONS, "extensions", []u8) or_return
	}

	return result, err
}

@(private)
get_platform_field :: proc(
	platform: ^Platform_t,
	field: PlatformInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {
	numItems: uint
	err = GetPlatformInfo(platform.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(platform, err)
		return
	}
	info_raw := make(T, numItems, context.temp_allocator)
	err = GetPlatformInfo(platform.id, field, u32(numItems), &info_raw[0], &numItems)

	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(platform, err)
		return
	}
	test := reflect.struct_field_by_name(PlatformInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&platform.info) + test.offset)

	(^T)(field_ptr)^ = info_raw[:len(info_raw) - 1]
	// field_ptr = mem.copy(field_ptr, &info_raw[0], len(info_raw))

	return
}

// Device
get_available_devices :: proc(
	platform: Platform_t,
	device_type: DeviceType = .ALL,
) -> (
	result: []Device_t,
	err: ErrorCodes,
) {
	numDevices: u32
	GetDeviceIDs(platform.id, .ALL, 0, nil, &numDevices) or_return

	if numDevices == 0 do return nil, .SUCCESS

	devices := make([]DeviceId, numDevices, context.temp_allocator)
	err = GetDeviceIDs(platform.id, device_type, numDevices, raw_data(devices), nil)
	if err == .DEVICE_NOT_FOUND do return nil, .SUCCESS
	if err != .SUCCESS do return nil, err


	result = make([]Device_t, numDevices, context.temp_allocator)


	for &device, i in result {
		device.id = devices[i]
		// Get the basic Information
		get_device_basic_field(&device, .NAME, "name", []u8) or_return
		get_device_basic_field(&device, .PROFILE, "profile", []u8) or_return
		get_device_basic_field(&device, .VENDOR, "vendor", []u8) or_return
		get_device_basic_field(&device, .EXTENSIONS, "extensions", []u8) or_return
		get_device_basic_field(&device, .VERSION, "version", []u8) or_return
		get_device_basic_field(&device, .DRIVER_VERSION, "driver_version", []u8) or_return
		get_device_basic_field(&device, .IL_VERSION, "il_version", []u8) or_return
		// Advance Information
		get_device_single_field(&device, .ENDIAN_LITTLE, "little_endian", u32) or_return
		get_device_single_field(&device, .AVAILABLE, "available", u32) or_return
		get_device_single_field(&device, .PARENT_DEVICE, "parent", DeviceId) or_return
		get_device_single_field(&device, .SVM_CAPABILITIES, "svm_capabilities", u64) or_return
		get_device_single_field(&device, .SINGLE_FP_CONFIG, "single_fp_config", u64) or_return
	}

	return result, err
}


destroy_devices :: proc(devices: []Device_t) {
	err: ErrorCodes
	for dev in devices {
		if dev.info.parent != nil {
			err = ReleaseDevice(dev.id)
			when ODIN_DEBUG do debug_get_informations(dev, err)
			check(err)
		}
	}
}

@(private)
get_device_basic_field :: proc(
	device: ^Device_t,
	field: DeviceInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {
	numItems: uint
	err = GetDeviceInfo(device.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}

	info_raw := make(T, numItems, context.temp_allocator)
	err = GetDeviceInfo(device.id, field, u32(numItems), &info_raw[0], &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}

	test := reflect.struct_field_by_name(DeviceInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&device.info) + test.offset)

	(^T)(field_ptr)^ = info_raw[:len(info_raw) - 1]

	return
}

@(private)
get_device_single_field :: proc(
	device: ^Device_t,
	field: DeviceInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {
	numItems: uint
	err = GetDeviceInfo(device.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}

	info_raw := make([]T, numItems, context.temp_allocator)
	err = GetDeviceInfo(device.id, field, u32(numItems), &info_raw[0], nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}

	test := reflect.struct_field_by_name(DeviceInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&device.info) + test.offset)

	(^T)(field_ptr)^ = info_raw[0]

	return
}

// Cl Context
// NOTE: This it's a basic default if you(as user) want more control you can use the CreateContext procedure for better control of your needs
get_context :: proc(
	ctx: ^Context_t,
	devices: []Device_t,
	properties: []ContextProperties = {},
	from_type: bool = false,
	device_t: DeviceType = DeviceType.CPU,
) -> (
	err: ErrorCodes,
) {
	if from_type {
		ctx.id = CreateContextFromType(raw_data(properties), device_t, nil, nil, &err)
	} else {
		device_id := make([]DeviceId, len(devices), context.temp_allocator)
		for dev, i in devices {
			device_id[i] = dev.id
		}
		ctx.id = CreateContext(
			raw_data(properties),
			u32(len(devices)),
			raw_data(device_id),
			nil,
			nil,
			&err,
		)

	}

	get_context_single_field(ctx, .CONTEXT_REFERENCE_COUNT, "ref_count", u32) or_return
	get_context_single_field(ctx, .CONTEXT_NUM_DEVICES, "num_devices", u32) or_return
	get_context_single_field(ctx, .CONTEXT_PROPERTIES, "properties", ContextProperties) or_return

	return
}

destroy_context :: proc(ctx: Context_t) {
	err: ErrorCodes
	err = ReleaseContext(ctx.id)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(ctx, err)
		check(err)
	}
}

@(private)
get_context_single_field :: proc(
	ctx: ^Context_t,
	field: ContextInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {
	numItems: uint
	err = GetContextInfo(ctx.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(ctx, err)
		return
	}
	if numItems == 0 do return

	info_raw := make([]T, numItems, context.temp_allocator)
	err = GetContextInfo(ctx.id, field, numItems, &info_raw[0], nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(ctx, err)
		return
	}

	test := reflect.struct_field_by_name(ContextInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&ctx.info) + test.offset)

	(^T)(field_ptr)^ = info_raw[0]

	return
}

// Command Queue Management

@(private)
get_command_queue_single_field :: proc(
	cmd_queue: ^CommandQueue_t,
	field: CommandQueueInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {
	numItems: uint
	err = GetCommandQueueInfo(cmd_queue.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(cmd_queue, err)
		return
	}
	if numItems == 0 do return

	info_raw := make([]T, numItems, context.temp_allocator)
	err = GetCommandQueueInfo(cmd_queue.id, field, numItems, &info_raw[0], nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(cmd_queue, err)
		return
	}

	test := reflect.struct_field_by_name(CommandQueueInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&cmd_queue.info) + test.offset)

	(^T)(field_ptr)^ = info_raw[0]

	return
}

@(private)
get_command_queue_list_field :: proc(
	cmd_queue: ^CommandQueue_t,
	field: CommandQueueInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {
	numItems: uint
	// FIXME: Problems with empty properties
	err = GetCommandQueueInfo(cmd_queue.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(cmd_queue, err)
		return
	}
	if numItems == 0 do return

	info_raw := make(T, numItems, context.temp_allocator)
	err = GetCommandQueueInfo(cmd_queue.id, field, numItems, &info_raw[0], nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(cmd_queue, err)
		return
	}

	test := reflect.struct_field_by_name(CommandQueueInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&cmd_queue.info) + test.offset)

	(^T)(field_ptr)^ = info_raw

	return
}

append_cmd_queue_properties :: proc(
	cmd: ^CommandQueueProperties_t,
	properties: []CommandQueueProperties,
) {
	cmd.key = .QUEUE_PROPERTIES
	for val in properties {
		cmd.value &= u64(val)
	}
}

get_command_queue :: proc(
	ctx: Context_t,
	devices: []Device_t,
	properties: []CommandQueueProperties_t = {},
) -> (
	cmd: []CommandQueue_t,
	err: ErrorCodes,
) {
	// Get id

	cmd = make([]CommandQueue_t, len(devices), context.temp_allocator)
	for dev, i in devices {
		cmd[i].id = CreateCommandQueueWithProperties(ctx.id, dev.id, properties, &err)
		if err != .SUCCESS {
			when ODIN_DEBUG do debug_get_informations(devices, err)
			return
		}

		if cmd == nil {
			log.panic("Something get wrong with the wrapper or with the OpenCL lib")
		}

	}

	for &cmd_queue in cmd {
		get_command_queue_single_field(&cmd_queue, .QUEUE_CONTEXT, "ctx_id", Context) or_return
		get_command_queue_single_field(&cmd_queue, .QUEUE_DEVICE, "dev_id", DeviceId) or_return
		// TODO: Fix Properties get
		get_command_queue_list_field(
			&cmd_queue,
			.QUEUE_PROPERTIES_ARRAY,
			"properties",
			[]CommandQueueInfo,
		) or_return

	}

	return
}

destroy_command_queue :: proc(cmd_queue: []CommandQueue_t) {
	err: ErrorCodes
	for cmd in cmd_queue {
		if err = ReleaseCommandQueue(cmd.id); err != .SUCCESS {
			when ODIN_DEBUG do debug_get_informations(cmd, err)
			check(err)
		}
	}
}

// For now only full path
get_program :: proc(
	ctx: Context_t,
	dev: Device_t,
	program: ^Program_t,
	file_path: string = "",
	il_data: []u8 = {},
) -> (
	err: ErrorCodes,
) {

	if len(il_data) != 0 {
		program.id = CreateProgramWithIL(ctx.id, il_data, &err)

		if err != .SUCCESS {
			when ODIN_DEBUG do debug_get_informations(program, err)
			check(err)

		}
	} else {
		raw, ok := os.read_entire_file_from_filename(file_path, context.temp_allocator)
		source := strings.clone_to_cstring(transmute(string)raw, context.temp_allocator)

		if ok do program.id = CreateProgramWithSource(ctx.id, 1, {source}, &err)
	}


	if program.id == nil {
		err = .INVALID_KERNEL
		return
	}


	// Build
	BuildProgram(program.id, {dev.id}, "", nil, nil) or_return

	// Info
	get_program_info_single_field(program, .CONTEXT, "ctx", Context) or_return

	get_program_info_list_field(program, .DEVICES, "devs", []DeviceId) or_return
	// FIXME: Bug on the kernels_name who it's overflowing for the next value "status"
	// CAUTION: Weird bug sometimes from the API way i don't know
	get_program_build_info_field(program, dev, .LOG, "logs", []u8)
	get_program_build_info_single_field(program, dev, .STATUS, "status", BuildStatus)

	// PostProcessing logs if they have
	get_kernels(program)

	return
}


destroy_program :: proc(programs: []Program_t) {
	err: ErrorCodes

	for program in programs {
		// Release Kernels
		for kernel in program.kernels {
			if err = ReleaseKernel(kernel.id); err != .SUCCESS {
				when ODIN_DEBUG do debug_get_informations(program, err)
				check(err)
			}
		}
		if err = ReleaseProgram(program.id); err != .SUCCESS {
			when ODIN_DEBUG do debug_get_informations(program, err)
			check(err)
		}
	}
	// delete(programs)
}

@(private)
get_program_info_single_field :: proc(
	program: ^Program_t,
	field: ProgramInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {
	numItems: uint
	err = GetProgramInfo(program.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(program, err)
		return
	}

	info_raw := make([]T, numItems, context.temp_allocator)
	err = GetProgramInfo(program.id, field, numItems, &info_raw[0], &numItems)

	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(program, err)
		return
	}

	test := reflect.struct_field_by_name(ProgramInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&program.info) + test.offset)

	(^T)(field_ptr)^ = info_raw[0]

	return
}


@(private)
get_program_info_list_field :: proc(
	program: ^Program_t,
	field: ProgramInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {

	numItems: uint
	err = GetProgramInfo(program.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(program, err)
		return
	}
	info_raw := make(T, numItems, context.temp_allocator)
	err = GetProgramInfo(program.id, field, numItems, &info_raw[0], &numItems)

	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(program, err)
		return
	}

	test := reflect.struct_field_by_name(ProgramInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&program.info) + test.offset)

	(^T)(field_ptr)^ = info_raw

	return
}

@(private)
get_program_build_info_single_field :: proc(
	program: ^Program_t,
	dev: Device_t,
	field: ProgramBuildInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {

	numItems: uint
	err = GetProgramBuildInfo(program.id, dev.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(program, err)
		return
	}


	info_raw := make([]T, numItems, context.temp_allocator)
	err = GetProgramBuildInfo(program.id, dev.id, field, numItems, &info_raw[0], &numItems)

	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(program, err)
		return
	}

	test := reflect.struct_field_by_name(ProgramBuildInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&program.build_info) + test.offset)

	(^T)(field_ptr)^ = info_raw[0]

	return
}

@(private)
get_program_build_info_field :: proc(
	program: ^Program_t,
	dev: Device_t,
	field: ProgramBuildInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {
	numItems: uint
	err = GetProgramBuildInfo(program.id, dev.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(program, err)
		return
	}


	info_raw := make(T, numItems, context.temp_allocator)
	err = GetProgramBuildInfo(program.id, dev.id, field, numItems, &info_raw[0], &numItems)

	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(program, err)
		return
	}

	test := reflect.struct_field_by_name(ProgramBuildInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&program.build_info) + test.offset)

	(^T)(field_ptr)^ = info_raw[:len(info_raw) - 1]
	// field_ptr = mem.copy(field_ptr, &info_raw[0], len(info_raw))

	return
}

get_kernels :: proc(program: ^Program_t) -> (err: ErrorCodes) {

	kernelItems: u32
	err = CreateKernelsInProgram(program.id, 0, nil, &kernelItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(program, err)
		return
	}

	kernel := make([]Kernel, kernelItems, context.temp_allocator)
	err = CreateKernelsInProgram(program.id, kernelItems, raw_data(kernel), nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(program, err)
		return
	}

	program.kernels = make([]Kernel_t, kernelItems, context.temp_allocator)


	for &kernel_val, i in program.kernels {
		kernel_val.id = kernel[i]
		get_kernel_info_single_field(&kernel_val, .REFERENCE_COUNT, "ref_count", u32) or_return
		get_kernel_info_list_field(&kernel_val, .FUNCTION_NAME, "name", []u8)
		get_kernel_args(&kernel_val) or_return
	}


	return
}


@(private)
get_kernel_info_single_field :: proc(
	kernel: ^Kernel_t,
	field: KernelInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {

	numItems: uint
	err = GetKernelInfo(kernel.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(kernel, err)
		return
	}


	info_raw := make([]T, numItems, context.temp_allocator)
	err = GetKernelInfo(kernel.id, field, numItems, &info_raw[0], &numItems)

	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(kernel, err)
		return
	}

	test := reflect.struct_field_by_name(KernelInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&kernel.info) + test.offset)

	(^T)(field_ptr)^ = info_raw[0]

	return
}


@(private)
get_kernel_info_list_field :: proc(
	kernel: ^Kernel_t,
	field: KernelInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: ErrorCodes,
) {

	numItems: uint
	err = GetKernelInfo(kernel.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(kernel, err)
		return
	}
	info_raw := make(T, numItems, context.temp_allocator)
	err = GetKernelInfo(kernel.id, field, numItems, &info_raw[0], &numItems)

	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(kernel, err)
		return
	}

	test := reflect.struct_field_by_name(KernelInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&kernel.info) + test.offset)

	(^T)(field_ptr)^ = info_raw[:len(info_raw) - 1]

	return
}

@(private)
get_kernel_args :: proc(kernel: ^Kernel_t) -> (err: ErrorCodes) {
	numArgs: uint
	err = GetKernelInfo(kernel.id, .NUM_ARGS, 0, nil, &numArgs)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(kernel, err)
		return
	}

	args := make([]u32, numArgs, context.temp_allocator)

	err = GetKernelInfo(kernel.id, .NUM_ARGS, numArgs, &args[0], nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(kernel, err)
		return
	}


	kernel.args = make([]KernelArgsInfo_t, args[0], context.temp_allocator)

	for &args, i in kernel.args {
		args.type, err = get_kernel_arg_value(kernel^, u32(i), .TYPE_NAME)
		if err != .SUCCESS do return
		args.name, err = get_kernel_arg_value(kernel^, u32(i), .NAME)
		if err != .SUCCESS do return
		get_kernel_arg_qualifier(kernel, u32(i), .ACCESS_QUALIFIER) or_return
	}


	return
}

@(private)
get_kernel_arg_value :: proc(
	kernel: Kernel_t,
	index: u32,
	field: KernelArgInfo,
) -> (
	data: string,
	err: ErrorCodes,
) {
	numValues: uint
	err = GetKernelArgInfo(kernel.id, index, field, 0, nil, &numValues)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(kernel, err)
		return
	}
	value := make([]u8, numValues, context.temp_allocator)
	err = GetKernelArgInfo(kernel.id, index, field, numValues, &value[0], nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(kernel, err)
		return
	}

	data = transmute(string)value[:len(value) - 1]
	return
}

// TODO: Make a general procedure like for the others
@(private)
get_kernel_arg_qualifier :: proc(
	kernel: ^Kernel_t,
	index: u32,
	field: KernelArgInfo,
) -> (
	err: ErrorCodes,
) {

	numValues: uint
	err = GetKernelArgInfo(kernel.id, index, field, 0, nil, &numValues)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(kernel, err)
		return
	}
	value := make([]KernelArgAddressQualifier, numValues, context.temp_allocator)
	err = GetKernelArgInfo(kernel.id, index, field, numValues, &value[0], nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(kernel, err)
		return
	}

	// FIX LATER: this it's a temporal hack for working :D
	kernel.args[index].qualifier = KernelArgAddressQualifier(u32(value[0]) - 8) // Hack cause im getting bad things :C
	return
}

// For now no properties and host_ptr are available :D
// The T it's the type of the buffer must match the type of the kernel
get_buffer :: proc(
	ctx: Context_t,
	flags: []MemFlags,
	size: uint,
	$T: typeid,
	host_ptr: rawptr = nil,
) -> (
	buffer: Buffer_t,
	err: ErrorCodes,
) {
	if ctx.id == nil do return {}, .INVALID_CONTEXT

	buffer.flags = flags
	buffer.id = CreateBuffer(ctx.id, flags, size_of(typeid_of(T)) * size, host_ptr, &err)
	if err != .SUCCESS {
		if err == .INVALID_HOST_PTR {
			log.debugf(
				"You set a MEM_HOST flag in a invalid memory address.\n\tHost address: %p",
				host_ptr,
			)
		}
		return {}, err
	}
	buffer.size = size_of(typeid_of(T)) * size
	buffer.type = T
	return
}

destroy_buffer :: proc(buffer: Buffer_t) -> (err: ErrorCodes) {
	if buffer.id == nil do return .INVALID_VALUE
	err = ReleaseMemObject(buffer.id)
	return
}

// No event supported for now
// For personal choise i decide always return a slice instead of use a pointer just for simplicity 
// Maybe this will change on the future
read_buffer :: proc(
	cmd: CommandQueue_t,
	buffer: Buffer_t,
	blocking_read: bool,
	offset: uint,
	size: uint,
	$T: typeid,
) -> (
	data: []T,
	err: ErrorCodes,
) {
	data = make([]T, size, context.temp_allocator)
	err = EnqueueReadBuffer(cmd.id, buffer.id, blocking_read, offset, T, data)
	if err != .SUCCESS do return nil, err

	return
}


write_buffer :: proc(
	cmd: CommandQueue_t,
	buffer: Buffer_t,
	$T: typeid,
	data: []T,
	blocking_write: bool = true,
	offset: uint = 0,
) -> (
	err: ErrorCodes,
) {

	err = EnqueueWriteBuffer(cmd.id, buffer.id, blocking_write, offset, T, data)

	return
}

@(private)
// TODO: Verification if the type it's vectored so the value of the storages are sutiable
// Maybe make custom vector types and make it use that for prevent the user make mistakes 
verify_kernel_arg_type :: proc(kernel: KernelArgsInfo_t, arg: Buffer_t) -> (err: ErrorCodes) {
	// log.debugf("Kernel info: %v", kernel)
	// The arg match the needed vector if exist?
	data_type := arg.type


	// the capture always gone be 4
	rex, ok2 := regex.create(`([a-zA-Z]+)(\d*)(\*?)`, {}, context.temp_allocator)
	cap, ok3 := regex.match(rex, kernel.type)
	cleaning_sufix :=
		strings.concatenate({cap.groups[1], "n"}, context.temp_allocator) if len(cap.groups[2]) > 0 else cap.groups[1]

	val, ok := reflect.enum_from_name(
		KernelArg_t,
		strings.to_upper(cleaning_sufix, context.temp_allocator),
	)

	if !ok do return .INVALID_ARG_VALUE

	data_info := type_info_of(data_type)
	cmp_info := KernelArgDesc_t[val]

	if reflect.are_types_identical(cmp_info, data_info) do return

	if reflect.type_kind(cmp_info.id) == reflect.type_kind(data_info.id) {
		#partial switch val in cmp_info.variant {
		case runtime.Type_Info_Integer:
			{
				if data_info.size < cmp_info.size {
					fmt.printfln(
						"[Error!] Using different size of type in  \"%s\", want's %d",
						kernel.name,
						cmp_info.size * cmp_info.align,
					)
					return .INVALID_KERNEL_ARGS
				}
				fmt.printfln(
					"[Warning!] Be careful you are using a different signed type in  \"%s\", want's %s type",
					kernel.name,
					"signed" if val.signed else "unsigned",
				)
				return

			}
		case runtime.Type_Info_Float:
			{
				if cmp_info.size != data_info.size {

					fmt.printfln(
						"[Error!] Using a different size float type in  \"%s\", want's f%d type",
						kernel.name,
						cmp_info.size * cmp_info.align,
					)
					return .INVALID_KERNEL_ARGS
				}
				return
			}
		case:
			return

		}
	}


	return .INVALID_KERNEL_ARGS
}

// TODO: The type getted can be used as a token for make a type checker for the user
// ref to: https://registry.khronos.org/OpenCL/sdk/3.0/docs/man/html/scalarDataTypes.html
set_kernel_args :: proc(kernel: Kernel_t, data: []Buffer_t) -> (err: ErrorCodes) {
	if len(kernel.args) - len(data) != 0 do return .INVALID_ARG_SIZE

	for info, i in kernel.args {
		verify_kernel_arg_type(info, data[i]) or_return
		SetKernelArg(kernel.id, u32(i), type_of(data[i].id), &data[i].id) or_return
	}

	return
}

// TODO: Make SetArgKernel more friendly for usage or make a procedure how take arg: any and create a KernelArg_t.
// TODO: Finish Program Procedure and Make Kernel Procedure 
// TODO: Make in the Readme a explain of how use the callback procedures
// TODO: Make event support and make a example using it
// TODO: Better error explain on the future -> Every procedure have it's one cause of errors. NOTE: this shit gone be painful for write :"D

