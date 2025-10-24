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
- How to perform loops using conditional jumps.
- How to perform basic system calls (`write`, `exit`).
- How to use memory addressing, loops, and stack operations.

## How It Works

The program pushes each character of a string to the stack, pops them back in reverse order, and writes the result to the console, followed by a newline for clean output.

## Code Breakdown

```asm
section .data
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

## Explanation

- `.data` defines the original string and its length:
  
  ```asm
  string DB "Hello world"
  len equ $ - string
  ```
  - `string` contains the message.
  - `len` calculates the length of the message by subtracting `string` (pointer to first character) from `$` (pointer to the current address), giving the total bytes.
  - `newline` adds a newline character (`0xA`) for clean console output.

- `.text` holds the code section:
- `global _start` makes the `_start` procedure visible for the linker.
- `mov rcx, len` initializes the loop counter to the length of the string.
- `mov rsi, string` loads the starting address of the string.

### Push Phase
Each character is pushed onto the stack, one by one:
```asm
movzx rax, byte [rsi]
push rax
```
`movzx` ensures proper zero-extension from 8-bit to 64-bit before pushing.
> Note: Each push operation pushes 8 bytes (64 bits) in the x86-64 architecture.

- `inc rsi` moves `rsi` to the next character in the string.
- `dec rcx` decrements loop counter. Once it reaches `0` the zero flag (ZF) is set.
- `jnz` performs a conditional jump back to the start of the `pushing` label as long as ZF has not been set.

### Pop Phase
After pushing all characters, the program resets the loop counter, and points `rsi` back to the starting address of the string:
```asm
mov rcx, len       ; reset the counter
mov rsi, string    ; point rsi back to the starting address
```
Then, the program pops characters back to memory, reversing the string in-place:

```asm
pop rax
mov [rsi], al
inc rsi
dec rcx
jnz popping
```
> Note: `mov [rsi], al` only stores the low byte of `rax` which contains the character.

### Writing to Console
We load the starting address of the string in `rsi`, and the length of the string in `rdx`, before we call `_writeToConsole`.
The `_writeToConsole` procedure uses the Linux `write` syscall:

```asm
mov rax, 1     ; syscall: write
mov rdi, 1     ; file descriptor: stdout
syscall
```

We then load the newline character in `rsi` and `1` in `rdx` before making another call to `_writeToConsole` to write the newline character.

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
- The program modifies the string in-place with no extra buffers used.
