#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <algorithm>

#define MAX_THREADS_PER_BLOCK 1024

// Bitonic Sort for CPU
void bitonicSortCPU(int* arr, int n) 
{
    for (int k = 2; k <= n; k *= 2) 
    {
        for (int j = k / 2; j > 0; j /= 2) 
        {
            for (int i = 0; i < n; i++) 
            {
                int ij = i ^ j;

                if (ij > i) 
                {
                    if ((i & k) == 0) 
                    {
                        if (arr[i] > arr[ij])
                        {
                            int temp = arr[i];
                            arr[i] = arr[ij];
                            arr[ij] = temp;
                        }
                    }
                    else 
                    {
                        if (arr[i] < arr[ij])
                        {
                            int temp = arr[i];
                            arr[i] = arr[ij];
                            arr[ij] = temp;
                        }
                    }
                }
            }
        }
    }
}

//GPU Kernel Implementation of Bitonic Sort
__global__ void bitonicSortGPU(int* arr, int j, int k)
{
    unsigned int i, ij;

    i = threadIdx.x + blockDim.x * blockIdx.x;

    ij = i ^ j;

    if (ij > i)
    {
        if ((i & k) == 0)
        {
            if (arr[i] > arr[ij])
            {
                int temp = arr[i];
                arr[i] = arr[ij];
                arr[ij] = temp;
            }
        }
        else
        {
            if (arr[i] < arr[ij])
            {
                int temp = arr[i];
                arr[i] = arr[ij];
                arr[ij] = temp;
            }
        }
    }
}

//Device function for recursive Merge
__device__ void Merge(int* arr, int* temp, int left, int middle, int right) 
{
    int i = left;
    int j = middle;
    int k = left;

    while (i < middle && j < right) 
    {
        if (arr[i] <= arr[j])
            temp[k++] = arr[i++];
        else
            temp[k++] = arr[j++];
    }

    while (i < middle)
        temp[k++] = arr[i++];
    while (j < right)
        temp[k++] = arr[j++];

    for (int x = left; x < right; x++)
        arr[x] = temp[x];
}

//GPU Kernel for Merge Sort
__global__ void MergeSortGPU(int* arr, int* temp, int n, int width) 
{
    int tid = threadIdx.x + blockDim.x * blockIdx.x;
    int left = tid * width;
    int middle = left + width / 2;
    int right = left + width;

    if (left < n && middle < n) 
    {
        Merge(arr, temp, left, middle, right);
    }
}

//CPU Merge Recursive Call function
void merge(int* arr, int* temp, int left, int mid, int right) 
{
    int i = left;
    int j = mid + 1;
    int k = left;

    while (i <= mid && j <= right) 
    {
        if (arr[i] <= arr[j])
            temp[k++] = arr[i++];
        else
            temp[k++] = arr[j++];
    }

    while (i <= mid)
        temp[k++] = arr[i++];

    while (j <= right)
        temp[k++] = arr[j++];

    for (int idx = left; idx <= right; ++idx)
        arr[idx] = temp[idx];
}

//CPU Implementation of Merge Sort
void mergeSortCPU(int* arr, int* temp, int left, int right) 
{
    if (left >= right)
        return;

    int mid = left + (right - left) / 2;

    mergeSortCPU(arr, temp, left, mid);
    mergeSortCPU(arr, temp, mid + 1, right);

    merge(arr, temp, left, mid, right);
}

//Function to print array
void printArray(int* arr, int size) 
{
    for (int i = 0; i < size; ++i)
        std::cout << arr[i] << " ";
    std::cout << std::endl;
}

//Automated function to check if array is sorted
bool isSorted(int* arr, int size) 
{
    for (int i = 1; i < size; ++i) 
    {
        if (arr[i] < arr[i - 1])
            return false;
    }
    return true;
}

//Function to check if given number is a power of 2
bool isPowerOfTwo(int num) 
{
    return num > 0 && (num & (num - 1)) == 0;
}


