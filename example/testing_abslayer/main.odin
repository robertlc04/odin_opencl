package testing_abslayer


import "../../cl"
import clc "../../cl/core"
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

	clc.load_opencl_procedures()
	defer clc.unload_opencl_procedures()


	platforms: []cl.Platform
	devices: []cl.Device
	err: clc.ErrorCodes

	platforms, err = cl.get_available_platforms()
	clc.check(err)
	defer cl.destroy_platforms(platforms)

	devices, err = cl.get_available_devices(platforms[0])
	clc.check(err)
	defer cl.destroy_devices(devices)

	// free_all(context.temp_allocator)

}

