package generate_ppm

import "core:fmt"
import "core:log"
import "core:math"
import "core:os"
import "core:strings"

import "../../cl"

Globals :: #type struct {
	platform:   cl.PlatformId,
	device:     cl.DeviceId,
	ctx:        cl.Context,
	cmd_queue:  cl.CommandQueue,
	program:    cl.Program,
	kernel:     cl.Kernel,
	result_buf: cl.Memory, // Buffer
	size:       uint, // This size it's the size of image we want to generate so multiply width*height
}

g: Globals

// TODO: Make a abstraction for this types of function of recibe the device Numbers and later the device
// maybe a AvaliblesPlatform Procedure and AvaliblesDevices can be more useful for the user(Myself)

init_platform :: proc() {
	numPlatforms: u32
	cl.check(cl.GetPlatformIDs(0, nil, &numPlatforms)) // Getting the platform Available
	assert(numPlatforms > 0, "No platforms available for the usage")
	platforms := make([]cl.PlatformId, numPlatforms, context.temp_allocator)
	cl.check(cl.GetPlatformIDs(numPlatforms, &platforms[0], nil))

	name: [256]u8

	for platform in platforms {
		cl.check(cl.GetPlatformInfo(platform, .CL_PLATFORM_NAME, 256, &name[0], nil))
		log.debugf("Platform Name: %s", cstring(&name[0]))
	}

	g.platform = platforms[0]
}

init_device :: proc() {
	numDevices: u32
	cl.check(cl.GetDeviceIDs(g.platform, .ALL, 0, nil, &numDevices)) // Getting the platform Available
	assert(numDevices > 0, "No devices available for the usage")
	devices := make([]cl.DeviceId, numDevices, context.temp_allocator)
	cl.check(cl.GetDeviceIDs(g.platform, .ALL, numDevices, &devices[0], nil))

	name: [256]u8

	for device in devices {
		cl.check(cl.GetDeviceInfo(device, .DEVICE_NAME, 256, &name[0], nil))
		log.debugf("Device Name: %s", cstring(&name[0]))
	}
	g.device = devices[0]
}

init_context :: proc() {
	err: i32
	g.ctx = cl.CreateContext(nil, 1, &g.device, nil, nil, &err)
	cl.check(err)
}

init_command_queue :: proc() {
	err: i32
	g.cmd_queue = cl.CreateCommandQueueWithProperties(g.ctx, g.device, nil, &err)
	cl.check(err)
}

init_program :: proc() {
	err: i32
	program_source := #load("./generate_data.cl", cstring)
	g.program = cl.CreateProgramWithSource(g.ctx, 1, &program_source, nil, &err)
	cl.check(err)

	cl.check(cl.BuildProgram(g.program, 1, &g.device, "", nil, nil))
}

load_kernel :: proc() {
	err: i32
	g.kernel = cl.CreateKernel(g.program, "smooth_additive_curves", &err)
	cl.check(err)
}

prepare_result :: proc() {
	err: i32
	g.result_buf = cl.CreateBuffer(g.ctx, .CL_MEM_READ_WRITE, size_of(f32) * g.size * 3, nil, &err)
	cl.check(err)
}

run :: proc() {

	global: []uint = {1920, 1080}
	local: []uint = {32, 8}
	scale: f32 = 20.0

	cl.check(cl.SetKernelArg(g.kernel, 0, size_of(cl.Memory), &g.result_buf))
	cl.check(cl.SetKernelArg(g.kernel, 1, size_of(i32), &global[0]))
	cl.check(cl.SetKernelArg(g.kernel, 2, size_of(i32), &global[1]))
	cl.check(cl.SetKernelArg(g.kernel, 3, size_of(f32), &scale))


	cl.check(
		cl.EnqueueNDRangeKernel(
			g.cmd_queue,
			g.kernel,
			2,
			nil,
			raw_data(global),
			raw_data(local),
			0,
			nil,
			nil,
		),
	)
	cl.check(cl.Finish(g.cmd_queue))
}

read_buffer :: proc(storage: []f32) {
	cl.check(
		cl.EnqueueReadBuffer(
			g.cmd_queue,
			g.result_buf,
			true,
			0,
			g.size * 3 * size_of(f32),
			raw_data(storage),
			0,
			nil,
			nil,
		),
	)
}

main :: proc() {
	context.logger = log.create_console_logger()
	context.logger.options = {.Date, .Procedure, .Level, .Terminal_Color}
	log.debug("TESTING START")

	cl.load_opencl_procedures()
	g.size = 1920 * 1080 // Size wanted

	init_platform()
	init_device()

	init_context()
	defer cl.ReleaseContext(g.ctx)

	init_command_queue()
	defer cl.ReleaseCommandQueue(g.cmd_queue)

	init_program()
	defer cl.ReleaseProgram(g.program)

	load_kernel()
	defer cl.ReleaseKernel(g.kernel)

	prepare_result()
	defer cl.RetainMemObject(g.result_buf)

	run()

	storage := make([]f32, g.size * 3, context.temp_allocator)
	read_buffer(storage)


	// Init Headers
	// file_buf[0] = "P2\n"
	// file_buf[1] = "1920 1080\n"
	// file_buf[2] = "1\n"

	// line: u32 = 3

	builder := strings.builder_make(context.temp_allocator)
	defer strings.builder_destroy(&builder)
	strings.builder_grow(&builder, int(g.size) * 3 + 100)

	strings.write_string(&builder, "P3\n")
	strings.write_string(&builder, "1920 1080\n")
	strings.write_string(&builder, "255\n")

	value: string
	for i in 0 ..< 1080 {
		for j in 0 ..< 1920 {
			// if (storage[i * 1920 + j] < 0) do storage[i * 1920 + j] = 0
			pixel_base := (i * 1920 + j) * 3

			r := int(storage[pixel_base])
			g := int(storage[pixel_base + 1])
			b := int(storage[pixel_base + 2])

			// Clamp values to 0-255
			r = max(0, min(255, r))
			g = max(0, min(255, g))
			b = max(0, min(255, b))

			if j == 0 {
				strings.write_string(&builder, fmt.tprintf("%d %d %d", r, g, b))
			} else {
				strings.write_string(&builder, fmt.tprintf(" %d %d %d", r, g, b))
			}
		}
		strings.write_string(&builder, "\n")
	}


	result := strings.to_string(builder)
	// result, _ = strings.replace_all(result, "[", "", context.temp_allocator)
	// result, _ = strings.replace_all(result, "]", "", context.temp_allocator)

	if !os.write_entire_file("image", transmute([]u8)result) do log.error("Something get wrong")


}

