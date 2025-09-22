package cl

// Errors
ErrorCodes :: enum {
	/* Error Codes */
	SUCCESS                                   = 0,
	DEVICE_NOT_FOUND                          = -1,
	DEVICE_NOT_AVAILABLE                      = -2,
	COMPILER_NOT_AVAILABLE                    = -3,
	MEM_OBJECT_ALLOCATION_FAILURE             = -4,
	OUT_OF_RESOURCES                          = -5,
	OUT_OF_HOST_MEMORY                        = -6,
	PROFILING_INFO_NOT_AVAILABLE              = -7,
	MEM_COPY_OVERLAP                          = -8,
	IMAGE_FORMAT_MISMATCH                     = -9,
	IMAGE_FORMAT_NOT_SUPPORTED                = -10,
	BUILD_PROGRAM_FAILURE                     = -11,
	MAP_FAILURE                               = -12,

	// CL_VERSION_1_1
	MISALIGNED_SUB_BUFFER_OFFSET              = -13,
	EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST = -14,

	// CL_VERSION_1_2
	COMPILE_PROGRAM_FAILURE                   = -15,
	LINKER_NOT_AVAILABLE                      = -16,
	LINK_PROGRAM_FAILURE                      = -17,
	DEVICE_PARTITION_FAILED                   = -18,
	KERNEL_ARG_INFO_NOT_AVAILABLE             = -19,
	INVALID_VALUE                             = -30,
	INVALID_DEVICE_TYPE                       = -31,
	INVALID_PLATFORM                          = -32,
	INVALID_DEVICE                            = -33,
	INVALID_CONTEXT                           = -34,
	INVALID_QUEUE_PROPERTIES                  = -35,
	INVALID_COMMAND_QUEUE                     = -36,
	INVALID_HOST_PTR                          = -37,
	INVALID_MEM_OBJECT                        = -38,
	INVALID_IMAGE_FORMAT_DESCRIPTOR           = -39,
	INVALID_IMAGE_SIZE                        = -40,
	INVALID_SAMPLER                           = -41,
	INVALID_BINARY                            = -42,
	INVALID_BUILD_OPTIONS                     = -43,
	INVALID_PROGRAM                           = -44,
	INVALID_PROGRAM_EXECUTABLE                = -45,
	INVALID_KERNEL_NAME                       = -46,
	INVALID_KERNEL_DEFINITION                 = -47,
	INVALID_KERNEL                            = -48,
	INVALID_ARG_INDEX                         = -49,
	INVALID_ARG_VALUE                         = -50,
	INVALID_ARG_SIZE                          = -51,
	INVALID_KERNEL_ARGS                       = -52,
	INVALID_WORK_DIMENSION                    = -53,
	INVALID_WORK_GROUP_SIZE                   = -54,
	INVALID_WORK_ITEM_SIZE                    = -55,
	INVALID_GLOBAL_OFFSET                     = -56,
	INVALID_EVENT_WAIT_LIST                   = -57,
	INVALID_EVENT                             = -58,
	INVALID_OPERATION                         = -59,
	INVALID_GL_OBJECT                         = -60,
	INVALID_BUFFER_SIZE                       = -61,
	INVALID_MIP_LEVEL                         = -62,
	INVALID_GLOBAL_WORK_SIZE                  = -63,
	// CL_VERSION_1_1
	INVALID_PROPERTY                          = -64,

	// CL_VERSION_1_2
	INVALID_IMAGE_DESCRIPTOR                  = -65,
	INVALID_COMPILER_OPTIONS                  = -66,
	INVALID_LINKER_OPTIONS                    = -67,
	INVALID_DEVICE_PARTITION_COUNT            = -68,

	// CL_VERSION_2_0
	INVALID_PIPE_SIZE                         = -69,
	INVALID_DEVICE_QUEUE                      = -70,

	// CL_VERSION_2_2
	INVALID_SPEC_ID                           = -71,
	MAX_SIZE_RESTRICTION_EXCEEDED             = -72,
}

