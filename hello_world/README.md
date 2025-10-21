# hello_world

This folder contains a minimal “Hello, world” program written in x86 Assembly for Linux.

## Project Structure

```
hello_world/
├── hello.asm         ← the assembly source file
├── hello.o           ← object file after assembling
└── hello             ← final executable
```

## Purpose

This project is meant to:

- Demonstrate how to write a minimal Assembly program that outputs “Hello, World!” to the console.
- Show how to assemble and link the code into an executable for Linux using `nasm` and `ld`.
- Serve as a starting point for learning low-level programming and Linux system calls.

## How It Works

The program writes “Hello, World!” to the console then exits using Linux system calls directly, without the C standard library.

### Code Breakdown

```asm
section .data
    msg DB "Hello, world",0xA, 0
    size equ $ - msg

section .text
    global _start

_start:
    mov rax, 1 ; write syscall = 1
    mov rdi, 1 ; stdout = 1
    mov rsi, msg ; start of msg
    mov rdx, size ; length of message
    syscall ; switch to kernel mode

_exitCall:
    mov rax, 60 ; exit syscall = 60
    xor rdi, rdi ; exit code = 0
    syscall ; switch to kernel mode
```

### Explanation

- Define the "Hello world!" message in `section .data`
- Add a newline `0xA` and a null terminator `0` to the message.
- Define the `size` of the message as a constant.
- Set `global _start` to make the start procedure visible to the linker during the linking stage.
- Define a procedure named `_start` to start the program.
- `mov rax, 1`: load the system call for `write` to write to the console.
- `mov rdi, 1`: set file descriptor to stdout.
- `mov rsi` and `mov rdx` set up the message pointer and length.
- `syscall` switches to kernel mode for the system call interrupt.
- Define a procedure named `_exitCall` to exit the program.
- `mov rax, 60`: load the system call for `exit` to exit the program.
- `xor rdi, rdi`: set `rdi` to `0` for the exit code.
- Again `syscall` to switch to kernel mode and exit the program cleanly.

This style directly interacts with the Linux kernel, showcasing pure system-level programming.

> - `$ - msg` subtracts the memory address of the first character from the current assembly position to get the length of the string including the newline and null terminator.
> - `xor rdi, rdi` is slightly more efficient than `mov rdi, 0`
> - It is not necessary to invoke the `exit` system call, but it is generally a good practice.
> - The null terminator is not necessary in this case but used as a convention.

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
Hello, world
```

## Notes:
- Target: Linux x86-64
- Works on any modern Linux distro with NASM installed
