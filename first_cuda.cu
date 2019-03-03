#include <stdexcept>
#include <fstream>
#include <iostream>
#include <stdio.h>
#include <cuda_runtime.h>

using namespace std;
bool InitCUDA()
{
    int count;

    cudaGetDeviceCount(&count);
    if(count == 0) {
        fprintf(stderr, "There is no device.\n");
        return false;
    }

    cout << count << endl;


    int i;
    for(i = 0; i < count; i++) {
        cudaDeviceProp prop;
        if(cudaGetDeviceProperties(&prop, i) == cudaSuccess) {
            if(prop.major >= 1) {
                break;
            }
        }
    }

    if(i == count) {
        fprintf(stderr, "There is no device supporting CUDA 1.x.\n");
        return false;
    }

    cudaSetDevice(i);

    return true;
}


int main()
{
    if(!InitCUDA()) {
        return 0;
    }

    printf("CUDA initialized.\n");

    return 0;
}
