// Lorenz Constants
__constant float dt = 0.02;
__constant float sigma = 10.0f;
__constant float rho = 28.0f;
__constant float beta = (float)8/3;

void lorenz(float t, float* x, float* y, float* z) {
	float dx = sigma * (*y - *x);
	float dy = *x * (rho - *z) - *y;
	float dz = *x * *y - beta * *z;
	
	*x += dx * dt;
	*y += dy * dt;
	*z += dz * dt;
}
// Reference article:
// https://www.mauriciopoppe.com/notes/computer-graphics/viewing/projection-transform/#general-perspective-projection-matrix
// https://en.wikipedia.org/wiki/Lorenz_system

// __kernel void multiply_by_2(
// 	__global float* output,
//     const int2 resolution
// ) {
//     int t = get_global_id(0);
//     int x = get_global_id(0);
//     int y = get_global_id(1);
//     int z = get_global_id(2);
    
//     if (x >= resolution[0] || y >= resolution[1]) return;
    
//     float center_x = resolution[0] * 0.5f;
//     float center_y = resolution[1] * 0.5f;
//     int pixel_index = (y * resolution[0] + x) * 3;
    
//     output[pixel_index] = 0.0f;
//     output[pixel_index + 1] = 0.0f;
//     output[pixel_index + 2] = 0.0f;
    
//     float x1 = x;
//     float y1 = y;
//     float z1 = z;

//     lorenz(t, &x1, &y1, &z1);
    
//     if (x1 != 0 || y1 != 0 || z1 != 0) {
// 	    output[pixel_index] = 255.0f;
// 	    output[pixel_index + 1] = 255.0f;
// 	    output[pixel_index + 2] = 255.0f;
//     }
       
// }

__kernel void lorenz_render(
    __global float* output,
    const int2 resolution
) {
    int px = get_global_id(0);
    int py = get_global_id(1);
    
    if (px >= resolution.x || py >= resolution.y) return;
    
    // // Compute which time step this pixel represents
    // int total_pixels = resolution.x * resolution.y;
    // int pixel_id = py * resolution.x + px;
    // int step = pixel_id;  // or map differently
    // output[pixel_id] = 1.0f + px;
    
    // Start position
    float x = 1.0f;
    float y = 1.0f;
    float z = 1.0f;
    // if (step > 10) step = 10;
    
    // Iterate to this step
    for (int i = 0; i < px; i++) {
        float dx = sigma * (y - x);
        float dy = x * (rho - z) - y;
        float dz = x * y - beta * z;
        
        x += dx * dt;
        y += dy * dt;
        z += dz * dt;
    }
    
    // // Project 3D point to 2D pixel (simple orthographic)
    float scale = 1.0f;
    int screen_x = (int)(x * scale + resolution.x * 0.5f);
    int screen_y = (int)(y * scale + resolution.y * 0.5f);
    
    // // Draw if on screen
    if (screen_x >= 0 && screen_x < resolution.x && 
        screen_y >= 0 && screen_y < resolution.y) {
        int idx = (screen_y * resolution.x + screen_x) * 3;
        output[idx + 0] = 1.0f;  // White pixel
        output[idx + 1] = 1.0f;
        output[idx + 2] = 1.0f;
    }
}
