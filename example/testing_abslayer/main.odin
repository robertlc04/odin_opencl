package testing_abslayer


import cl "../../cl"
import "core:log"
import "core:mem"

// WARNING: There it's a problem with the driver so you can only use one platform at time

main :: proc() {
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

	cl.load_opencl_procedures()
	defer cl.unload_opencl_procedures()

	platforms: []cl.Platform_t
	ctx: cl.Context_t
	device: []cl.Device_t
	program: cl.Program_t
	err: cl.ErrorCodes

	platforms, err = cl.get_available_platforms()
	cl.check(err)
	defer cl.destroy_platforms(platforms)

	for platform, i in platforms {
		if len(device) != 0 do break
		device, err = cl.get_available_devices(platform, .GPU)
		cl.check(err)
	}
	defer cl.destroy_devices(device)

	err = cl.get_context(&ctx, device, device_t = cl.DeviceType.GPU)
	cl.check(err)
	defer cl.destroy_context(ctx)
	cmd: []cl.CommandQueue_t
	cmd, err = cl.get_command_queue(ctx, device)
	cl.check(err)
	defer cl.destroy_command_queue(cmd)

	err = cl.get_program(ctx, device[0], &program, "./vector_add.cl")
	cl.check(err)
	defer cl.destroy_program({program})


	log.debugf("Platform Data: %v\n", platforms)
	log.debugf("Device data: %v\n", device)
	log.debugf("Context Data: %v\n", ctx)
	log.debugf("CommandQueue Data: %v\n", cmd)
	log.debugf("Program Data: %v\n", program)
}

