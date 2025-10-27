# to_lower

This folder contains a simple x86-64 Assembly program that reads user input, converts all uppercase letters to lowercase, and prints the result back to the console.

## Project Structure

```
to_lower/
├── lowercase.asm     ← assembly source file
├── lowercase.o       ← object file
└── lowercase         ← final executable
```

## Purpose

This project demonstrates:

- How to perform I/O operations using Linux syscalls (`read`, `write`, `exit`).
- How to manipulate character data in memory.
- How to use bitwise operations to convert characters to lowercase.

## How It Works

The program reads up to 128 bytes from standard input, converts all uppercase ASCII letters to lowercase by setting bit 5 (0x20), and writes the modified string back to console.

## Code Breakdown

```asm
section .bss
    input RESB 128
    len   RESB 1

section .text
    global _start

_start:
    ; read input
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 128
    syscall

    mov [len], al ; store the number of bytes read (in AL)

    ; convert to lowercase
    movzx rcx, byte [len]
    dec rcx              ; skip newline at the end
    mov rsi, input       ; pointer to input buffer

toLower:
    or byte [rsi], 00100000b  ; set bit 5 -> convert to lowercase
    inc rsi
    dec rcx
    jnz toLower

    ; write output
    mov rsi, input
    movzx rdx, byte [len]
    call _writeToConsole

    ; exit program
    mov rax, 60
    xor rdi, rdi
    syscall

_writeToConsole:
    mov rax, 1
    mov rdi, 1
    syscall
    ret
```

## Explanation

- `input RESB 128`: reserves 128-byte buffer for user input.
- `len   RESB 1`: reserves 1-byte to store length of user input (can store integers up to 255, enough for the 128-byte buffer)
- `global _start`: makes `start_` procedure visible to the linker.
- The read system call number is loaded in rax (`mov rax, 0`).
- `buffer` is loaded in `rsi` and the max number of bytes (i.e. 128) is loaded into `rdx`.
- the system call is invoked via `syscall`.
- The read system call returns the number of read characters in `rax`.
- The length of user input is stored in `len` via `mov [len], al`.
>Note: Since only 128 characters are allowed in the buffer, the value is in 1-byte and stored in `al`.

### Conversion loop:
- Length of user input is stored in `rcx` for the loop counter.
- `dec rcx` to skip the newline character at the end.

  ```asm
  or byte [rsi], 00100000b
  ```
  This bitwise `or` converts uppercase letters (A–Z) to lowercase (a–z) by setting bit 5 in ASCII.  
  Example: `'A' (0x41)` → `'a' (0x61)`.

- **Output Handling:**
  ```asm
  mov rax, 1      ; syscall: write
  mov rdi, 1      ; stdout
  mov rsi, input  ; buffer
  movzx rdx, byte [len] ; number of bytes to write
  syscall
  ```

### Exit:
- Exit system call number `60` is stored in `rax`.
- Exit code `0` loaded into `rdi`.
- System call invoked via `syscall`.

## Building and Running

```bash
# assemble
nasm -f elf64 lowercase.asm -o lowercase.o

# link
ld lowercase.o -o lowercase

# run
./lowercase
```

Example run:

```
HELLO WORLD
hello world
```

## Notes

- Bitwise conversion works safely for ASCII letters. Non-letter characters remain unchanged.
- `or` with `00100000b` (0x20) only affects uppercase alphabetic characters.
