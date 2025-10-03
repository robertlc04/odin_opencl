package cl

import "base:intrinsics"
import "base:runtime"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:reflect"

import clc "./core"
// TODO: Define two modes of use the Wrapper API for the user
// Direct Mode: Use directly the wrapper functions without abstractions layers for the user (easy too but a little repetitive)
// Normal Mode: Use the abstraction layer provided (easy mode)

// Things are repetitive and anoying
// Select and list available Platforms and show it's information

debug_get_informations :: proc(
	structure: any,
	error: clc.ErrorCodes,
	location := #caller_location,
) {
	log.debugf("Called from %d: %s", location.line, location.procedure)
	log.debugf("Structure: %v", structure)
	log.debugf("Error desc: %s", clc.ErrorCodes_Descriptions[error])
}
// Platform
get_available_platforms :: proc() -> (result: []Platform, err: clc.ErrorCodes) {

	// Get Platforms
	numPlatforms: u32
	// TODO: Make a Custom ErrorCodes for cases in numPlatform it's 0

	err = clc.ErrorCodes(clc.GetPlatformIDs(0, nil, &numPlatforms))
	if err != clc.ErrorCodes.SUCCESS do return nil, err

	if numPlatforms == 0 do return nil, clc.ErrorCodes.SUCCESS

	platforms := make([]clc.PlatformId, numPlatforms, context.temp_allocator)
	err = clc.ErrorCodes(clc.GetPlatformIDs(numPlatforms, &platforms[0], nil))
	if err != clc.ErrorCodes.SUCCESS do return nil, err

	result = make([]Platform, numPlatforms, context.allocator)

	// Get the basic Information
	for &platform, i in result {
		platform.id = platforms[i]

		if err = get_platform_field(&platform, .PLATFORM_NAME, "name", cstring); err != .SUCCESS do return nil, err
		if err = get_platform_field(&platform, .PLATFORM_PROFILE, "profile", cstring); err != .SUCCESS do return nil, err
		if err = get_platform_field(&platform, .PLATFORM_VENDOR, "vendor", cstring); err != .SUCCESS do return nil, err
		if err = get_platform_field(&platform, .PLATFORM_VERSION, "version", cstring); err != .SUCCESS do return nil, err
		if err = get_platform_field(&platform, .PLATFORM_EXTENSIONS, "extensions", cstring); err != .SUCCESS do return nil, err
	}

	return result, err
}

destroy_platforms :: proc(platforms: []Platform) {
	delete(platforms)
}

get_platform_field :: proc(
	platform: ^Platform,
	field: clc.PlatformInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: clc.ErrorCodes,
) {
	numItems: uint
	err = clc.GetPlatformInfo(platform.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(platform, err)
		return
	}
	info_raw := make([]u8, numItems, context.temp_allocator)
	err = clc.GetPlatformInfo(platform.id, field, u32(numItems), &info_raw[0], &numItems)

	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(platform, err)
		return
	};test := reflect.struct_field_by_name(PlatformInfo, struct_field)

	field_ptr := rawptr(uintptr(&platform.info) + test.offset)

	(^T)(field_ptr)^ = T(&info_raw[0])
	// field_ptr = mem.copy(field_ptr, &info_raw[0], len(info_raw))

	return
}

// Device
get_available_devices :: proc(
	platform: Platform,
	device_type: clc.DeviceType = .ALL,
) -> (
	result: []Device,
	err: clc.ErrorCodes,
) {
	numDevices: u32
	err = clc.GetDeviceIDs(platform.id, .ALL, 0, nil, &numDevices)

	if err != .SUCCESS do return nil, err
	if numDevices == 0 do return nil, .SUCCESS

	devices := make([]clc.DeviceId, numDevices, context.temp_allocator)
	err = clc.GetDeviceIDs(platform.id, device_type, numDevices, &devices[0], nil)
	if err == .DEVICE_NOT_FOUND do return nil, .SUCCESS
	if err != .SUCCESS do return nil, err

	result = make([]Device, numDevices, context.allocator)


	for &device, i in result {
		device.id = devices[i]
		// Get the basic Information
		if err = get_device_basic_field(&device, .DEVICE_NAME, "name", cstring); err != .SUCCESS do return nil, err
		if err = get_device_basic_field(&device, .DEVICE_PROFILE, "profile", cstring); err != .SUCCESS do return nil, err
		if err = get_device_basic_field(&device, .DEVICE_VENDOR, "vendor", cstring); err != .SUCCESS do return nil, err
		if err = get_device_basic_field(&device, .DEVICE_EXTENSIONS, "extensions", cstring); err != .SUCCESS do return nil, err
		if err = get_device_basic_field(&device, .DEVICE_VERSION, "version", cstring); err != .SUCCESS do return nil, err
		if err = get_device_basic_field(&device, .DRIVER_VERSION, "driver_version", cstring); err != .SUCCESS do return nil, err
		if err = get_device_basic_field(&device, .DEVICE_IL_VERSION, "il_version", cstring); err != .SUCCESS do return nil, err
		// // Advance Information

		// FIXME: There is a problem with the booleans but i don't know what's happening
		// if err = get_device_single_field(&device, .DEVICE_ENDIAN_LITTLE, "little_endian", bool); err != .SUCCESS do return nil, err
		// if err = get_device_single_field(&device, .DEVICE_AVAILABLE, "available", b8); err != .SUCCESS do return nil, err
		if err = get_device_single_field(&device, .DEVICE_PARENT_DEVICE, "parent", clc.DeviceId); err != .SUCCESS do return nil, err
		if err = get_device_single_field(&device, .DEVICE_SVM_CAPABILITIES, "svm_capabilities", u64); err != .SUCCESS do return nil, err
		if err = get_device_single_field(&device, .DEVICE_SINGLE_FP_CONFIG, "single_fp_config", u64); err != .SUCCESS do return nil, err
	}

	return result, err
}


