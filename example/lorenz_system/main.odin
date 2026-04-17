package lorenz

import "../../cl"
import "core:log"

Runtime :: struct {
	platform: cl.Platform_t,
	device:   cl.Device_t,
	ctx:      cl.Context_t,
	program:  cl.Program_t,
	cmd:      cl.CommandQueue_t,
	storage:  cl.Buffer_t,
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

	cl.get_context(&r.ctx, {r.device}, {}, false, .GPU) or_return
	cl.get_program(r.ctx, r.device, &r.program, path) or_return
	cmd_queues, err = cl.get_command_queue(r.ctx, {r.device})
	if err != .SUCCESS do return

	if len(cmd_queues) > 0 do r.cmd = cmd_queues[0]

	return
}

destroy_runtime :: proc(r: Runtime) -> (err: cl.ErrorCodes) {
	log.debug("Destroying runtime")

	cl.destroy_command_queue({r.cmd})
	cl.destroy_program({r.program})
	cl.destroy_context(r.ctx)
	cl.destroy_devices({r.device})
	return
}

main :: proc() {
	context.logger = log.create_console_logger()
	context.logger.options = {.Level, .Short_File_Path, .Procedure, .Terminal_Color}

	cl.load_opencl_procedures()
	defer cl.unload_opencl_procedures()

	globals: Runtime
	err: cl.ErrorCodes

	cl.check(init_runtime(&globals, "lorenz.cl"))

	defer cl.check(destroy_runtime(globals))


	kernel: cl.Kernel_t

	for k in globals.program.kernels {
		if k.info.name == "lorenz_render" {
			log.debug("Founded")
			kernel = k
		}
	}

	globals.storage, err = cl.get_buffer(globals.ctx, {.MEM_WRITE_ONLY}, 32 * 32 * 3, f32)
	cl.check(err)
	log.debugf(" Kernel: %v", kernel)
	resolution, _ := cl.get_buffer(globals.ctx, {.MEM_READ_ONLY}, 2, i32)
	data: []i32 = {32, 32}
	cl.check(cl.write_buffer(globals.cmd, resolution, i32, data))


	cl.check(cl.set_kernel_args(kernel, {globals.storage, resolution}))

	global: []uint = {64, 0}

	cl.check(cl.EnqueueNDRangeKernel(globals.cmd.id, kernel.id, 2, nil, global, nil))
	cl.check(cl.Finish(globals.cmd.id))

	data, err = cl.read_buffer(globals.cmd, globals.storage, true, 0, 32 * 32 * 3, i32)
	cl.check(err)

	for n, i in data {
		log.debugf("Data in %d: %d", i, n)
	}
	// log.debugf("Data: %v", data)

}

