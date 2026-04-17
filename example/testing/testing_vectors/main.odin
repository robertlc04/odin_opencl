package main

import "core:log"

import cl "../../../cl"

Runtime :: struct {
	platform: cl.Platform_t,
	device:   cl.Device_t,
	ctx:      cl.Context_t,
	program:  cl.Program_t,
	cmd:      cl.CommandQueue_t,
}

init_runtime :: proc(r: ^Runtime, path: string) -> (err: cl.ErrorCodes) {

	log.debug("Initialization of runtime")
	platforms: []cl.Platform_t
	devices: []cl.Device_t
	cmd_queues: []cl.CommandQueue_t

	platforms, err = cl.get_available_platforms(context.temp_allocator)
	if err != .SUCCESS do return

	search_device: for platform in platforms {
		devices, err = cl.get_available_devices(platform, .GPU)
		if err != .SUCCESS do return

		if len(devices) != 0 {
			for dev in devices {
				if dev.info.il_version != "" {
					r.platform = platform
					r.device = dev
					break search_device
				}
			}
		}
	}

	cl.get_context(&r.ctx, {r.device}, {}, false, .CPU) or_return
	cl.get_program(r.ctx, r.device, &r.program, path) or_return
	cmd_queues, err = cl.get_command_queue(r.ctx, {r.device})
	if err != .SUCCESS do return

	if len(cmd_queues) > 0 do r.cmd = cmd_queues[0]

	return
}

destroy_runtime :: proc(r: Runtime) -> (err: cl.ErrorCodes) {
	log.debug("Destroying runtime")

	cl.destroy_context(r.ctx)
	cl.destroy_devices({r.device})
	return
}

main :: proc() {
	context.logger = log.create_console_logger()
	context.logger.options = {.Procedure, .Terminal_Color, .Level}

	cl.load_opencl_procedures()
	defer cl.unload_opencl_procedures()

	globals: Runtime = {}

	init_runtime(&globals, "./vector_add.cl")
	defer destroy_runtime(globals)

	// Trying get work in the low level first
	buffers: [3]cl.Buffer_t
	err: cl.ErrorCodes

	buffers[0], err = cl.get_buffer(globals.ctx, {.MEM_READ_ONLY}, 40, i32)
	cl.check(err)

	buffers[1], err = cl.get_buffer(globals.ctx, {.MEM_READ_ONLY}, 40, i32)
	cl.check(err)

	buffers[2], err = cl.get_buffer(globals.ctx, {.MEM_WRITE_ONLY}, 40, i32)
	cl.check(err)


	data: [2][40]i32 = {}

	for &d in data {
		for &v, i in d {
			v = i32(i * 10)
		}
	}

	for b, i in buffers[:2] {
		err = cl.write_buffer(globals.cmd, b, i32, data[i][:])
		cl.check(err)
	}

	err = cl.set_kernel_args(globals.program.kernels[0], buffers[:])
	cl.check(err)

	err = cl.EnqueueNDRangeKernel(globals.cmd.id, globals.program.kernels[0].id, 1, nil, {10}, nil)
	cl.check(err)
	err = cl.Finish(globals.cmd.id)
	cl.check(err)

	result: []i32
	result, err = cl.read_buffer(globals.cmd, buffers[2], true, 0, 40, i32)
	cl.check(err)

	log.debugf("Result: %v", result)

}