destroy_devices :: proc(devices: []Device) {
	err: clc.ErrorCodes
	for dev in devices {
		if dev.info.parent != nil {
			err = clc.ReleaseDevice(dev.id)
			when ODIN_DEBUG do debug_get_informations(dev, err)
			clc.check(err)
		}
	}
	delete(devices)
}

@(private)
get_device_basic_field :: proc(
	device: ^Device,
	field: clc.DeviceInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: clc.ErrorCodes,
) {
	numItems: uint
	err = clc.GetDeviceInfo(device.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}

	info_raw := make([]u8, numItems, context.temp_allocator)
	err = clc.GetDeviceInfo(device.id, field, u32(numItems), &info_raw[0], &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}

	test := reflect.struct_field_by_name(DeviceInfo, struct_field)

	field_ptr := rawptr(uintptr(&device.info) + test.offset)

	(^T)(field_ptr)^ = T(&info_raw[0])

	return
}

@(private)
get_device_single_field :: proc(
	device: ^Device,
	field: clc.DeviceInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: clc.ErrorCodes,
) {
	numItems: uint
	err = clc.GetDeviceInfo(device.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}

	info_raw := make([]T, numItems, context.temp_allocator)
	err = clc.GetDeviceInfo(device.id, field, u32(numItems), &info_raw[0], nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}

	test := reflect.struct_field_by_name(DeviceInfo, struct_field)

	field_ptr := rawptr(uintptr(&device.info) + test.offset)

	(^T)(field_ptr)^ = T(info_raw[0])

	return
}

// Cl Context
// NOTE: This it's a basic default if you(as user) want more control you can use the CreateContext procedure for better control of your needs
get_context :: proc(
	ctx: ^Context,
	devices: []Device,
	properties: []clc.ContextProperties = {},
	from_type: bool = false,
	device_t: clc.DeviceType = clc.DeviceType.CPU,
) -> (
	err: clc.ErrorCodes,
) {
	if from_type {
		ctx.id = clc.CreateContextFromType(raw_data(properties), device_t, nil, nil, &err)
	} else {
		device_id := make([]clc.DeviceId, len(devices), context.temp_allocator)
		for dev, i in devices {
			device_id[i] = dev.id
		}
		ctx.id = clc.CreateContext(
			raw_data(properties),
			u32(len(devices)),
			raw_data(device_id),
			nil,
			nil,
			&err,
		)

	}

	err = get_context_single_field(ctx, .CONTEXT_REFERENCE_COUNT, "ref_count", u32)
	if err != .SUCCESS do return
	err = get_context_single_field(ctx, .CONTEXT_NUM_DEVICES, "num_devices", u32)
	if err != .SUCCESS do return
	err = get_context_single_field(ctx, .CONTEXT_PROPERTIES, "properties", clc.ContextProperties)
	if err != .SUCCESS do return

	return
}

destroy_context :: proc(ctx: Context) {
	err: clc.ErrorCodes
	err = clc.ReleaseContext(ctx.id)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(ctx, err)
		clc.check(err)
	}
}

