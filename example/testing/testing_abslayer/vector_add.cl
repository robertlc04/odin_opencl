__kernel void vector_add(__global const uint *A,
                         __global const unsigned int *B,
                         __global int *C) {
    int id = get_global_id(0);  // Get thread index
    C[id] = A[id] + B[id];      // Perform vector addition
}

