__kernel void vector_add(__global const int* A,
                         __global const int* B,
                         __global int* C) {
    int id = get_global_id(0);  // Get thread index
    C[id] = A[id] + B[id];      // Perform vector addition
}
