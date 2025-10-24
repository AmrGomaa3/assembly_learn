# reverse_string

This folder contains a simple x86-64 Assembly program that reverses a string by pushing each character to the stack and then popping it back in reverse order.

## Project Structure

```
reverse_string/
├── reverse.asm      ← assembly source file
├── reverse.o        ← object file
└── reverse          ← final executable
```

## Purpose

This project demonstrates:

- How to manipulate strings in Assembly.  
- How to use the stack to reverse data.  
- How to perform basic system calls (`write`, `exit`).  
- How to use memory addressing, loops, and stack operations.

## How It Works

The program pushes each character of a string to the stack, pops them back in reverse order, and writes the result to the console, followed by a newline.

## Code Breakdown

```asm
section .data
    string DB "Hello world"
    len equ $ - string
    newline DB 0xA

section .text
    global _start

_start:
    mov rcx, len
    mov rsi, string

    ; push to the stack
    pushing:
        movzx rax, byte [rsi]
        push rax
        inc rsi
        dec rcx
        jnz pushing

    mov rcx, len
    mov rsi, string

    ; pop from the stack
    popping:
        pop rax
        mov [rsi], al
        inc rsi
        dec rcx
        jnz popping

    ; write reversed string
    mov rsi, string
    mov rdx, len
    call _writeToConsole

    ; newline
    mov rsi, newline
    mov rdx, 1
    call _writeToConsole

    ; exit
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

- `.data` defines the original string and its length:
  ```asm
  string DB "Hello world"
  len equ $ - string
  ```
  - `string` contains the message.
  - `len` calculates its length at assembly time.
  - `newline` adds a newline character (`0xA`) for clean console output.

- `.text` holds the code section:
  - `mov rcx, len` initializes the loop counter.
  - `mov rsi, string` loads the starting address.

### Push Phase
Each character is pushed onto the stack, one by one:
```asm
movzx rax, byte [rsi]
push rax
```
`movzx` ensures proper zero-extension from 8-bit to 64-bit before pushing.

### Pop Phase
After pushing all characters, the program pops them back to memory — reversing the string in-place.

```asm
pop rax
mov [rsi], al
```

### Writing to Console
The `_writeToConsole` procedure uses the Linux `write` syscall:
```asm
mov rax, 1     ; syscall: write
mov rdi, 1     ; file descriptor: stdout
mov rsi, string
mov rdx, len
syscall
```

### Exiting
Finally, it uses the `exit` syscall (`rax=60`) with exit code 0.

## Building and Running

```bash
# assemble
nasm -f elf64 reverse.asm -o reverse.o

# link
ld reverse.o -o reverse

# run
./reverse
```

Expected output:
```
dlrow olleH
```

## Notes

- Stack operations naturally reverse order, making it ideal for this task.
- `movzx` is critical to correctly push bytes without garbage in upper bits.
- The program modifies the string in-place — no extra buffers used.