ErrorCodes_Descriptions := #sparse[ErrorCodes]string {
	.SUCCESS                                   = "SUCCESS",
	.DEVICE_NOT_FOUND                          = "DEVICE_NOT_FOUND",
	.DEVICE_NOT_AVAILABLE                      = "DEVICE_NOT_AVAILABLE",
	.COMPILER_NOT_AVAILABLE                    = "COMPILER_NOT_AVAILABLE",
	.MEM_OBJECT_ALLOCATION_FAILURE             = "MEM_OBJECT_ALLOCATION_FAILURE",
	.OUT_OF_RESOURCES                          = "OUT_OF_RESOURCES",
	.OUT_OF_HOST_MEMORY                        = "OUT_OF_HOST_MEMORY",
	.PROFILING_INFO_NOT_AVAILABLE              = "PROFILING_INFO_NOT_AVAILABLE",
	.MEM_COPY_OVERLAP                          = "MEM_COPY_OVERLAP",
	.IMAGE_FORMAT_MISMATCH                     = "IMAGE_FORMAT_MISMATCH",
	.IMAGE_FORMAT_NOT_SUPPORTED                = "IMAGE_FORMAT_NOT_SUPPORTED",
	.BUILD_PROGRAM_FAILURE                     = "BUILD_PROGRAM_FAILURE",
	.MAP_FAILURE                               = "MAP_FAILURE",


	// CL_VERSION_1_1
	.MISALIGNED_SUB_BUFFER_OFFSET              = "MISALIGNED_SUB_BUFFER_OFFSET ",
	.EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST = "EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST ",

	// CL_VERSION_1_2
	.COMPILE_PROGRAM_FAILURE                   = "COMPILE_PROGRAM_FAILURE ",
	.LINKER_NOT_AVAILABLE                      = "LINKER_NOT_AVAILABLE ",
	.LINK_PROGRAM_FAILURE                      = "LINK_PROGRAM_FAILURE ",
	.DEVICE_PARTITION_FAILED                   = "DEVICE_PARTITION_FAILED ",
	.KERNEL_ARG_INFO_NOT_AVAILABLE             = "KERNEL_ARG_INFO_NOT_AVAILABLE ",
	.INVALID_VALUE                             = "INVALID_VALUE ",
	.INVALID_DEVICE_TYPE                       = "INVALID_DEVICE_TYPE ",
	.INVALID_PLATFORM                          = "INVALID_PLATFORM ",
	.INVALID_DEVICE                            = "INVALID_DEVICE ",
	.INVALID_CONTEXT                           = "INVALID_CONTEXT ",
	.INVALID_QUEUE_PROPERTIES                  = "INVALID_QUEUE_PROPERTIES ",
	.INVALID_COMMAND_QUEUE                     = "INVALID_COMMAND_QUEUE ",
	.INVALID_HOST_PTR                          = "INVALID_HOST_PTR ",
	.INVALID_MEM_OBJECT                        = "INVALID_MEM_OBJECT ",
	.INVALID_IMAGE_FORMAT_DESCRIPTOR           = "INVALID_IMAGE_FORMAT_DESCRIPTOR ",
	.INVALID_IMAGE_SIZE                        = "INVALID_IMAGE_SIZE ",
	.INVALID_SAMPLER                           = "INVALID_SAMPLER ",
	.INVALID_BINARY                            = "INVALID_BINARY ",
	.INVALID_BUILD_OPTIONS                     = "INVALID_BUILD_OPTIONS ",
	.INVALID_PROGRAM                           = "INVALID_PROGRAM ",
	.INVALID_PROGRAM_EXECUTABLE                = "INVALID_PROGRAM_EXECUTABLE ",
	.INVALID_KERNEL_NAME                       = "INVALID_KERNEL_NAME ",
	.INVALID_KERNEL_DEFINITION                 = "INVALID_KERNEL_DEFINITION ",
	.INVALID_KERNEL                            = "INVALID_KERNEL ",
	.INVALID_ARG_INDEX                         = "INVALID_ARG_INDEX ",
	.INVALID_ARG_VALUE                         = "INVALID_ARG_VALUE ",
	.INVALID_ARG_SIZE                          = "INVALID_ARG_SIZE ",
	.INVALID_KERNEL_ARGS                       = "INVALID_KERNEL_ARGS ",
	.INVALID_WORK_DIMENSION                    = "INVALID_WORK_DIMENSION ",
	.INVALID_WORK_GROUP_SIZE                   = "INVALID_WORK_GROUP_SIZE ",
	.INVALID_WORK_ITEM_SIZE                    = "INVALID_WORK_ITEM_SIZE ",
	.INVALID_GLOBAL_OFFSET                     = "INVALID_GLOBAL_OFFSET ",
	.INVALID_EVENT_WAIT_LIST                   = "INVALID_EVENT_WAIT_LIST ",
	.INVALID_EVENT                             = "INVALID_EVENT ",
	.INVALID_OPERATION                         = "INVALID_OPERATION ",
	.INVALID_GL_OBJECT                         = "INVALID_GL_OBJECT ",
	.INVALID_BUFFER_SIZE                       = "INVALID_BUFFER_SIZE ",
	.INVALID_MIP_LEVEL                         = "INVALID_MIP_LEVEL ",
	.INVALID_GLOBAL_WORK_SIZE                  = "INVALID_GLOBAL_WORK_SIZE ",
	// CL_VERSION_1_1
	.INVALID_PROPERTY                          = "INVALID_PROPERTY ",

	// CL_VERSION_1_2
	.INVALID_IMAGE_DESCRIPTOR                  = "INVALID_IMAGE_DESCRIPTOR ",
	.INVALID_COMPILER_OPTIONS                  = "INVALID_COMPILER_OPTIONS ",
	.INVALID_LINKER_OPTIONS                    = "INVALID_LINKER_OPTIONS ",
	.INVALID_DEVICE_PARTITION_COUNT            = "INVALID_DEVICE_PARTITION_COUNT ",

	// CL_VERSION_2_0
	.INVALID_PIPE_SIZE                         = "INVALID_PIPE_SIZE ",
	.INVALID_DEVICE_QUEUE                      = "INVALID_DEVICE_QUEUE ",

	// CL_VERSION_2_2
	.INVALID_SPEC_ID                           = "INVALID_SPEC_ID ",
	.MAX_SIZE_RESTRICTION_EXCEEDED             = "MAX_SIZE_RESTRICTION_EXCEEDED ",
}

