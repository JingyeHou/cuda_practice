//#include <stdexcept>
//#include <fstream>
//#include <iostream>
//#include <stdio.h>
//#include <cuda_runtime.h>
//#include <stdlib.h>
//
//#define DATA_SIZE 1048576
//
//int data[DATA_SIZE];
//
//using namespace std;
//
//
//#define NUM_THREADS 256
//
//__global__ static void matMultCUDA(const float* a, size_t lda,
//        const float* b, size_t ldb, float* c, size_t ldc, int n)
//    {
//        const int tid = threadIdx.x;
//        const int bid = blockIdx.x;
//        const int idx = bid * blockDim.x + tid;
//        const int row = idx / n;
//        const int column = idx % n;
//        int i;
//
//        if(row < n && column < n) {
//            float t = 0;
//            for(i = 0; i < n; i++) {
//                t += a[row * lda + i] * b[i * ldb + column];
//            }
//            c[row * ldc + column] = t;
//        }
//    }
//
//clock_t matmultCUDA(const float* a, int lda,
//	const float* b, int ldb, float* c, int ldc, int n)
//{
//	float *ac, *bc, *cc;
//	clock_t start, end;
//
//	start = clock();
//	cudaMalloc((void**) &ac, sizeof(float) * n * n);
//	cudaMalloc((void**) &bc, sizeof(float) * n * n);
//	cudaMalloc((void**) &cc, sizeof(float) * n * n);
//
//	cudaMemcpy2D(ac, sizeof(float) * n, a, sizeof(float) * lda,
//		sizeof(float) * n, n, cudaMemcpyHostToDevice);
//	cudaMemcpy2D(bc, sizeof(float) * n, b, sizeof(float) * ldb,
//		sizeof(float) * n, n, cudaMemcpyHostToDevice);
//
//	int blocks = (n + NUM_THREADS - 1) / NUM_THREADS;
//	matMultCUDA<<<blocks * n, NUM_THREADS>>>
//		(ac, n, bc, n, cc, n, n);
//
//	cudaMemcpy2D(c, sizeof(float) * ldc, cc, sizeof(float) * n,
//	sizeof(float) * n, n, cudaMemcpyDeviceToHost);
//
//	cudaFree(ac);
//	cudaFree(bc);
//	cudaFree(cc);
//
//	end = clock();
//
//	return end - start;
//}
//
//void GenerateNumbers(int *number, int size)
//{
//    for(int i = 0; i < size; i++) {
//        number[i] = rand() % 10;
//    }
//}
//
//bool InitCUDA()
//{
//    int count;
//
//    cudaGetDeviceCount(&count);
//    if(count == 0) {
//        fprintf(stderr, "There is no device.\n");
//        return false;
//    }
//
//    cout << count << endl;
//
//
//    int i;
//    for(i = 0; i < count; i++) {
//        cudaDeviceProp prop;
//        if(cudaGetDeviceProperties(&prop, i) == cudaSuccess) {
//            if(prop.major >= 1) {
//                break;
//            }
//        }
//    }
//
//    if(i == count) {
//        fprintf(stderr, "There is no device supporting CUDA 1.x.\n");
//        return false;
//    }
//
//    cudaSetDevice(i);
//
//    return true;
//}
//
//void matmult(const float* a, int lda, const float* b, int ldb,
//        float* c, int ldc, int n)
//    {
//        int i, j, k;
//
//        for(i = 0; i < n; i++) {
//            for(j = 0; j < n; j++) {
//                double t = 0;
//                for(k = 0; k < n; k++) {
//                    t += a[i * lda + k] * b[k * ldb + j];
//                }
//                c[i * ldc + j] = t;
//            }
//        }
//    }
//
//void matgen(float* a, int lda, int n)
//  {
//      int i, j;
//
//      for(i = 0; i < n; i++) {
//          for(j = 0; j < n; j++) {
//              a[i * lda + j] = (float) rand() / RAND_MAX +
//                  (float) rand() / (RAND_MAX * RAND_MAX);
//          }
//      }
//  }
//
//__global__ static void sumOfSquares(int *num, int* result,
//    clock_t* time)
//{
//    int sum = 0;
//    int i;
//    clock_t start = clock();
//    for(i = 0; i < DATA_SIZE; i++) {
//        sum += num[i] * num[i];
//    }
//
//    *result = 2;
//    *time = clock() - start;
//}
//
//void compare_mat(const float* a, int lda,
//       const float* b, int ldb, int n)
//   {
//       float max_err = 0;
//       float average_err = 0;
//       int i, j;
//
//       for(i = 0; i < n; i++) {
//           for(j = 0; j < n; j++) {
//               if(b[i * ldb + j] != 0) {
//                   float err = fabs((a[i * lda + j] -
//                       b[i * ldb + j]) / b[i * ldb + j]);
//                   if(max_err < err) max_err = err;
//                   average_err += err;
//               }
//           }
//       }
//
//       printf("Max error: %g Average error: %g\n",
//           max_err, average_err / (n * n));
//   }
//
//int main()
//{
//	float *a, *b, *c, *d;
//	int n = 1000;
//
//    if(!InitCUDA()) {
//        return 0;
//    }
//
//    printf("CUDA initialized.\n");
//
//    GenerateNumbers(data, DATA_SIZE);
//
//    int* gpudata, *result;
//	clock_t* time;
//	cudaMalloc((void**) &gpudata, sizeof(int) * DATA_SIZE);
//	cudaMalloc((void**) &result, sizeof(int));
//	cudaMalloc((void**) &time, sizeof(clock_t));
//	cudaMemcpy(gpudata, data, sizeof(int) * DATA_SIZE,
//		cudaMemcpyHostToDevice);
//
//	sumOfSquares<<<1, 1, 0>>>(gpudata, result, time);
//
//	int sum;
//	clock_t time_used;
//	cudaMemcpy(&sum, result, sizeof(int), cudaMemcpyDeviceToHost);
//	cudaMemcpy(&time_used, time, sizeof(clock_t),
//		cudaMemcpyDeviceToHost);
//	cudaFree(gpudata);
//	cudaFree(result);
//
//	printf("sum: %d time: %d\n", sum, time_used);
//
//	a = (float*) malloc(sizeof(float) * n * n);
//	b = (float*) malloc(sizeof(float) * n * n);
//	c = (float*) malloc(sizeof(float) * n * n);
//	d = (float*) malloc(sizeof(float) * n * n);
//
//	srand(0);
//
//	matgen(a, n, n);
//	matgen(b, n, n);
//
//	clock_t time1 = matmultCUDA(a, n, b, n, c, n, n);
//
//	matmult(a, n, b, n, d, n, n);
//	compare_mat(c, n, d, n, n);
//
//	double sec = (double) time1 / CLOCKS_PER_SEC;
//	printf("Time used: %.2f (%.2lf GFLOPS)\n", sec,
//		2.0 * n * n * n / (sec * 1E9));
//
//
//    return 0;
//}


