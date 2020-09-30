            global  main
            extern  atoi
            extern  printf

            section .text

main:       ; main(argc, argv)
            cmp     rdi, 0x1
            je      main_Leave
            mov     rdi, [rsi + 0x8]
            call    atoi
            mov     rdi, 0x0
            mov     rsi, 0x1
            mov     rdx, rax
            call    fib
main_Leave:
            xor     rax, rax
            ret

fib:        ; fib(left, right, reps)
            test    rdx, rdx
            je      fib_Leave
            mov     rax, 0x1
            shl     rax, 0x1f
            cmp     rdi, rax
            jge     fib_Overflow
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx
            mov     rdi, format
            mov     rsi, r12
            call    printf
            mov     rdx, r14
            mov     r15, r13
            mov     rsi, r13
            add     rsi, r12
            mov     rdi, r13
            dec     rdx
            jmp     fib
fib_Overflow:
            mov     r15, rdi
            mov     rdi, overflow
            call    printf
fib_Leave:
            pop     rbx
            ret

            section .data

format:     db      "%ld", 0xa, 0x0
overflow:   db      "%lld -> integer overflow!", 0xa, 0x0