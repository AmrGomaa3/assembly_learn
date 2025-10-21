# hello_world

This folder contains a minimal “Hello, World!” program written in x86 Assembly for Linux.

## Project Structure

```
hello_world/
├── hello.asm         ← the assembly source file
├── hello.o           ← compiled object file
└── hello              ← final executable (or intended output)
```

## Purpose

This project is meant to:

- Demonstrate how to write a minimal Assembly program that outputs “Hello, World!” to standard output (console).
- Show how to assemble and link the code into an executable.
- Serve as a starting point for learning low-level programming and Linux system calls.

## Prerequisites

Before running or building:

- An assembler and linker (`nasm`, `ld`).
- A Linux environment on x86 architecture.
- Basic understanding of registers, memory, and system calls.

## How It Works

The program writes “Hello, World!” to standard output using Linux system calls directly, without the C standard library.

### Code Breakdown

```asm
section .data
    msg db "Hello, World!", 10     ; string + newline
    len equ $ - msg                ; compute length

section .text
    global _start

_start:
    mov eax, 4        ; sys_write
    mov ebx, 1        ; file descriptor (stdout)
    mov ecx, msg      ; pointer to message
    mov edx, len      ; message length
    int 0x80          ; call kernel

    mov eax, 1        ; sys_exit
    xor ebx, ebx      ; exit code 0
    int 0x80
```

### Explanation

- `mov eax, 4` loads the syscall number for `write`.
- `mov ebx, 1` sets file descriptor to stdout.
- `mov ecx` and `mov edx` set up the message pointer and length.
- `int 0x80` triggers the syscall interrupt.
- Then, `sys_exit` is invoked to terminate the program cleanly.

This style directly interacts with the Linux kernel, showcasing pure system-level programming.

## Building and Running

```bash
# assemble
nasm -f elf64 hello.asm -o hello.o

# link
ld hello.o -o hello

# run
./hello
```

Expected output:

```
Hello, World!
```

## Notes

- The `equ $ - msg` line calculates the string length automatically.
- This example uses 32-bit syscalls (`int 0x80`). On 64-bit systems, use `syscall` with 64-bit conventions.
- Make sure to install 32-bit support libraries if running on a 64-bit OS.