PlatformInfo :: enum u32 {
	CL_PLATFORM_PROFILE                 = 0x0900,
	CL_PLATFORM_VERSION                 = 0x0901,
	CL_PLATFORM_NAME                    = 0x0902,
	CL_PLATFORM_VENDOR                  = 0x0903,
	CL_PLATFORM_EXTENSIONS              = 0x0904,
	// CL_VERSION_2_1
	CL_PLATFORM_HOST_TIMER_RESOLUTION   = 0x0905,

	// CL_VERSION_3_0
	CL_PLATFORM_NUMERIC_VERSION         = 0x0906,
	CL_PLATFORM_EXTENSIONS_WITH_VERSION = 0x0907,
}

DeviceType :: enum u64 {
	DEFAULT     = (1 << 0),
	CPU         = (1 << 1),
	GPU         = (1 << 2),
	ACCELERATOR = (1 << 3),
	CUSTOM      = (1 << 4),
	ALL         = 0xFFFFFFFF,
}

/* cl_device_info */
DeviceInfo :: enum u32 {
	DEVICE_TYPE                                    = 0x1000,
	DEVICE_VENDOR_ID                               = 0x1001,
	DEVICE_MAX_COMPUTE_UNITS                       = 0x1002,
	DEVICE_MAX_WORK_ITEM_DIMENSIONS                = 0x1003,
	DEVICE_MAX_WORK_GROUP_SIZE                     = 0x1004,
	DEVICE_MAX_WORK_ITEM_SIZES                     = 0x1005,
	DEVICE_PREFERRED_VECTOR_WIDTH_CHAR             = 0x1006,
	DEVICE_PREFERRED_VECTOR_WIDTH_SHORT            = 0x1007,
	DEVICE_PREFERRED_VECTOR_WIDTH_INT              = 0x1008,
	DEVICE_PREFERRED_VECTOR_WIDTH_LONG             = 0x1009,
	DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT            = 0x100A,
	DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE           = 0x100B,
	DEVICE_MAX_CLOCK_FREQUENCY                     = 0x100C,
	DEVICE_ADDRESS_BITS                            = 0x100D,
	DEVICE_MAX_READ_IMAGE_ARGS                     = 0x100E,
	DEVICE_MAX_WRITE_IMAGE_ARGS                    = 0x100F,
	DEVICE_MAX_MEM_ALLOC_SIZE                      = 0x1010,
	DEVICE_IMAGE2D_MAX_WIDTH                       = 0x1011,
	DEVICE_IMAGE2D_MAX_HEIGHT                      = 0x1012,
	DEVICE_IMAGE3D_MAX_WIDTH                       = 0x1013,
	DEVICE_IMAGE3D_MAX_HEIGHT                      = 0x1014,
	DEVICE_IMAGE3D_MAX_DEPTH                       = 0x1015,
	DEVICE_IMAGE_SUPPORT                           = 0x1016,
	DEVICE_MAX_PARAMETER_SIZE                      = 0x1017,
	DEVICE_MAX_SAMPLERS                            = 0x1018,
	DEVICE_MEM_BASE_ADDR_ALIGN                     = 0x1019,
	DEVICE_MIN_DATA_TYPE_ALIGN_SIZE                = 0x101A,
	DEVICE_SINGLE_FP_CONFIG                        = 0x101B,
	DEVICE_GLOBAL_MEM_CACHE_TYPE                   = 0x101C,
	DEVICE_GLOBAL_MEM_CACHELINE_SIZE               = 0x101D,
	DEVICE_GLOBAL_MEM_CACHE_SIZE                   = 0x101E,
	DEVICE_GLOBAL_MEM_SIZE                         = 0x101F,
	DEVICE_MAX_CONSTANT_BUFFER_SIZE                = 0x1020,
	DEVICE_MAX_CONSTANT_ARGS                       = 0x1021,
	DEVICE_LOCAL_MEM_TYPE                          = 0x1022,
	DEVICE_LOCAL_MEM_SIZE                          = 0x1023,
	DEVICE_ERROR_CORRECTION_SUPPORT                = 0x1024,
	DEVICE_PROFILING_TIMER_RESOLUTION              = 0x1025,
	DEVICE_ENDIAN_LITTLE                           = 0x1026,
	DEVICE_AVAILABLE                               = 0x1027,
	DEVICE_COMPILER_AVAILABLE                      = 0x1028,
	DEVICE_EXECUTION_CAPABILITIES                  = 0x1029,
	DEVICE_QUEUE_PROPERTIES                        = 0x102A, /* deprecated = */
	DEVICE_NAME                                    = 0x102B,
	DEVICE_VENDOR                                  = 0x102C,
	DRIVER_VERSION                                 = 0x102D,
	DEVICE_PROFILE                                 = 0x102E,
	DEVICE_VERSION                                 = 0x102F,
	DEVICE_EXTENSIONS                              = 0x1030,
	DEVICE_PLATFORM                                = 0x1031,

	/* 0x1033 reserved for CL_DEVICE_HALF_FP_CONFIG which is already defined in "cl_ext.h" */
	// CL_VERSION_1_1
	DEVICE_PREFERRED_VECTOR_WIDTH_HALF             = 0x1034,
	DEVICE_HOST_UNIFIED_MEMORY                     = 0x1035, /* deprecated */
	DEVICE_NATIVE_VECTOR_WIDTH_CHAR                = 0x1036,
	DEVICE_NATIVE_VECTOR_WIDTH_SHORT               = 0x1037,
	DEVICE_NATIVE_VECTOR_WIDTH_INT                 = 0x1038,
	DEVICE_NATIVE_VECTOR_WIDTH_LONG                = 0x1039,
	DEVICE_NATIVE_VECTOR_WIDTH_FLOAT               = 0x103A,
	DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE              = 0x103B,
	DEVICE_NATIVE_VECTOR_WIDTH_HALF                = 0x103C,
	DEVICE_OPENCL_C_VERSION                        = 0x103D,

	// CL_VERSION_1_2
	DEVICE_LINKER_AVAILABLE                        = 0x103E,
	DEVICE_BUILT_IN_KERNELS                        = 0x103F,
	DEVICE_IMAGE_MAX_BUFFER_SIZE                   = 0x1040,
	DEVICE_IMAGE_MAX_ARRAY_SIZE                    = 0x1041,
	DEVICE_PARENT_DEVICE                           = 0x1042,
	DEVICE_PARTITION_MAX_SUB_DEVICES               = 0x1043,
	DEVICE_PARTITION_PROPERTIES                    = 0x1044,
	DEVICE_PARTITION_AFFINITY_DOMAIN               = 0x1045,
	DEVICE_PARTITION_TYPE                          = 0x1046,
	DEVICE_REFERENCE_COUNT                         = 0x1047,
	DEVICE_PREFERRED_INTEROP_USER_SYNC             = 0x1048,
	DEVICE_PRINTF_BUFFER_SIZE                      = 0x1049,
	DEVICE_DOUBLE_FP_CONFIG                        = 0x1032,

	// CL_VERSION_2_0
	DEVICE_QUEUE_ON_HOST_PROPERTIES                = 0x102A,
	DEVICE_IMAGE_PITCH_ALIGNMENT                   = 0x104A,
	DEVICE_IMAGE_BASE_ADDRESS_ALIGNMENT            = 0x104B,
	DEVICE_MAX_READ_WRITE_IMAGE_ARGS               = 0x104C,
	DEVICE_MAX_GLOBAL_VARIABLE_SIZE                = 0x104D,
	DEVICE_QUEUE_ON_DEVICE_PROPERTIES              = 0x104E,
	DEVICE_QUEUE_ON_DEVICE_PREFERRED_SIZE          = 0x104F,
	DEVICE_QUEUE_ON_DEVICE_MAX_SIZE                = 0x1050,
	DEVICE_MAX_ON_DEVICE_QUEUES                    = 0x1051,
	DEVICE_MAX_ON_DEVICE_EVENTS                    = 0x1052,
	DEVICE_SVM_CAPABILITIES                        = 0x1053,
	DEVICE_GLOBAL_VARIABLE_PREFERRED_TOTAL_SIZE    = 0x1054,
	DEVICE_MAX_PIPE_ARGS                           = 0x1055,
	DEVICE_PIPE_MAX_ACTIVE_RESERVATIONS            = 0x1056,
	DEVICE_PIPE_MAX_PACKET_SIZE                    = 0x1057,
	DEVICE_PREFERRED_PLATFORM_ATOMIC_ALIGNMENT     = 0x1058,
	DEVICE_PREFERRED_GLOBAL_ATOMIC_ALIGNMENT       = 0x1059,
	DEVICE_PREFERRED_LOCAL_ATOMIC_ALIGNMENT        = 0x105A,

	// CL_VERSION_2_1
	DEVICE_IL_VERSION                              = 0x105B,
	DEVICE_MAX_NUM_SUB_GROUPS                      = 0x105C,
	DEVICE_SUB_GROUP_INDEPENDENT_FORWARD_PROGRESS  = 0x105D,

	// CL_VERSION_3_0
	DEVICE_NUMERIC_VERSION                         = 0x105E,
	DEVICE_EXTENSIONS_WITH_VERSION                 = 0x1060,
	DEVICE_ILS_WITH_VERSION                        = 0x1061,
	DEVICE_BUILT_IN_KERNELS_WITH_VERSION           = 0x1062,
	DEVICE_ATOMIC_MEMORY_CAPABILITIES              = 0x1063,
	DEVICE_ATOMIC_FENCE_CAPABILITIES               = 0x1064,
	DEVICE_NON_UNIFORM_WORK_GROUP_SUPPORT          = 0x1065,
	DEVICE_OPENCL_C_ALL_VERSIONS                   = 0x1066,
	DEVICE_PREFERRED_WORK_GROUP_SIZE_MULTIPLE      = 0x1067,
	DEVICE_WORK_GROUP_COLLECTIVE_FUNCTIONS_SUPPORT = 0x1068,
	DEVICE_GENERIC_ADDRESS_SPACE_SUPPORT           = 0x1069,
	/* 0x106A to 0x106E - Reserved for upcoming KHR extension */
	DEVICE_OPENCL_C_FEATURES                       = 0x106F,
	DEVICE_DEVICE_ENQUEUE_CAPABILITIES             = 0x1070,
	DEVICE_PIPE_SUPPORT                            = 0x1071,
	DEVICE_LATEST_CONFORMANCE_VERSION_PASSED       = 0x1072,
}

