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
