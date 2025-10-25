section .bss
    input RESB 128
    len RESB 1

section .text
    global _start

_start:
    ; read input
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 128

    syscall

    mov [len], al ; get the input length (max 128 characters)

    ; change to lower
    movzx rcx, byte [len]
    dec rcx ; so we don't edit the newline character
    mov rsi, input ; save the input address in rsi

    toLower:
        or byte [rsi], 00100000b
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