ContextInfo :: enum u32 {
	CL_CONTEXT_REFERENCE_COUNT = 0x1080,
	CL_CONTEXT_DEVICES         = 0x1081,
	CL_CONTEXT_PROPERTIES      = 0x1082,
	// CL_VERSION_1_1
	CL_CONTEXT_NUM_DEVICES     = 0x1083,
}

ContextProperties :: enum i32 {
	CL_CONTEXT_PLATFORM          = 0x1084,
	// CL_VERSION_1_2
	CL_CONTEXT_INTEROP_USER_SYNC = 0x1085,
}

CommandQueueProperties :: enum u64 {
	CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE = (1 << 0),
	CL_QUEUE_PROFILING_ENABLE              = (1 << 1),
	// CL_VERSION_2_0
	CL_QUEUE_ON_DEVICE                     = (1 << 2),
	CL_QUEUE_ON_DEVICE_DEFAULT             = (1 << 3),
}

CommandQueueInfo :: enum u32 {
	CL_QUEUE_CONTEXT          = 0x1090,
	CL_QUEUE_DEVICE           = 0x1091,
	CL_QUEUE_REFERENCE_COUNT  = 0x1092,
	CL_QUEUE_PROPERTIES       = 0x1093,
	// CL_VERSION_2_0
	CL_QUEUE_SIZE             = 0x1094,

	//CL_VERSION_2_1
	CL_QUEUE_DEVICE_DEFAULT   = 0x1095,

	//CL_VERSION_3_0
	CL_QUEUE_PROPERTIES_ARRAY = 0x1098,
}


