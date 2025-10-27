# assembly_programs

A collection of x86-64 assembly programs (using NASM) that demonstrate core low-level programming techniques, system calls, and data manipulation.
This repository represents a learning progression in assembly for Linux.

## Contents / Modules

Each subfolder is a standalone example illustrating a concept or technique:

* `hello_world` -> minimal “Hello, World!” via write syscall.
* `sum_array` -> sum an array of 16-bit integers using `loop`.
* `string_reverse` -> reverses a string using the stack and push/pop operations and conditional jumps.
* `to_lower` -> read input using read syscall, convert uppercase to lowercase with bitwise manipulation, print output.

## Getting Started

### Prerequisites

* Linux environment (x86-64)
* NASM assembler
* `ld` linker

### How to Build & Run an Example

Each folder contains its own `.asm` source file, which you can build and run independently:

```bash
cd <example_folder>
nasm -f elf64 <example>.asm -o <example>.o     # replace <example> with the filename
ld <example>.o -o <example>
./<example>
```

For examples that do not print output (e.g., `sum_array`), inspect registers via a debugger such as `gdb` to view results.

## Aims & Goals

* Keep examples minimal, clear, and focused on one concept at a time.
* Use raw Linux syscalls only (no C standard library).
* Provide detailed comments explaining register use and logic.
* Serve as compact teaching references for low-level programming.

## Author

**Amr Gomaa**  
Self-taught systems/software developer with a background in engineering.  
GitHub: [AmrGomaa3](https://github.com/AmrGomaa3)

---

This repository is intended as a personal learning resource and open reference for anyone exploring Linux x86-64 assembly programming.
