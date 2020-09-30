; ######################################################
; Relative Sort Array
;
; https://leetcode.com/problems/relative-sort-array/
; ######################################################

            default rel
            global  main
            extern  malloc
            extern  free
            extern  printf

            section .text

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
; ------------------------------------------------------------------------------
main:
            push    r12
            push    r13
            push    r14
            push    r15
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            cmp     r12, 0x3
            jne     main_Leave
            mov     rdi, qword [r13 + 0x8]
            mov     rsi, 0x2c                           ; ASCII comma
            lea     rdx, [rsp + 0x4]
            call    split
            mov     r12, rax
            xor     r14, r14                            ; Limitation of movzx: https://forum.nasm.us/index.php?topic=2071.0
            mov     r14d, dword [rsp + 0x4]
            mov     rdi, qword [r13 + 0x10]
            mov     rsi, 0x2c
            lea     rdx, [rsp]
            call    split
            mov     r13, rax
            xor     r15, r15
            mov     r15d, dword [rsp]
            mov     rdi, r13
            mov     rsi, r12
            mov     rdx, r15
            mov     rcx, r14
            call    rsort
            mov     rdi, r13
            call    free
            mov     r13, 0x0
            dec     r14
main_Loop:
            mov     rdi, outFmt
            mov     esi, dword [r12 + r13*0x4]
            call    printf
            inc     r13
            cmp     r13, r14
            jl      main_Loop
            mov     rdi, outFmtEnd
            mov     esi, dword [r12 + r13*0x4]
            call    printf
            mov     rdi, newline
            call    printf
            mov     rdi, r12
            call    free
main_Leave:
            add     rsp, 0x8
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            xor     rax, rax
            ret

; ------------------------------------------------------------------------------
; -- int *split(char *str, char del, int *size);
; ------------------------------------------------------------------------------
split:
            push    r12
            push    r13
            push    r14
            push    r15
            push    rdx
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, 0x0
            mov     r15, 0x0
            mov     al, byte [r12]
split_LenLoop:
            cmp     al, r13b
            lea     rdx, [r15 + 0x1]
            cmove   r15, rdx
            inc     r14
            mov     al, byte [r12 + r14]
            cmp     al, 0x0
            jne     split_LenLoop
            inc     r15
            lea     rdi, [r15 * 0x4]                    ; sizeof(int)
            call    malloc
            mov     rcx, rax
            mov     r14, 0x0
            mov     r15, 0x0
            mov     r10, 0x0
            movzx   r11, byte [r12 + r14]
split_SplitLoop:
            mov     rax, 0xa
            mul     r10
            cmp     r11, r13
            cmovne  r10, rax
            lea     rdx, [r11 - 0x30]                   ; ASCII->num
            lea     rdx, [r10 + rdx]
            cmovne  r10, rdx
            mov     dword [rcx + r15*0x4], r10d
            mov     r11, 0x0
            cmove   r10, r11
            lea     rdx, [r15 + 0x1]
            cmove   r15, rdx
            inc     r14
            movzx   r11, byte [r12 + r14]
            cmp     r11, 0x0
            jne     split_SplitLoop
            pop     rdx
            inc     r15
            mov     dword [rdx], r15d
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            mov     rax, rcx
            ret

; ------------------------------------------------------------------------------
; -- void rsort(int *ord, int *arr, int ordSz, int arrSz);
; ------------------------------------------------------------------------------
rsort:
            push    rbx
            mov     r8, 0x0
            mov     r10, 0x0
rsort_OuterLoop:
            mov     r9, r10
rsort_InnerLoop:
            mov     eax, dword [rsi + r9*0x4]
            cmp     eax, dword [rdi + r8*0x4]
            mov     r11d, dword [rsi + r10*0x4]
            mov     ebx, eax
            cmove   eax, r11d
            cmove   r11d, ebx
            mov     dword [rsi + r9*0x4], eax
            mov     dword [rsi + r10*0x4], r11d
            lea     rax, [r10 + 0x1]
            cmove   r10, rax
            inc     r9
            cmp     r9, rcx
            jl      rsort_InnerLoop
            inc     r8
            cmp     r8, rdx
            jl      rsort_OuterLoop
            lea     rdi, [rsi + r10*0x4]
            mov     rsi, 0x0
            sub     rcx, r10
            lea     rdx, [rcx - 0x1]
            call    qsort
            pop     rbx
            ret

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
            call    qsort
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
            lea     rax, [r8 + 0x1]
            cmovl   r8, rax
            inc     r9
            cmp     r9, rdx
            jl      partition_Loop
            mov     r10d, dword [rdi + r8*0x4]
            mov     r11d, dword [rdi + rdx*0x4]
            mov     dword [rdi + r8*0x4], r11d
            mov     dword [rdi + rdx*0x4], r10d
            mov     rax, r8
            ret

            section .data

outFmt      db      "%d,", 0x0
outFmtEnd   db      "%d", 0x0
newline     db      0xa, 0x0