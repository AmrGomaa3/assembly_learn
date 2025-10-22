# sum_array

This folder contains a simple x86-64 Assembly program that sums an array of 16-bit integers and exits.

## Project Structure

```
sum_array/
├── sum.asm         ← assembly source file
├── sum.o           ← object file
└── sum             ← final executable
```

## Purpose

This project demonstrates:

- How to define and iterate over an array in Assembly.  
- How to use registers, memory addressing, and loops.  
- How to perform arithmetic on 16-bit values and accumulate results in a 32-bit register.

## How It Works

The program defines an array of 16-bit (`word`) integers, iterates through them, sums all elements, and then exits. The final sum is stored in the `eax` register when the program finishes.

## Code Breakdown

```asm
section .data
    array DW 5 DUP(2), 8, 5, 13
    size equ ($ - array) / 2

section .text
    global _start

_start:
    mov ecx, size
    mov eax, 0
    mov ebx, array

    sum:
        movzx edx, word [ebx]
        add eax, edx
        add ebx, 2
        loop sum

    mov rax, 60
    xor rdi, rdi
    syscall
```

## Explanation

- `.data` defines an array of 16-bit (`word`) integers:
  ```asm
  array DW 5 DUP(2), 8, 5, 13
  ```
  This expands to: `2, 2, 2, 2, 2, 8, 5, 13`
  
- `size` computes the number of elements:
  ```asm
  size equ ($ - array) / 2
  ```
  `$` is the current address; subtracting `array` gives total bytes, and dividing by `2` converts bytes to element count, since we used 16-bit integers (2 bytes)

- `.text` defines the code section:
  - `mov ecx, size` sets up the loop counter.
  - `mov eax, 0` initializes the sum.
  - `mov ebx, array` points to the start of the array.
    
  - Inside the loop:
    - `movzx edx, word [ebx]` loads a 16-bit element and zero-extends it to 32 bits.
    - `add eax, edx` adds it to the running total.
    - `add ebx, 2` moves to the next element.
    - `loop sum` decrements `ecx` and jumps back if not zero.
      
  - When finished, the program exits via the `exit` syscall.  

At program termination:
- `eax` contains the total sum of all elements.  
- For the defined array, the sum is `2*5 + 8 + 5 + 13 = 36`.

### System Call Usage
```asm
mov rax, 60    ; syscall number for `exit`.  
xor rdi, rdi   ; exit code = 0.  
syscall        ; switch to kernel mode.
```

## Building and Running

```bash
# assemble
nasm -f elf64 sum.asm -o sum.o

# link
ld sum.o -o sum

# run
./sum
```

This program performs the computation silently with no console output. To verify the result, inspect the `eax` register after execution using a debugger:

```bash
gdb ./sum
(gdb) starti                 # start the program
(gdb) si                     # advance the program by one instruction (repeat until loop completes)
(gdb) info registers eax     # check the value of eax after every instruction to see the sum of the array gradually
```

Expected result:
```
eax   0x24   36
```

## Notes

- Each `word` is 2 bytes, hence pointer increments by 2.
- `movzx` is used to avoid sign-extension issues with 16-bit values.
- `loop` automatically decrements `ecx` and jumps if it’s not zero.
