section .rodata
    opr_prompt: db "Please select an operator out of +, -, / and x: ", 0
    opr_len: equ $-opr_prompt

    answer_format: db "The answer is: ", 0
    answer_format_length: equ $-answer_format

    num_prompt: db "Please input a number here: ", 0
    num_prompt_len: equ $-num_prompt

section .bss
    operator: resb 2

    number1: resb 4
    number2: resb 4
    
    solution: resb 4

    result_buffer: resb 11
    result_length equ $-result_buffer

section .text
    global _start
    extern printf

_start:
    ; Print write operator prompt.
    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, opr_prompt
    mov edx, opr_len
    int 0x80
    
    ; Read user input for operator.
    mov eax, 0x3
    mov ebx, 0
    mov ecx, operator
    mov edx, 0x2
    int 0x80

    ; Compare user input
    mov al, byte [operator]
    cmp al, 0x2b ; 0x2b is ASCII for '+'
    je  addition
    cmp al, 0x2d ; 0x2d is ASCII for '-'
    je  subtraction
    cmp al, 0x2f ; 0x2f is ASCII for '/'
    je  division
    cmp al, 0x78 ; 0x78 is ASCII for 'x'
    je  multiply

    ; Exit the program
    call exit

addition:
    call read_numbers
    call conver_input
    add eax, ebx
    mov [solution], eax

    call convert_int_to_ASCII

    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, result_buffer
    mov edx, result_length
    int 0x80
    
    call exit
    
subtraction:
    call read_numbers
    call conver_input
    sub eax, ebx
    mov [solution], eax

    call convert_int_to_ASCII

    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, result_buffer
    mov edx, result_length
    int 0x80

    call exit

division:
    call read_numbers
    call conver_input
    mov edx, 0
    div ebx
    mov [solution], eax

    call convert_int_to_ASCII

    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, result_buffer
    mov edx, result_length
    int 0x80

    call exit

multiply:
    call read_numbers
    call conver_input
    mul  ebx
    mov [solution], eax

    call convert_int_to_ASCII

    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, result_buffer
    mov edx, result_length
    int 0x80

    call exit

read_numbers:
    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, num_prompt
    mov edx, num_prompt_len
    int 0x80

    mov eax, 0x3
    mov ebx, 0
    mov ecx, number1
    mov edx, 0xa
    int 0x80

    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, num_prompt
    mov edx, num_prompt_len
    int 0x80

    mov eax, 0x3
    mov ebx, 0
    mov ecx, number2
    mov edx, 0xa
    int 0x80
    ret

convert_int_to_ASCII:
    mov eax, [solution]          ; load the integer value to a register
    mov ebx, 0xa            ; set the divisor to 10
    mov ecx, result_buffer  ; point ecx to result buffer
    add ecx, result_length  ; move the pointer to the end of the buffer

    mov byte [ecx], 0       ; terminate the value with a 0 character
    dec ecx                 ; move the pointer back 1 position

    convert_loop:
        xor edx, edx        ; clear edx
        div ebx             ; divide eax by 10

        add dl, 0x30         ; convert the remainder to an ASCII character
        mov [ecx], dl       ; load the result in the result buffer
        dec ecx

        test eax, eax
        jnz convert_loop

    ret

conver_input:
    mov eax, [number1]
    sub eax, 0xa30
    mov ebx, [number2]
    sub ebx, 0xa30
    ret

exit:
    mov eax, 0x1
    xor ebx, ebx
    int 0x80