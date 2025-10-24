# Reverse String Using Stack (x86-64 Assembly)

## Overview
This program reverses a string using the stack and outputs it to the console.  
It demonstrates:
- Manual stack manipulation (`push` and `pop`)
- String length calculation using `EQU`
- System calls for writing to stdout and exiting the program

---

## Code

```asmsection .data
    string DB "Hello world"
    len equ $ - string
    newline DB 0xA

section .text
    global _start

_start:
    mov rcx, len ; set up the counter
    mov rsi, string ; move starting address to rsi

    ; push to the stack
    pushing:
        movzx rax, byte [rsi]
        push rax
        inc rsi
        dec rcx
        jnz pushing

    mov rcx, len ; reset the counter
    mov rsi, string ; point rsi back to the starting address

    ; pop from the stack
    popping:
        pop rax
        mov [rsi], al
        inc rsi
        dec rcx
        jnz popping

    ; write to console
    mov rsi, string
    mov rdx, len

    call _writeToConsole

    ; write newline to console
    mov rsi, newline
    mov rdx, 1

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

---

## Explanation

| Section | Purpose |
|----------|----------|
| `.data` | Stores the string, its length, and a newline character. |
| `.text` | Contains the program logic and system calls. |
| `_start` | Entry point of the program. |
| `_writeToConsole` | Subroutine for writing to standard output. |

### Key Instructions
- `movzx rax, byte [rsi]`: Zero-extends a byte to 64 bits.
- `push rax`: Pushes character onto stack.
- `pop rax`: Pops character from stack (reversing order).
- `syscall`: Executes system call (write or exit).

### Behavior
1. Loads the string character-by-character onto the stack.
2. Pops characters back into memory in reverse order.
3. Prints the reversed string and a newline.
4. Exits cleanly with syscall `60`.

---

## Sample Output

```
dlrow olleH
```

---

## Run Instructions

### Assemble and Link
```bash
nasm -f elf64 reverse_string.asm -o reverse_string.o
ld reverse_string.o -o reverse_string
```

### Execute
```bash
./reverse_string
```
