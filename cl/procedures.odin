package cl

import "base:intrinsics"
import "base:runtime"
import "core:fmt"
import "core:log"
import "core:reflect"

import clc "./core"
// Things are repetitive and anoying
// Select and list available Platforms and show it's information

debug_get_informations :: proc(
	structure: any,
	error: clc.ErrorCodes,
	location := #caller_location,
) {
	log.debugf("Called from: %s", location.procedure)
	log.debugf("Structure: %v", structure)
	log.debugf("Error desc: %s", clc.ErrorCodes_Descriptions[error])
}

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
		if err = get_platform_field(&platform, .CL_PLATFORM_NAME, "name", cstring); err != .SUCCESS do return nil, err
		if err = get_platform_field(&platform, .CL_PLATFORM_PROFILE, "profile", cstring); err != .SUCCESS do return nil, err
		if err = get_platform_field(&platform, .CL_PLATFORM_VENDOR, "vendor", cstring); err != .SUCCESS do return nil, err
		if err = get_platform_field(&platform, .CL_PLATFORM_VERSION, "version", cstring); err != .SUCCESS do return nil, err
		if err = get_platform_field(&platform, .CL_PLATFORM_EXTENSIONS, "extensions", cstring); err != .SUCCESS do return nil, err
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
	if err != .SUCCESS do return

	info_raw := make([]u8, numItems, context.temp_allocator)
	err = clc.GetPlatformInfo(platform.id, field, u32(numItems), &info_raw[0], &numItems)
	if err != .SUCCESS do return

	test := reflect.struct_field_by_name(PlatformInfo, struct_field)

	field_ptr := rawptr(uintptr(&platform.info) + test.offset)

	(^T)(field_ptr)^ = T(&info_raw[0])

	return
}

get_available_devices :: proc(platform: Platform) -> (result: []Device, err: clc.ErrorCodes) {
	numDevices: u32
	err = clc.GetDeviceIDs(platform.id, .ALL, 0, nil, &numDevices)

	if err != .SUCCESS do return nil, err
	if numDevices == 0 do return nil, .SUCCESS

	devices := make([]clc.DeviceId, numDevices, context.temp_allocator)
	err = clc.GetDeviceIDs(platform.id, .ALL, numDevices, &devices[0], nil)
	if err != clc.ErrorCodes.SUCCESS do return nil, err

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
		if err = get_device_single_field(&device, .DEVICE_SINGLE_FP_CONFIG, "single_fp_config", u64); err != .SUCCESS do return nil, err
		if err = get_device_single_field(&device, .DEVICE_ENDIAN_LITTLE, "little_endian", bool); err != .SUCCESS do return nil, err
		if err = get_device_single_field(&device, .DEVICE_AVAILABLE, "available", bool); err != .SUCCESS do return nil, err
		if err = get_device_single_field(&device, .DEVICE_SVM_CAPABILITIES, "svm_capabilities", u64); err != .SUCCESS do return nil, err

	}

	return result, err
}


destroy_devices :: proc(devices: []Device) {
	delete(devices)
}


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
	if err != .SUCCESS do return

	info_raw := make([]u8, numItems, context.temp_allocator)
	err = clc.GetDeviceInfo(device.id, field, u32(numItems), &info_raw[0], &numItems)
	if err != .SUCCESS do return

	test := reflect.struct_field_by_name(DeviceInfo, struct_field)

	field_ptr := rawptr(uintptr(&device.info) + test.offset)

	(^T)(field_ptr)^ = T(&info_raw[0])

	return
}


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
	if err != .SUCCESS do return

	info_raw := make([]T, numItems, context.temp_allocator)
	err = clc.GetDeviceInfo(device.id, field, u32(numItems), &info_raw[0], &numItems)
	if err != .SUCCESS do return

	test := reflect.struct_field_by_name(DeviceInfo, struct_field)

	field_ptr := rawptr(uintptr(&device.info) + test.offset)

	(^T)(field_ptr)^ = T(info_raw[0])

	return
}
// max_work_items:   u32,
// single_fp_config: u64, // This it's configured for bit shifting if available
// svm_capabilities: u64, // This it's configured for bit shifting if available
// little_endian:    bool,
// available:        bool,