CommandType :: enum u32 {
	CL_COMMAND_NDRANGE_KERNEL       = 0x11F0,
	CL_COMMAND_TASK                 = 0x11F1,
	CL_COMMAND_NATIVE_KERNEL        = 0x11F2,
	CL_COMMAND_READ_BUFFER          = 0x11F3,
	CL_COMMAND_WRITE_BUFFER         = 0x11F4,
	CL_COMMAND_COPY_BUFFER          = 0x11F5,
	CL_COMMAND_READ_IMAGE           = 0x11F6,
	CL_COMMAND_WRITE_IMAGE          = 0x11F7,
	CL_COMMAND_COPY_IMAGE           = 0x11F8,
	CL_COMMAND_COPY_IMAGE_TO_BUFFER = 0x11F9,
	CL_COMMAND_COPY_BUFFER_TO_IMAGE = 0x11FA,
	CL_COMMAND_MAP_BUFFER           = 0x11FB,
	CL_COMMAND_MAP_IMAGE            = 0x11FC,
	CL_COMMAND_UNMAP_MEM_OBJECT     = 0x11FD,
	CL_COMMAND_MARKER               = 0x11FE,
	CL_COMMAND_ACQUIRE_GL_OBJECTS   = 0x11FF,
	CL_COMMAND_RELEASE_GL_OBJECTS   = 0x1200,
	// CL_VERSION_1_1 
	CL_COMMAND_READ_BUFFER_RECT     = 0x1201,
	CL_COMMAND_WRITE_BUFFER_RECT    = 0x1202,
	CL_COMMAND_COPY_BUFFER_RECT     = 0x1203,
	CL_COMMAND_USER                 = 0x1204,

	// CL_VERSION_1_2
	CL_COMMAND_BARRIER              = 0x1205,
	CL_COMMAND_MIGRATE_MEM_OBJECTS  = 0x1206,
	CL_COMMAND_FILL_BUFFER          = 0x1207,
	CL_COMMAND_FILL_IMAGE           = 0x1208,

	// CL_VERSION_2_0 
	CL_COMMAND_SVM_FREE             = 0x1209,
	CL_COMMAND_SVM_MEMCPY           = 0x120A,
	CL_COMMAND_SVM_MEMFILL          = 0x120B,
	CL_COMMAND_SVM_MAP              = 0x120C,
	CL_COMMAND_SVM_UNMAP            = 0x120D,

	// CL_VERSION_3_0 
	CL_COMMAND_SVM_MIGRATE_MEM      = 0x120E,
}

