package main

import "core:c"
import "core:fmt"
import "core:log"

import "../../cl"


init_platform :: proc(platform: ^cl.PlatformId) {
	numPlatforms: u32
	cl.check(cl.GetPlatformIDs(0, nil, &numPlatforms))
	cl.check(cl.GetPlatformIDs(1, platform, nil))
	platform_name: [256]u8
	cl.check(cl.GetPlatformInfo(platform^, .CL_PLATFORM_NAME, 256, &platform_name[0], nil))
	log.debugf("Platform: %s", cstring(&platform_name[0]))
}

init_device :: proc(platform: cl.PlatformId, device: ^cl.DeviceId) {
	numDevices: u32
	cl.check(cl.GetDeviceIDs(platform, cl.DeviceType.GPU, 0, nil, &numDevices))
	cl.check(cl.GetDeviceIDs(platform, cl.DeviceType.GPU, 1, device, nil))

	name: [256]u8
	cl.check(cl.GetDeviceInfo(device^, .DEVICE_NAME, 256, &name[0], nil))

	log.debugf("Device: %s", cstring(&name[0]))
}

ARRAYS_SIZE :: 10

main :: proc() {
	context.logger = log.create_console_logger()
	context.logger.options = {.Level, .Procedure, .Terminal_Color, .Short_File_Path}

	cl.load_opencl_procedures()

	platform: cl.PlatformId
	device: cl.DeviceId

	init_platform(&platform)
	log.debug("all ok")
	init_device(platform, &device)
	// Create Context
	log.debug("Creating Context")
	error: i32
	ocl_context := cl.CreateContext(nil, 1, &device, nil, nil, &error)
	cl.check(error)
	log.debugf("Context pointer: %p", ocl_context)
	defer cl.check(cl.ReleaseContext(ocl_context))

	// Create Command Queue
	cmd_queue := cl.CreateCommandQueueWithProperties(ocl_context, device, nil, &error)
	defer cl.check(cl.ReleaseCommandQueue(cmd_queue))
	cl.check(error)

	size: i32
	value: uint
	cl.GetCommandQueueInfo(cmd_queue, .CL_QUEUE_SIZE, 4, &size, &value)
	log.debugf("Queue Size: %d", size)
	log.debugf("Value Size: %d", value)

	// TODO: Prepare the Kernel ALMOST THERE !!!!!
	program: cl.Program
	program_source := #load("vector_add.cl", cstring)
	// program = cl.CreateProgramWithIL(ocl_context, raw_data(program_il), len(program_il), &error)
	program = cl.CreateProgramWithSource(ocl_context, 1, &program_source, nil, &error)

	cl.check(error)
	if program == nil do log.debug("Something Fail With Program Construction")
	defer cl.ReleaseProgram(program)

	// Check device is still valid before BuildProgram
	log.debugf("Device before build: %p", device)
	if device == nil {
		log.errorf("Device is nil before build!")
		return
	}

	cl.check(cl.BuildProgram(program, 1, &device, "", nil, nil))

	kernel: cl.Kernel
	kernel = cl.CreateKernel(program, "vector_add", &error)
	cl.check(error)
	if kernel == nil do log.debug("Something Fail With Program Construction")
	defer cl.ReleaseKernel(kernel)

	a_arr: [ARRAYS_SIZE]i32
	b_arr: [ARRAYS_SIZE]i32
	c_arr: [ARRAYS_SIZE]i32

	for _, i in a_arr {
		a_arr[i] = i32(i)
		b_arr[i] = i32(i * 8)
	}

	buffer_a: cl.Memory = cl.CreateBuffer(
		ocl_context,
		.CL_MEM_READ_ONLY | .CL_MEM_COPY_HOST_PTR,
		size_of(i32) * len(a_arr),
		&a_arr[0],
		&error,
	)
	cl.check(error)

	buffer_b: cl.Memory = cl.CreateBuffer(
		ocl_context,
		.CL_MEM_READ_ONLY | .CL_MEM_COPY_HOST_PTR,
		size_of(i32) * len(b_arr),
		&b_arr[0],
		&error,
	)
	cl.check(error)

	buffer_c: cl.Memory = cl.CreateBuffer(
		ocl_context,
		.CL_MEM_WRITE_ONLY | .CL_MEM_USE_HOST_PTR,
		size_of(i32) * len(c_arr),
		&c_arr[0],
		&error,
	)
	cl.check(error)

	cl.SetKernelArg(kernel, 0, size_of(cl.Memory), &buffer_a)
	cl.SetKernelArg(kernel, 1, size_of(cl.Memory), &buffer_b)
	cl.SetKernelArg(kernel, 2, size_of(cl.Memory), &buffer_c)

	// TODO: Finish the Implementation of Enqueue
	global_size: uint = ARRAYS_SIZE
	cl.check(cl.EnqueueNDRangeKernel(cmd_queue, kernel, 1, nil, &global_size, nil, 0, nil, nil))
	cl.check(cl.Finish(cmd_queue))

	cl.EnqueueReadBuffer(
		cmd_queue,
		buffer_c,
		true,
		0,
		size_of(i32) * ARRAYS_SIZE,
		&c_arr[0],
		0,
		nil,
		nil,
	)

	for value in c_arr {
		log.debugf("Value Calculated: %d", value)
	}


	defer cl.ReleaseMemObject(buffer_a)
	defer cl.ReleaseMemObject(buffer_b)
	defer cl.ReleaseMemObject(buffer_c)

}

