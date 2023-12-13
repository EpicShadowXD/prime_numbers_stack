section .data
    num dw 36       ; The number to factorize
    divisor dw 2    ; Starting divisor
    newline db 10   ; ASCII code for newline character

section .text
    global _start

_start:
    ; Clear the stack
    xor ecx, ecx

divisor_loop:
    ; Check if the number is divisible by the current divisor
    mov ax, [num]
    mov bx, [divisor]
    xor dx, dx       ; Clear any previous remainder
    div bx

    ; If divisible, push the divisor onto the stack
    cmp dx, 0
    jne next_divisor ; If not divisible, jump to the next divisor

    ; Divisible, push the divisor onto the stack
    push bx

    ; Update the number with the quotient
    mov [num], ax

next_divisor:
    ; Increment the divisor
    inc word [divisor]

    ; Check if we have reached the square root of the original number
    mov ax, [divisor]
    imul ax, ax
    cmp ax, [num]
    jae end_factorization ; If divisor^2 >= number, end factorization

    ; Otherwise, continue with the next divisor
    jmp divisor_loop

end_factorization:
    ; Print the factors from the stack
    print_factors:
        pop ax           ; Pop the top element from the stack
        test ax, ax
        jz done_printing ; If stack is empty, we are done

        ; Convert the number to ASCII and print the factor
        add ax, '0'      ; Convert the number to ASCII
        mov eax, 4       ; Syscall number for write
        mov ebx, 1       ; File descriptor 1 is STDOUT
        mov ecx, eax     ; ASCII code of the factor
        mov edx, 1       ; Length of the string
        int 0x80         ; Call kernel to write

        ; Print newline character
        mov eax, 4
        mov ebx, 1
        mov ecx, newline
        mov edx, 1
        int 0x80

        jmp print_factors ; Continue printing

done_printing:
    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80
