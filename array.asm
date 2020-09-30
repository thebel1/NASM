            global  main
            extern  malloc
            extern  free
            extern  printf
            default rel

            section .text
main:
            mov     rcx, 0xa            ; array size
            mov     rdx, 0x4            ; element size (int)
            mov     rdi, rcx
            push    rcx
            push    rdx
            call    initArray
            pop     rdx
            pop     rcx
            push    rbp
            mov     rbp, rax
            mov     rax, 0x0
print_Loop:
            mov     rbx, rax
            imul    rbx, rdx
            mov     rdi, format
            mov     esi, dword [rbp + rbx]
            push    rcx
            push    rdx
            push    rax
            sub     rsp, 0x8            ; align stack to 16 bytes
            call    printf
            add     rsp, 0x8
            pop     rax
            pop     rdx
            pop     rcx
            inc     rax
            cmp     rax, rcx
            jne     print_Loop
            mov     rdi, rbp
            call    freeArray
            xor     eax, eax
            pop     rbp
            ret

initArray:
            push    rbx
            mov     rcx, rdi
            mov     rdx, 0x4            ; array element size (int)
            imul    rdi, rdx
            push    rcx
            push    rdx
            call    malloc
            pop     rdx
            pop     rcx
            mov     rbx, rax
            mov     rax, 0x0
initArray_Loop:
            mov     rdi, rax
            imul    rdi, rdx
            mov     dword [rbx + rdi], eax
            inc     rax
            cmp     rax, rcx
            jne     initArray_Loop
            mov     rax, rbx
            pop     rbx
            ret

freeArray:
            call    free
            ret

            section .data
format:     db      "%d", 0xa, 0x0