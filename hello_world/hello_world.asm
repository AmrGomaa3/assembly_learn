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

