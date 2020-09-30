            global  main
            extern  atoi
            extern  printf

            section .text

main:
            sub     rsp, 0x8            ; Align stack
            cmp     rdi, 0x1
            je      main_Leave
            mov     rdi, [rsi + 0x8]
            call    atoi
            mov     r15, rax
            mov     r13, 0x0
main_Loop:
            mov     r12, 0xf
            mov     rax, r13
            cdq
            idiv    r12
            test    rdx, rdx
            je      main_FizzBuzz
            mov     r12, 0x3
            mov     rax, r13
            cdq
            idiv    r12
            test    rdx, rdx
            je      main_Fizz
            mov     r12, 0x5
            mov     rax, r13
            cdq
            idiv    r12
            test    rdx, rdx
            je      main_Buzz
            mov     rdi, regular
            mov     rsi, r13
            call    printf
main_Reenter:
            inc     r13
            cmp     r13, r15
            jne     main_Loop
main_Leave:
            xor     rax, rax
            add     rsp, 0x8
            ret
main_FizzBuzz:
            mov     rdi, fizzbuzz
            mov     rsi, r13
            call    printf
            jmp     main_Reenter
main_Fizz:
            mov     rdi, fizz
            mov     rsi, r13
            call    printf
            jmp     main_Reenter
main_Buzz:
            mov     rdi, buzz
            mov     rsi, r13
            call    printf
            jmp     main_Reenter

            section .data

regular:    db      "%d", 0xa, 0x0
fizz:       db      "%d: fizz", 0xa, 0x0
buzz:       db      "%d: buzz", 0xa, 0x0
fizzbuzz:   db      "%d: fizzbuzz", 0xa, 0x0