/* command execution status */
CL_COMPLETE :: 0x0
CL_RUNNING :: 0x1
CL_SUBMITTED :: 0x2
CL_QUEUED :: 0x3


ProgramInfo :: enum u32 {
	CL_PROGRAM_REFERENCE_COUNT            = 0x1160,
	CL_PROGRAM_CONTEXT                    = 0x1161,
	CL_PROGRAM_NUM_DEVICES                = 0x1162,
	CL_PROGRAM_DEVICES                    = 0x1163,
	CL_PROGRAM_SOURCE                     = 0x1164,
	CL_PROGRAM_BINARY_SIZES               = 0x1165,
	CL_PROGRAM_BINARIES                   = 0x1166,
	//CL_VERSION_1_2
	CL_PROGRAM_NUM_KERNELS                = 0x1167,
	CL_PROGRAM_KERNEL_NAMES               = 0x1168,

	// CL_VERSION_2_1
	CL_PROGRAM_IL                         = 0x1169,

	// CL_VERSION_2_2
	CL_PROGRAM_SCOPE_GLOBAL_CTORS_PRESENT = 0x116A,
	CL_PROGRAM_SCOPE_GLOBAL_DTORS_PRESENT = 0x116B,
}

ProgramBuildInfo :: enum u32 {
	CL_PROGRAM_BUILD_STATUS                     = 0x1181,
	CL_PROGRAM_BUILD_OPTIONS                    = 0x1182,
	CL_PROGRAM_BUILD_LOG                        = 0x1183,
	//CL_VERSION_1_2
	CL_PROGRAM_BINARY_TYPE                      = 0x1184,

	//CL_VERSION_2_0
	CL_PROGRAM_BUILD_GLOBAL_VARIABLE_TOTAL_SIZE = 0x1185,
}

// CL_VERSION_1_2
ProgramBinaryType :: enum u32 {
	CL_PROGRAM_BINARY_TYPE_NONE            = 0x0,
	CL_PROGRAM_BINARY_TYPE_COMPILED_OBJECT = 0x1,
	CL_PROGRAM_BINARY_TYPE_LIBRARY         = 0x2,
	CL_PROGRAM_BINARY_TYPE_EXECUTABLE      = 0x4,
}