#include <stdexcept>
#include <fstream>
#include <iostream>
#include "utils/init_graph.hpp"
#include "utils/read_graph.hpp"
#include "utils/globals.hpp"
#include "prepare_and_process_graph.cuh"
#include "stm.cuh"

#define NUM_THREADS 256

#define DATA_SIZE 10

int data[DATA_SIZE];

//static const bool VerifyByPrim = true;
//static const bool  RunKruskalFindMSTOnly = true;

// Open files safely.
template<typename T_file>
void openFileToAccess(T_file& input_file, std::string file_name) {
	input_file.open(file_name.c_str());
	if (!input_file)
		throw std::runtime_error(
				"Failed to access specified file: " + file_name + "\n");
}

template<typename T_file>
void reOpenFileToAccess(T_file& input_file, std::string file_name) {
	input_file.close();
	openFileToAccess<std::ifstream>(input_file,file_name);
}

template<typename T_file>
void closeFile(T_file& input_file) {
	input_file.close();
}


__global__ static void sumOfSquares(int *num, int* result,
    clock_t* time)
{
    int sum = 0;
    int i;
    clock_t start = clock();
    for(i = 0; i < DATA_SIZE; i++) {
        sum += num[i] * num[i];
    }

    *result = 2;
    *time = clock() - start;
}

