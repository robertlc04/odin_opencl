package testing_abslayer


import cl "../../../cl"
import "core:log"
import "core:mem"

// WARNING: There it's a problem with the driver so you can only use one platform at time

main :: proc() {
	// Debuging
	context.logger = log.create_console_logger()
	context.logger.options = {.Line, .Procedure, .Terminal_Color, .Short_File_Path}

	when ODIN_DEBUG {
		track_allc: mem.Tracking_Allocator

		mem.tracking_allocator_init(&track_allc, context.allocator)
		context.allocator = mem.tracking_allocator(&track_allc)

		defer {
			if len(track_allc.allocation_map) > 0 {
				log.errorf("=== %v allocations not freed: ===\n", len(track_allc.allocation_map))
				for _, entry in track_allc.allocation_map {
					log.errorf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track_allc)
		}
	}
	// Debuging End

	cl.load_opencl_procedures()
	defer cl.unload_opencl_procedures()

	platforms: []cl.Platform_t
	ctx: cl.Context_t
	device: []cl.Device_t
	cmd: []cl.CommandQueue_t
	program: cl.Program_t
	err: cl.ErrorCodes

	platforms, err = cl.get_available_platforms()
	cl.check(err)

	for platform, i in platforms {
		if len(device) != 0 do break
		device, err = cl.get_available_devices(platform, .GPU)
		cl.check(err)
	}
	defer cl.destroy_devices(device)

	cl.check(cl.get_context(&ctx, device, device_t = cl.DeviceType.GPU))
	defer cl.destroy_context(ctx)

	cmd, err = cl.get_command_queue(ctx, device)
	cl.check(err)
	defer cl.destroy_command_queue(cmd)

	cl.check(cl.get_program(ctx, device[0], &program, "./vector_add.cl"))
	defer cl.destroy_program({program})

	buffers: []cl.Buffer_t = make([]cl.Buffer_t, 3, context.temp_allocator)

	// Trying to use host_ptr data
	data: [2][10]i32 = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, {11, 21, 31, 41, 51, 61, 71, 81, 91, 101}}


	for &buf, i in buffers[:2] {
		buf, err = cl.get_buffer(ctx, {.MEM_USE_HOST_PTR, .MEM_HOST_READ_ONLY}, 10, u32, &data[i])
		log.debugf("Buffer %d: %v", i, buf)
		cl.check(err)
	}

	buffers[2], err = cl.get_buffer(ctx, {.MEM_WRITE_ONLY}, 10, i32)
	cl.check(err)

	err = cl.set_kernel_args(program.kernels[0], buffers)
	cl.check(err)

	err = cl.EnqueueNDRangeKernel(cmd[0].id, program.kernels[0].id, 1, nil, {10}, nil)
	cl.check(err)

	err = cl.Finish(cmd[0].id)
	cl.check(err)

	ret, e := cl.read_buffer(cmd[0], buffers[2], true, 0, 10, i32)
	cl.check(e)
	log.debugf("Returned: %v", ret)

	for buf in buffers {
		err = cl.destroy_buffer(buf)
		cl.check(err)
	}

	// log.debugf("Platform Data: %v\n", platforms)
	// log.debugf("Device data: %v\n", device)
	// log.debugf("Context Data: %v\n", ctx)
	// log.debugf("CommandQueue Data: %v\n", cmd)
	// log.debugf("Program Data: %v\n", program)
	// log.debugf("Program Build Logs: %s\n", program.build_info.logs)
}

