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
		get_platform_field(&platform, .CL_PLATFORM_NAME, "name", cstring)
		// if err = get_platform_name(&platform); err != .SUCCESS do return nil, err
		// if err = get_platform_profile(&platform); err != .SUCCESS do return nil, err
		// if err = get_platform_vendor(&platform); err != .SUCCESS do return nil, err
		// if err = get_platform_version(&platform); err != .SUCCESS do return nil, err
		// if err = get_platform_extensions(&platform); err != .SUCCESS do return nil, err
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
	test := reflect.struct_field_by_name(PlatformInfo, struct_field)

	log.debugf("Testing things: %v", test)

	return
}

get_platform_name :: proc(platform: ^Platform) -> (err: clc.ErrorCodes) {
	name: [256]u8
	num: uint
	err = clc.ErrorCodes(clc.GetPlatformInfo(platform.id, .CL_PLATFORM_NAME, 256, &name[0], &num))

	if err != .SUCCESS {
		platform.info.name = "Unknown"
		return err
	}

	when ODIN_DEBUG {
		log.debugf("Platform Name: %s", cstring(&name[0]))
	}
	platform.info.name = cstring(&name[0])
	return clc.ErrorCodes.SUCCESS
}

get_platform_profile :: proc(platform: ^Platform) -> (err: clc.ErrorCodes) {
	name: [256]u8
	num: uint
	err = clc.ErrorCodes(
		clc.GetPlatformInfo(platform.id, .CL_PLATFORM_PROFILE, 256, &name[0], &num),
	)

	if err != .SUCCESS {
		platform.info.profile = "Unknown"
		return err
	}

	when ODIN_DEBUG {
		log.debugf("Platform Profile: %s", cstring(&name[0]))
	}
	platform.info.profile = cstring(&name[0])
	return clc.ErrorCodes.SUCCESS
}


get_platform_vendor :: proc(platform: ^Platform) -> (err: clc.ErrorCodes) {
	name: [256]u8
	num: uint
	err = clc.ErrorCodes(
		clc.GetPlatformInfo(platform.id, .CL_PLATFORM_VENDOR, 256, &name[0], &num),
	)

	if err != .SUCCESS {
		platform.info.vendor = "Unknown"
		return err
	}

	when ODIN_DEBUG {
		log.debugf("Platform Vendor: %s", cstring(&name[0]))
	}
	platform.info.vendor = cstring(&name[0])
	return clc.ErrorCodes.SUCCESS
}

get_platform_version :: proc(platform: ^Platform) -> (err: clc.ErrorCodes) {
	name: [256]u8
	num: uint
	err = clc.ErrorCodes(
		clc.GetPlatformInfo(platform.id, .CL_PLATFORM_VERSION, 256, &name[0], &num),
	)

	if err != .SUCCESS {
		platform.info.version = "Unknown"
		return err
	}

	when ODIN_DEBUG {
		log.debugf("Platform Version: %s", cstring(&name[0]))
	}
	platform.info.version = cstring(&name[0])
	return clc.ErrorCodes.SUCCESS
}

get_platform_extensions :: proc(platform: ^Platform) -> (err: clc.ErrorCodes) {
	name: [256]u8
	num: uint
	err = clc.ErrorCodes(
		clc.GetPlatformInfo(platform.id, .CL_PLATFORM_EXTENSIONS, 256, &name[0], &num),
	)

	if err != .SUCCESS {
		platform.info.extensions = "Unknown"
		return err
	}

	when ODIN_DEBUG {
		log.debugf("Platform Extensions: %s", cstring(&name[0]))
	}
	platform.info.extensions = cstring(&name[0])
	return clc.ErrorCodes.SUCCESS
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
		// if err = get_device_name(&device); err != .SUCCESS do return nil, err
		// if err = get_device_profile(&device); err != .SUCCESS do return nil, err
		// if err = get_device_vendor(&device); err != .SUCCESS do return nil, err
		// if err = get_device_version(&device); err != .SUCCESS do return nil, err
		// if err = get_driver_version(&device); err != .SUCCESS do return nil, err
		// if err = get_device_extensions(&device); err != .SUCCESS do return nil, err
		// // Advance Information
		// if err = get_device_il_version(&device); err != .SUCCESS do return nil, err

	}

	return result, err
}


