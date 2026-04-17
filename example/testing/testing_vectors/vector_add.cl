__kernel void vector_add(__global const int4* A,
                         __global const int4* B,
                         __global int4* C) {
    int id = get_global_id(0);  // Get thread index
    C[id] = A[id] + B[id];      // Perform vector addition
}