//MAIN PROGRAM
int main()
{
    int choice;
    std::cout << "Select the type of sort:";
    std::cout << "\n\t1. Merge Sort";
    std::cout << "\n\t2. Bitonic Sort";
    std::cout << "\nEnter your choice: ";
    std::cin >> choice;

    
    if (choice < 1 || choice > 2)
    {
        while (choice != 1 || choice != 2)
        {
            std::cout << "\n!!!!! WRONG CHOICE. TRY AGAIN. YOU HAVE ONLY 2 DISTINCT OPTIONS-\n";
            std::cin >> choice;


            if (choice == 1 || choice == 2)
                break;
        }
    }

    if (choice == 1)
    {
        std::cout << "\n--------------------------------------------------------------\nMERGE SORT SELECTED\n--------------------------------------------------------------";
    }
    else
    {
        std::cout << "\n--------------------------------------------------------------\nBITONIC SORT SELECTED\n--------------------------------------------------------------";
    }

    int size;
    std::cout << "\n\nEnter the size of the array. Must be a power of 2:\n ";
    std::cin>>size;

    while (!isPowerOfTwo(size))
    {
        if (!isPowerOfTwo(size))
        {
            std::cout << "\nWrong Size, must be power of 2. Try again:\n ";
            std::cin>>size;
        }
        else
            break;
    }

    std::cout << "\n--------------------------------------------------------------\nSELECTED SORT PROCESS UNDERWAY\n--------------------------------------------------------------";
    
    //Create CPU based Arrays
    int* arr = new int[size];
    int* carr = new int[size];
    int* temp = new int[size];

    //Create GPU based arrays
    int* gpuArrmerge;
    int* gpuArrbiton;
    int* gpuTemp;

    // Initialize the array with random values
    srand(static_cast<unsigned int>(time(nullptr)));
    for (int i = 0; i < size; ++i) 
    {
        arr[i] = rand() % 100;
        carr[i] = arr[i];
    }

    //Print unsorted array 
    std::cout << "\n\nUnsorted array: ";
    if (size <= 100) 
    {
        printArray(arr, size);
    }
    else 
    {
        printf("\nToo Big to print. Check Variable. Automated isSorted Checker will be implemented\n");
    }

    // Allocate memory on GPU
    cudaMalloc((void**)&gpuArrmerge, size * sizeof(int));
    cudaMalloc((void**)&gpuTemp, size * sizeof(int));
    cudaMalloc((void**)&gpuArrbiton, size * sizeof(int));

    // Copy the input array to GPU memory
    cudaMemcpy(gpuArrmerge, arr, size * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(gpuArrbiton, arr, size * sizeof(int), cudaMemcpyHostToDevice);

    // Perform GPU merge sort and measure time
    cudaEvent_t startGPU, stopGPU;
    cudaEventCreate(&startGPU);
    cudaEventCreate(&stopGPU);
    float millisecondsGPU = 0;

    //Initialize CPU clock counters
    clock_t startCPU, endCPU;

    //Set number of threads and blocks for kernel calls
    int threadsPerBlock = MAX_THREADS_PER_BLOCK;
    int blocksPerGrid = (size + threadsPerBlock - 1) / threadsPerBlock;

    //Main If else block
    if (choice == 1)
    {
        //Call GPU Merge Kernel and time the run
        cudaEventRecord(startGPU);
        for (int wid = 1; wid < size; wid *= 2)
        {
            MergeSortGPU << <threadsPerBlock, blocksPerGrid >> > (gpuArrmerge, gpuTemp, size, wid * 2);
        }
        cudaEventRecord(stopGPU);

        //Transfer sorted array back to CPU
        cudaMemcpy(arr, gpuArrmerge, size * sizeof(int), cudaMemcpyDeviceToHost);

        //Calculate Elapsed GPU time
        cudaEventSynchronize(stopGPU);
        cudaEventElapsedTime(&millisecondsGPU, startGPU, stopGPU);

        //Time the CPU and call CPU Merge Sort
        startCPU = clock();
        mergeSortCPU(carr, temp, 0, size - 1);
        endCPU = clock();
    }

    else
    {
        int j, k;

        //Time the run and call GPU Bitonic Kernel
        cudaEventRecord(startGPU);
        for (k = 2; k <= size; k <<= 1)
        {
            for (j = k >> 1; j > 0; j = j >> 1)
            {
                bitonicSortGPU << <blocksPerGrid, threadsPerBlock >> > (gpuArrbiton, j, k);
            }
        }
        cudaEventRecord(stopGPU);

        //Transfer Sorted array back to CPU
        cudaMemcpy(arr, gpuArrbiton, size * sizeof(int), cudaMemcpyDeviceToHost);
        cudaEventSynchronize(stopGPU);
        cudaEventElapsedTime(&millisecondsGPU, startGPU, stopGPU);

        //Time the run and call CPU Bitonic Sort
        startCPU = clock();
        bitonicSortCPU(carr, size);
        endCPU = clock();
    }

    //Calculate Elapsed CPU time
    double millisecondsCPU = static_cast<double>(endCPU - startCPU) / (CLOCKS_PER_SEC / 1000.0);

    // Display sorted GPU array
    std::cout << "\n\nSorted GPU array: ";
    if (size <= 100) 
    {
        printArray(arr, size);
    }
    else {
        printf("\nToo Big to print. Check Variable. Automated isSorted Checker will be implemented\n");
    }

    //Display sorted CPU array
    std::cout << "\nSorted CPU array: ";
    if (size <= 100) 
    {
        printArray(carr, size);
    }
    else {
        printf("\nToo Big to print. Check Variable. Automated isSorted Checker will be implemented\n");
    }
    
    //Run the array with the automated isSorted checker
    if (isSorted(arr, size))
        std::cout << "\n\nSORT CHECKER RUNNING - SUCCESFULLY SORTED GPU ARRAY" << std::endl;
    else
        std::cout << "SORT CHECKER RUNNING - !!! FAIL !!!" << std::endl;
   
    if (isSorted(carr, size))
        std::cout << "SORT CHECKER RUNNING - SUCCESFULLY SORTED CPU ARRAY" << std::endl;
    else
        std::cout << "SORT CHECKER RUNNING - !!! FAIL !!!" << std::endl;

    //Print the time of the runs
    std::cout << "\n\nGPU Time: " << millisecondsGPU << " ms" << std::endl;
    std::cout << "CPU Time: " << millisecondsCPU << " ms" << std::endl;

    //Destroy all variables
    delete[] arr;
    delete[] carr;
    delete[] temp;

    //End
    cudaFree(gpuArrmerge);
    cudaFree(gpuArrbiton);
    cudaFree(gpuTemp);

    std::cout << "\n------------------------------------------------------------------------------------\n||||| END. YOU MAY RUN THIS AGAIN |||||\n------------------------------------------------------------------------------------";
    return 0;
}