destroy_devices :: proc(devices: []Device) {
	delete(devices)
}

get_device_name :: proc(device: ^Device, location := #caller_location) -> (err: clc.ErrorCodes) {
	num: uint
	if err = clc.GetDeviceInfo(device.id, .DEVICE_NAME, 0, nil, &num); err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}
	name := make([]u8, num, context.temp_allocator)

	if err = clc.GetDeviceInfo(device.id, .DEVICE_NAME, 256, &name[0], &num); err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}
	when ODIN_DEBUG {
		log.debugf("Device name: %s", cstring(&name[0]))
	}
	device.info.name = cstring(&name[0]) if num > 0 else "UNKNOWN"
	return
}

get_device_profile :: proc(device: ^Device) -> (err: clc.ErrorCodes) {
	profile: [1024]u8
	num: uint
	if err = clc.GetDeviceInfo(device.id, .DEVICE_PROFILE, 1024, &profile[0], &num);
	   err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}

	when ODIN_DEBUG {
		log.debugf("Device profile: %s", cstring(&profile[0]))
	}
	device.info.profile = cstring(&profile[0]) if num > 0 else "UNKNOWN"
	return
}


get_device_vendor :: proc(device: ^Device) -> (err: clc.ErrorCodes) {
	vendor: [256]u8
	num: uint
	if err = clc.GetDeviceInfo(device.id, .DEVICE_VENDOR, 256, &vendor[0], &num); err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}
	when ODIN_DEBUG {
		log.debugf("Device vendor: %s", cstring(&vendor[0]))
	}
	device.info.vendor = cstring(&vendor[0]) if num > 0 else "UNKNOWN"
	return
}

get_device_version :: proc(device: ^Device) -> (err: clc.ErrorCodes) {
	version: [256]u8
	num: uint
	if err = clc.GetDeviceInfo(device.id, .DEVICE_VERSION, 256, &version[0], &num);
	   err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}
	when ODIN_DEBUG {
		log.debugf("Device version: %s", cstring(&version[0]))
	}
	device.info.version = cstring(&version[0]) if num > 0 else "UNKNOWN"
	return
}

get_driver_version :: proc(device: ^Device) -> (err: clc.ErrorCodes) {
	driver_version: [256]u8
	num: uint
	if err = clc.GetDeviceInfo(device.id, .DRIVER_VERSION, 256, &driver_version[0], &num);
	   err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}
	when ODIN_DEBUG {
		log.debugf("Device driver version: %s", cstring(&driver_version[0]))
	}
	device.info.driver_version = cstring(&driver_version[0]) if num > 0 else "UNKNOWN"
	return
}

get_device_il_version :: proc(device: ^Device) -> (err: clc.ErrorCodes) {
	device_il_version: [256]u8
	num: uint
	if err = clc.GetDeviceInfo(device.id, .DEVICE_IL_VERSION, 256, &device_il_version[0], &num);
	   err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}
	when ODIN_DEBUG {
		log.debugf("Device IL version: %s", cstring(&device_il_version[0]))
	}
	device.info.il_version = cstring(&device_il_version[0]) if num > 0 else "UNKNOWN"
	return
}

get_device_extensions :: proc(device: ^Device) -> (err: clc.ErrorCodes) {
	extensions: [1024]u8
	num: uint
	if err = clc.GetDeviceInfo(device.id, .DEVICE_EXTENSIONS, 1024, &extensions[0], &num);
	   err != .SUCCESS {
		when ODIN_DEBUG do debug_get_informations(device, err)
		return
	}
	when ODIN_DEBUG {
		log.debugf("Device extensions: %s", cstring(&extensions[0]))
	}
	device.info.extensions = cstring(&extensions[0]) if num > 0 else "UNKNOWN"
	return
}

// max_work_items:   u32,
// single_fp_config: u64, // This it's configured for bit shifting if available
// svm_capabilities: u64, // This it's configured for bit shifting if available
// little_endian:    bool,
// available:        bool,