using namespace std;

__global__ static void testMark(bool* boolean, LocalVertex* localSet, Vertex* vertex, int* result) {
		int tid = threadIdx.x;
		vertex[tid]._UFDS_ParentIdx = tid - 1;
		vertex[tid].nbrVtxIdx = tid;
		vertex[tid].active = true;
		vertex[tid].lock = tid;
		vertex[tid]._CRSindex = tid;
		vertex[tid].suggestedWeight = tid;
		if (tid == 0) {
			vertex[tid]._UFDS_ParentIdx = tid;
		}
		*result = vertex[tid].nbrVtxIdx;

		uint priority = 4;
		int size = 4;
		int index = 4;
		mark(vertex, localSet, priority, size, index, *boolean);
}

__global__ static void testAddToArray(LocalVertex* localSet) {
		int size = threadIdx.x;
		uint priority = threadIdx.x;
		int index = threadIdx.x;
		int parentIndex = index - 1;
		LocalVertex local;
		local.change = 0;
		local.changed = false;
		local.priority = priority;
		local.vertexIdx = index;
		local.parentIdx = parentIndex;
		local.locked = false;
		addToArray(localSet, size, local);
}

__global__ static void testAcquireLocks(bool* boolean, LocalVertex* localSet, Vertex* vertex) {
	int size = DATA_SIZE;
		*boolean = acquireLocks(localSet, size, vertex);
}

__global__ static void testCommit(LocalVertex* localSet, Vertex* vertex) {
	int size = DATA_SIZE;
	commit(localSet, size, vertex);
}


void get(int & num){
	num = 4;
}
int main(int argc, char** argv) {

	bool* boolean;
	LocalVertex* localSet;
	Vertex * vertex;
	int* gpudata;
	bool *acquireResult;

	int num;
	bool boolResult;
	LocalVertex localSetResult[DATA_SIZE];
	bool acquireResultS;
	Vertex vertexResult[DATA_SIZE];

	cudaMalloc((void**) &gpudata, sizeof(int));
	cudaMalloc((void**) &vertex, sizeof(Vertex) * DATA_SIZE);
	cudaMalloc((void**) &boolean, sizeof(bool));
	cudaMalloc((void**) &acquireResult, sizeof(bool));
	cudaMalloc((void**) &localSet, sizeof(LocalVertex) * DATA_SIZE);

//	test mark
	testMark<<<1, DATA_SIZE, 0>>>(boolean, localSet, vertex, gpudata);
	cudaMemcpy(&num, gpudata, sizeof(int), cudaMemcpyDeviceToHost);
	cudaMemcpy(&boolResult, boolean, sizeof(bool), cudaMemcpyDeviceToHost);
	cout << boolResult << endl;

//	test addToArray
	testAddToArray<<<1, DATA_SIZE, 0>>>(localSet);
	cudaMemcpy(&localSetResult, localSet, sizeof(LocalVertex) * DATA_SIZE, cudaMemcpyDeviceToHost);
	cout << localSetResult[3].vertexIdx << endl;

//	test acquireLocks
	testAcquireLocks<<<1, DATA_SIZE, 0>>>(acquireResult, localSet, vertex);
	cudaMemcpy(&acquireResultS, acquireResult, sizeof(bool), cudaMemcpyDeviceToHost);
	cout << acquireResultS << endl;

//	test commit
	testCommit<<<1, DATA_SIZE, 0>>>(localSet, vertex);
	cudaMemcpy(&vertexResult, vertex, sizeof(Vertex) * DATA_SIZE, cudaMemcpyDeviceToHost);
	cout << vertexResult[0]._UFDS_ParentIdx << endl;


//	free memory
	cudaFree(acquireResult);
	cudaFree(vertex);
	cudaFree(gpudata);
	cudaFree(boolean);
	cudaFree(localSet);

	return 0;
}
