# CUDA Merge and Bitonic Sort

This project provides efficient implementations of Merge Sort and Bitonic Sort algorithms using CUDA, enabling fast sorting of large arrays through GPU parallel processing. The project includes both CPU and GPU versions of the algorithms, along with a performance comparison to showcase the benefits of using CUDA for sorting tasks.

## Table of Contents

- [Introduction](#introduction)
- [Merge Sort](#merge-sort)
- [Bitonic Sort](#bitonic-sort)
- [Implementation](#implementation)
- [Performance Comparison](#performance-comparison)
- [Requirements](#requirements)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Sorting large datasets efficiently is a common computational challenge. Merge Sort and Bitonic Sort are well-known sorting algorithms that can be implemented using parallel processing techniques, such as those provided by CUDA, to achieve significant speedup compared to traditional CPU-based sorting methods.

This project aims to provide an easy-to-use CUDA-based implementation of Merge Sort and Bitonic Sort, enabling users to sort large arrays efficiently on compatible NVIDIA GPUs.

## Merge Sort

Merge Sort is a popular divide-and-conquer sorting algorithm that efficiently sorts an array by recursively dividing it into two halves, sorting each half, and then merging the sorted halves to produce the final sorted array.

## Bitonic Sort

Bitonic Sort is an efficient parallel sorting algorithm that requires the input size to be a power of 2. It is based on the concept of bitonic sequences, which are sequences that first monotonically increase and then monotonically decrease or vice versa. The algorithm recursively builds a bitonic sequence, and then repeatedly merges bitonic sequences to achieve sorting.

## Implementation

The project contains the following implementations:

- **CPU Merge Sort:** This is a traditional CPU-based implementation of the Merge Sort algorithm using a recursive approach.

- **GPU Merge Sort:** The GPU version of Merge Sort that uses CUDA to achieve parallelism. It utilizes CUDA kernels to perform sorting operations on the GPU.

- **CPU Bitonic Sort:** A CPU-based implementation of the Bitonic Sort algorithm. It requires the input size to be a power of 2.

- **GPU Bitonic Sort:** The GPU version of Bitonic Sort that takes advantage of CUDA parallelism. Like the GPU Merge Sort, it uses CUDA kernels for sorting on the GPU.

## Performance Comparison

The performance comparison section presents benchmark results of the CPU and GPU implementations for both Merge Sort and Bitonic Sort. It measures the execution time for each approach and demonstrates the potential speedup gained by using CUDA on compatible GPUs.

## Requirements

To run this project, you need the following:

- A compatible NVIDIA GPU with CUDA support.
- NVIDIA CUDA Toolkit installed on your system.
- C++ compiler with CUDA support (e.g., NVCC).

## Usage

1. Clone or download the project repository to your local machine.
2. Ensure you have met the requirements mentioned in the previous section.
3. Compile the source files using the appropriate C++ compiler with CUDA support.
4. Run the compiled executable to sort arrays using either Merge Sort or Bitonic Sort.
5. The program will provide sorted arrays and performance timings for both CPU and GPU implementations.

## Contributing

Contributions to this project are welcome. If you find any issues or have improvements to suggest, feel free to open an issue or create a pull request.

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute the code as per the terms of the license.

## Outputs
![image](https://github.com/rbga/CUDA-Merge-and-Bitonic-Sort/assets/75168756/510c4afb-1aa7-4add-abba-41e2fb0db8bb)
Testing the inputs and Merge Sort with a Small Array
![image](https://github.com/rbga/CUDA-Merge-and-Bitonic-Sort/assets/75168756/49b813d1-f997-49a8-bae9-216cc149de6e)
Testing Bitonic Sort with a Small Array
![image](https://github.com/rbga/CUDA-Merge-and-Bitonic-Sort/assets/75168756/2348af41-6314-4964-a95b-7282e8d42dde)
Merge Sort CPU vs GPU performance for a large Array
![image](https://github.com/rbga/CUDA-Merge-and-Bitonic-Sort/assets/75168756/0e2b662b-165c-43ab-9d30-51dfc6ebd132)
Bitonic Sort CPU vs GPU performance for a large Array.

Clearly Bitonic Sort performs well in a Parallel Computation while Merge Sort performs well in a linear computation.



