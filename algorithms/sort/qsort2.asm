; ------------------------------------------------------------------------------
; -- void qsort(int *arr, int lo, int hi);
; ------------------------------------------------------------------------------
qsort:
            push    r12
            push    r13
            push    r14
            push    r15
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx
            cmp     r13, r14
            jge     qsort_Leave
            call    partition
            mov     r15, rax
            mov     rdi, r12
            mov     rsi, r13
            lea     rdx, [r15 - 0x1]
            call    qsort
            mov     rdi, r12
            lea     rsi, [r15 + 0x1]
            mov     rdx, r14
qsort_Leave:
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- void partition(int *arr, int lo, int hi);
; ------------------------------------------------------------------------------
partition:
            mov     ecx, dword [rdi + rdx*0x4]
            mov     r8, rsi
            mov     r9, rsi
partition_Loop:
            mov     r10d, dword [rdi + r8*0x4]
            mov     r11d, dword [rdi + r9*0x4]
            cmp     r11d, ecx
            cmovge  eax, r10d
            cmovl   eax, r11d
            mov     dword [rdi + r8*0x4], eax
            cmovge  eax, r11d
            cmovl   eax, r10d
            mov     dword [rdi + r9*0x4], eax
            lea     rax, [r8 + 1]
            cmovl   r8, rax
            inc     r9
            cmp     r9, rdx
            jb      partition_Loop
            mov     r10d, dword [rdi + r8*0x4]
            mov     r11d, dword [rdi + rdx*0x4]
            mov     dword [rdi + r8*0x4], r11d
            mov     dword [rdi + rdx*0x4], r10d
            mov     rax, r8
            ret