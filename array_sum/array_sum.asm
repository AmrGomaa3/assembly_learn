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

