package cl

import "base:intrinsics"
import "base:runtime"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:path/filepath"
import "core:reflect"

// Just one mode: Use directly the wrapper functions without abstractions layers for the user (easy too but a little repetitive)

// Platform
get_available_platforms :: proc() -> (result: []Platform_t, err: ErrorCodes) {

	// Get Platforms
	numPlatforms: u32
	// TODO: Make a Custom ErrorCodes for cases in numPlatform it's 0

	err = ErrorCodes(GetPlatformIDs(0, nil, &numPlatforms))
	if err != ErrorCodes.SUCCESS do return nil, err

	if numPlatforms == 0 do return nil, ErrorCodes.SUCCESS

	platforms := make([]PlatformId, numPlatforms, context.temp_allocator)
	err = ErrorCodes(GetPlatformIDs(numPlatforms, &platforms[0], nil))
	if err != ErrorCodes.SUCCESS do return nil, err

	result = make([]Platform_t, numPlatforms, context.allocator)

	// Get the basic Information
	for &platform, i in result {
		platform.id = platforms[i]

		get_platform_field(&platform, .PLATFORM_NAME, "name", cstring) or_return
		get_platform_field(&platform, .PLATFORM_PROFILE, "profile", cstring) or_return
		get_platform_field(&platform, .PLATFORM_VENDOR, "vendor", cstring) or_return
		get_platform_field(&platform, .PLATFORM_VERSION, "version", cstring) or_return
		get_platform_field(&platform, .PLATFORM_EXTENSIONS, "extensions", cstring) or_return
	}

	return result, err
}

destroy_platforms :: proc(platforms: []Platform_t) {
	delete(platforms)
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
	info_raw := make([]u8, numItems, context.temp_allocator)
	err = GetPlatformInfo(platform.id, field, u32(numItems), &info_raw[0], &numItems)

	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(platform, err)
		return
	};test := reflect.struct_field_by_name(PlatformInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&platform.info) + test.offset)

	(^T)(field_ptr)^ = T(&info_raw[0])
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
	err = GetDeviceIDs(platform.id, .ALL, 0, nil, &numDevices)

	if err != .SUCCESS do return nil, err
	if numDevices == 0 do return nil, .SUCCESS

	devices := make([]DeviceId, numDevices, context.temp_allocator)
	err = GetDeviceIDs(platform.id, device_type, numDevices, &devices[0], nil)
	if err == .DEVICE_NOT_FOUND do return nil, .SUCCESS
	if err != .SUCCESS do return nil, err

	result = make([]Device_t, numDevices, context.allocator)


	for &device, i in result {
		device.id = devices[i]
		// Get the basic Information
		get_device_basic_field(&device, .DEVICE_NAME, "name", cstring) or_return
		get_device_basic_field(&device, .DEVICE_PROFILE, "profile", cstring) or_return
		get_device_basic_field(&device, .DEVICE_VENDOR, "vendor", cstring) or_return
		get_device_basic_field(&device, .DEVICE_EXTENSIONS, "extensions", cstring) or_return
		get_device_basic_field(&device, .DEVICE_VERSION, "version", cstring) or_return
		get_device_basic_field(&device, .DRIVER_VERSION, "driver_version", cstring) or_return
		get_device_basic_field(&device, .DEVICE_IL_VERSION, "il_version", cstring) or_return
		// // Advance Information

		// FIXME: There is a problem with the booleans but i don't know what's happening
		// if err = get_device_single_field(&device, .DEVICE_ENDIAN_LITTLE, "little_endian", bool); err != .SUCCESS do return nil, err
		// get_device_single_field(&device, .DEVICE_AVAILABLE, "available", b8) or_return
		get_device_single_field(&device, .DEVICE_PARENT_DEVICE, "parent", DeviceId) or_return
		get_device_single_field(
			&device,
			.DEVICE_SVM_CAPABILITIES,
			"svm_capabilities",
			u64,
		) or_return
		get_device_single_field(
			&device,
			.DEVICE_SINGLE_FP_CONFIG,
			"single_fp_config",
			u64,
		) or_return
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
	delete(devices)
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

	info_raw := make([]u8, numItems, context.temp_allocator)
	err = GetDeviceInfo(device.id, field, u32(numItems), &info_raw[0], &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}

	test := reflect.struct_field_by_name(DeviceInfo_t, struct_field)

	field_ptr := rawptr(uintptr(&device.info) + test.offset)

	(^T)(field_ptr)^ = T(&info_raw[0])

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

	(^T)(field_ptr)^ = T(info_raw[0])

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

	(^T)(field_ptr)^ = T(info_raw[0])

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

	(^T)(field_ptr)^ = T(info_raw[0])

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

	// (^T)(field_ptr) = T(&info_raw[0])
	field_ptr = mem.copy(field_ptr, &info_raw[0], len(info_raw))

	log.debugf("Value info: %v", info_raw)
	log.debugf("Value info: %v", (^T)(field_ptr)^)

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

	cmd = make([]CommandQueue_t, len(devices), context.allocator)
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
			.QUEUE_PROPERTIES,
			"properties",
			CommandQueueInfo,
		) or_return

	}


	when ODIN_DEBUG {
		for cmd_queue, i in cmd {
			log.debug("========= Verify if informations are different ==========")
			log.debugf("Created with:\nContext: %v\nDevice: %v", ctx.id, devices[i].id)
			log.debugf(
				"Actual Data:\nContext: %v\nDevice: %v",
				cmd_queue.info.ctx_id,
				cmd_queue.info.dev_id,
			)
		}
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
	delete(cmd_queue)
}

// For now only full path
get_program :: proc(
	ctx: Context_t,
	program: ^Program_t,
	file_path: string,
	il_data: []u8,
) -> (
	err: ErrorCodes,
) {
	if len(il_data) != 0 {
		program.id = CreateProgramWithIL(ctx.id, il_data, &err)
	} else {
		if filepath.is_abs(file_path) {
			raw, ok := os.read_entire_file_from_filename(file_path)
			source := transmute([]cstring)raw

			if ok do program.id = CreateProgramWithSource(ctx.id, 1, source, &err)
		}
	}


	return
}