BuildStatus :: enum i32 {
	CL_BUILD_SUCCESS     = 0,
	CL_BUILD_NONE        = -1,
	CL_BUILD_ERROR       = -2,
	CL_BUILD_IN_PROGRESS = -3,
}

KernelInfo :: enum u32 {
	CL_KERNEL_FUNCTION_NAME   = 0x1190,
	CL_KERNEL_NUM_ARGS        = 0x1191,
	CL_KERNEL_REFERENCE_COUNT = 0x1192,
	CL_KERNEL_CONTEXT         = 0x1193,
	CL_KERNEL_PROGRAM         = 0x1194,
	// CL_VERSION_1_2
	CL_KERNEL_ATTRIBUTES      = 0x1195,
}


KernelArgInfo :: enum u32 {
	// CL_VERSION_1_2
	CL_KERNEL_ARG_ADDRESS_QUALIFIER = 0x1196,
	CL_KERNEL_ARG_ACCESS_QUALIFIER  = 0x1197,
	CL_KERNEL_ARG_TYPE_NAME         = 0x1198,
	CL_KERNEL_ARG_TYPE_QUALIFIER    = 0x1199,
	CL_KERNEL_ARG_NAME              = 0x119A,
}


KernelArgAddressQualifier :: enum u32 {
	// CL_VERSION_1_2
	CL_KERNEL_ARG_ADDRESS_GLOBAL   = 0x119B,
	CL_KERNEL_ARG_ADDRESS_LOCAL    = 0x119C,
	CL_KERNEL_ARG_ADDRESS_CONSTANT = 0x119D,
	CL_KERNEL_ARG_ADDRESS_PRIVATE  = 0x119E,
}


KernelArgAccessQualifier :: enum u32 {
	// CL_VERSION_1_2
	CL_KERNEL_ARG_ACCESS_READ_ONLY  = 0x11A0,
	CL_KERNEL_ARG_ACCESS_WRITE_ONLY = 0x11A1,
	CL_KERNEL_ARG_ACCESS_READ_WRITE = 0x11A2,
	CL_KERNEL_ARG_ACCESS_NONE       = 0x11A3,
}


KernelArgTypeQualifier :: enum u32 {
	// CL_VERSION_1_2
	CL_KERNEL_ARG_TYPE_NONE     = 0,
	CL_KERNEL_ARG_TYPE_CONST    = (1 << 0),
	CL_KERNEL_ARG_TYPE_RESTRICT = (1 << 1),
	CL_KERNEL_ARG_TYPE_VOLATILE = (1 << 2),
	// CL_VERSION_2_0
	CL_KERNEL_ARG_TYPE_PIPE     = (1 << 3),
}

KernelWorkGroupInfo :: enum u32 {
	CL_KERNEL_WORK_GROUP_SIZE                    = 0x11B0,
	CL_KERNEL_COMPILE_WORK_GROUP_SIZE            = 0x11B1,
	CL_KERNEL_LOCAL_MEM_SIZE                     = 0x11B2,
	CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE = 0x11B3,
	CL_KERNEL_PRIVATE_MEM_SIZE                   = 0x11B4,
	// CL_VERSION_1_2
	CL_KERNEL_GLOBAL_WORK_SIZE                   = 0x11B5,
}

KernelSubGroupInfo :: enum u32 {
	// CL_VERSION_2_1
	CL_KERNEL_MAX_SUB_GROUP_SIZE_FOR_NDRANGE = 0x2033,
	CL_KERNEL_SUB_GROUP_COUNT_FOR_NDRANGE    = 0x2034,
	CL_KERNEL_LOCAL_SIZE_FOR_SUB_GROUP_COUNT = 0x11B8,
	CL_KERNEL_MAX_NUM_SUB_GROUPS             = 0x11B9,
	CL_KERNEL_COMPILE_NUM_SUB_GROUPS         = 0x11BA,
}


KernelExecInfo :: enum u32 {
	// CL_VERSION_2_0
	CL_KERNEL_EXEC_INFO_SVM_PTRS              = 0x11B6,
	CL_KERNEL_EXEC_INFO_SVM_FINE_GRAIN_SYSTEM = 0x11B7,
}