@(private)
get_context_single_field :: proc(
	ctx: ^Context,
	field: clc.ContextInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: clc.ErrorCodes,
) {
	numItems: uint
	err = clc.GetContextInfo(ctx.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(ctx, err)
		return
	}
	if numItems == 0 do return

	info_raw := make([]T, numItems, context.temp_allocator)
	err = clc.GetContextInfo(ctx.id, field, numItems, &info_raw[0], nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(ctx, err)
		return
	}

	test := reflect.struct_field_by_name(ContextInfo, struct_field)

	field_ptr := rawptr(uintptr(&ctx.info) + test.offset)

	(^T)(field_ptr)^ = T(info_raw[0])

	return
}

// Command Queue Management

@(private)
get_command_queue_single_field :: proc(
	cmd_queue: ^CommandQueue,
	field: clc.CommandQueueInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: clc.ErrorCodes,
) {
	numItems: uint
	err = clc.GetCommandQueueInfo(cmd_queue.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(cmd_queue, err)
		return
	}
	if numItems == 0 do return

	info_raw := make([]T, numItems, context.temp_allocator)
	err = clc.GetCommandQueueInfo(cmd_queue.id, field, numItems, &info_raw[0], nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(cmd_queue, err)
		return
	}

	test := reflect.struct_field_by_name(CommandQueueInfo, struct_field)

	field_ptr := rawptr(uintptr(&cmd_queue.info) + test.offset)

	(^T)(field_ptr)^ = T(info_raw[0])

	return
}


get_command_queue_list_field :: proc(
	cmd_queue: ^CommandQueue,
	field: clc.CommandQueueInfo,
	struct_field: string,
	$T: typeid,
) -> (
	err: clc.ErrorCodes,
) {
	numItems: uint
	err = clc.GetCommandQueueInfo(cmd_queue.id, field, 0, nil, &numItems)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(cmd_queue, err)
		return
	}
	if numItems == 0 do return

	info_raw := make([]T, numItems, context.temp_allocator)
	err = clc.GetCommandQueueInfo(cmd_queue.id, field, numItems, &info_raw[0], nil)
	if err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(cmd_queue, err)
		return
	}

	test := reflect.struct_field_by_name(CommandQueueInfo, struct_field)

	field_ptr := rawptr(uintptr(&cmd_queue.info) + test.offset)

	// (^T)(field_ptr)^ = T(&info_raw[0])
	field_ptr = mem.copy(field_ptr, &info_raw[0], len(info_raw))

	return
}

get_command_queue :: proc(
	runtime_cl: ^Runtime,
	ctx: Context,
	devices: []Device,
) -> (
	err: clc.ErrorCodes,
) {
	// Get id
	properties: []clc.CommandQueueProperties_t

	for dev, i in devices {
		cmd := clc.CreateCommandQueue(ctx.id, dev.id, properties, &err)
		if err != .SUCCESS {
			when ODIN_DEBUG do debug_get_informations(devices, err)
			return
		}

		if cmd == nil {
			log.panic("Something get wrong with the wrapper or with the OpenCL lib")
		}

		runtime_cl.cmd_queues[i].id = cmd
	}

	for &cmd_queue in runtime_cl.cmd_queues {
		err = get_command_queue_single_field(&cmd_queue, .QUEUE_CONTEXT, "ctx_id", clc.Context)
		if err != .SUCCESS do return

		err = get_command_queue_single_field(&cmd_queue, .QUEUE_DEVICE, "dev_id", clc.DeviceId)
		if err != .SUCCESS do return

		err = get_command_queue_list_field(
			&cmd_queue,
			.QUEUE_PROPERTIES,
			"properties",
			clc.CommandQueueInfo,
		)
		if err != .SUCCESS do return

	}


	when ODIN_DEBUG {
		for cmd_queue, i in runtime_cl.cmd_queues {
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

destroy_command_queue :: proc(cmd_queue: []CommandQueue) {
	err: clc.ErrorCodes
	for cmd in cmd_queue {
		err = clc.ReleaseCommandQueue(cmd.id)
		if err != .SUCCESS {
			when ODIN_DEBUG do debug_get_informations(cmd, err)
			clc.check(err)
		}
	}
	delete(cmd_queue)
}

// Runtime Management
// The Device *Have* to be Associated with the opencl context
// This runtime have the default properties. If the user want more control. It's strongly recommended just go with direct mode
get_runtime :: proc(
	runtime_cl: ^Runtime,
	ctx: Context,
	devices: []Device,
) -> (
	err: clc.ErrorCodes,
) {
	runtime_cl.cmd_queues = make([]CommandQueue, len(devices), context.allocator)
	// Get CommandQueue
	err = get_command_queue(runtime_cl, ctx, devices)

	return
}

destroy_runtime :: proc(runtime_cl: Runtime) {
	destroy_command_queue(runtime_cl.cmd_queues)
}