/* cl_mem_flags and cl_svm_mem_flags - bitfield */
SvmMemFlags :: enum u64 {
	CL_MEM_READ_WRITE            = (1 << 0),
	CL_MEM_WRITE_ONLY            = (1 << 1),
	CL_MEM_READ_ONLY             = (1 << 2),
	CL_MEM_USE_HOST_PTR          = (1 << 3),
	CL_MEM_ALLOC_HOST_PTR        = (1 << 4),
	CL_MEM_COPY_HOST_PTR         = (1 << 5),
	/* reserved                                   (1 << 6)    */
	//CL_VERSION_1_2
	CL_MEM_HOST_WRITE_ONLY       = (1 << 7),
	CL_MEM_HOST_READ_ONLY        = (1 << 8),
	CL_MEM_HOST_NO_ACCESS        = (1 << 9),


	// CL_VERSION_2_0
	CL_MEM_SVM_FINE_GRAIN_BUFFER = (1 << 10), /* used by cl_svm_mem_flags only */
	CL_MEM_SVM_ATOMICS           = (1 << 11), /* used by cl_svm_mem_flags only */
	CL_MEM_KERNEL_READ_AND_WRITE = (1 << 12),
}

MemFlags :: enum u64 {
	CL_MEM_READ_WRITE            = (1 << 0),
	CL_MEM_WRITE_ONLY            = (1 << 1),
	CL_MEM_READ_ONLY             = (1 << 2),
	CL_MEM_USE_HOST_PTR          = (1 << 3),
	CL_MEM_ALLOC_HOST_PTR        = (1 << 4),
	CL_MEM_COPY_HOST_PTR         = (1 << 5),
	/* reserved                                   (1 << 6)    */
	//CL_VERSION_1_2
	CL_MEM_HOST_WRITE_ONLY       = (1 << 7),
	CL_MEM_HOST_READ_ONLY        = (1 << 8),
	CL_MEM_HOST_NO_ACCESS        = (1 << 9),
	// CL_VERSION_2_0
	CL_MEM_KERNEL_READ_AND_WRITE = (1 << 12),
}


MemMigrationFlags :: enum u64 {
	//CL_VERSION_1_2
	CL_MIGRATE_MEM_OBJECT_HOST              = (1 << 0),
	CL_MIGRATE_MEM_OBJECT_CONTENT_UNDEFINED = (1 << 1),
}


MemObjectType :: enum u32 {
	CL_MEM_OBJECT_BUFFER         = 0x10F0,
	CL_MEM_OBJECT_IMAGE2D        = 0x10F1,
	CL_MEM_OBJECT_IMAGE3D        = 0x10F2,
	// CL_VERSION_1_2
	CL_MEM_OBJECT_IMAGE2D_ARRAY  = 0x10F3,
	CL_MEM_OBJECT_IMAGE1D        = 0x10F4,
	CL_MEM_OBJECT_IMAGE1D_ARRAY  = 0x10F5,
	CL_MEM_OBJECT_IMAGE1D_BUFFER = 0x10F6,

	// CL_VERSION_2_0
	CL_MEM_OBJECT_PIPE           = 0x10F7,
}

MemInfo :: enum u32 {
	CL_MEM_TYPE                 = 0x1100,
	CL_MEM_FLAGS                = 0x1101,
	CL_MEM_SIZE                 = 0x1102,
	CL_MEM_HOST_PTR             = 0x1103,
	CL_MEM_MAP_COUNT            = 0x1104,
	CL_MEM_REFERENCE_COUNT      = 0x1105,
	CL_MEM_CONTEXT              = 0x1106,
	// CL_VERSION_1_1
	CL_MEM_ASSOCIATED_MEMOBJECT = 0x1107,
	CL_MEM_OFFSET               = 0x1108,

	// CL_VERSION_2_0
	CL_MEM_USES_SVM_POINTER     = 0x1109,

	// CL_VERSION_3_0
	CL_MEM_PROPERTIES           = 0x110A,
}


MapFlags :: enum u64 {
	CL_MAP_READ                    = (1 << 0),
	CL_MAP_WRITE                   = (1 << 1),
	// CL_VERSION_1_2
	CL_MAP_WRITE_INVALIDATE_REGION = (1 << 2),
}

EventInfo :: enum u32 {
	CL_EVENT_COMMAND_QUEUE            = 0x11D0,
	CL_EVENT_COMMAND_TYPE             = 0x11D1,
	CL_EVENT_REFERENCE_COUNT          = 0x11D2,
	CL_EVENT_COMMAND_EXECUTION_STATUS = 0x11D3,
	// CL_VERSION_1_1
	CL_EVENT_CONTEXT                  = 0x11D4,
}


ProfilingInfo :: enum u32 {
	CL_PROFILING_COMMAND_QUEUED   = 0x1280,
	CL_PROFILING_COMMAND_SUBMIT   = 0x1281,
	CL_PROFILING_COMMAND_START    = 0x1282,
	CL_PROFILING_COMMAND_END      = 0x1283,
	// CL_VERSION_2_0
	CL_PROFILING_COMMAND_COMPLETE = 0x1284,
}

