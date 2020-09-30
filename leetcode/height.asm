; ######################################################
; Height Checker
;
; https://leetcode.com/problems/height-checker/
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
            lea     rdi, [(r12 - 0x1) * 0x4]
            call    malloc
            mov     r14, rax
            mov     r15, 0x1
main_ArrLoop:
            mov     rdi, qword [r13 + r15*0x8]
            call    atoi
            mov     dword [r14 + (r15 - 0x1)*0x4], eax
            inc     r15
            cmp     r15, r12
            jl      main_ArrLoop
            mov     rdi, r14
            lea     rsi, [r12 - 0x1]
            call    swaps
            mov     rdi, outFmt
            mov     rsi, rax
            call    printf
            add     rsp, 0x8
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- int atoi(char *str);
; ------------------------------------------------------------------------------
atoi:
            mov     rsi, 0x0                            ; Counter
            mov     rcx, 0x1                            ; Sign
            mov     r8, 0x0                             ; Sum
            movzx   r9, byte [rdi]
            cmp     r9, 0x2d                            ; ASCII '-'
            mov     r10, -0x1
            cmove   rcx, r10
            lea     r10, [rsi + 0x1]
            cmove   rsi, r10
            movzx   r9, byte [rdi + rsi]
atoi_Loop:
            mov     r10, 0xa
            mov     rax, r8
            mul     r10
            lea     r8, [rax + r9 - 0x30]
            inc     rsi
            movzx   r9, byte [rdi + rsi]
            cmp     r9, 0x0
            jne     atoi_Loop
            mov     eax, r8d
            mul     ecx
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
; -- int partition(int *arr, int lo, int hi);
; ------------------------------------------------------------------------------
partition:
            mov     rcx, rdx
            mov     r8d, dword [rdi + rcx*0x4]          ; pivot
            mov     r9, rsi                             ; i
partition_Loop:
            mov     r10d, dword [rdi + rsi*0x4]         ; arr[j]
            mov     r11d, dword [rdi + r9*0x4]          ; arr[i]
            cmp     r10d, r8d
            cmovl   eax, r11d
            cmovge  eax, r10d
            mov     dword [rdi + rsi*0x4], eax
            cmovl   eax, r10d
            cmovge  eax, r11d
            mov     dword [rdi + r9*0x4], eax
            lea     rax, [r9 + 0x1]
            cmovl   r9, rax
            inc     rsi
            cmp     rsi, rcx
            jl      partition_Loop
            mov     r10d, dword [rdi + rsi*0x4]
            mov     r11d, dword [rdi + r9*0x4]
            mov     dword [rdi + r9*0x4], r10d
            mov     dword [rdi + rsi*0x4], r11d
            ret

; ------------------------------------------------------------------------------
; -- int swaps(int *arr, int arrSz);
; ------------------------------------------------------------------------------
swaps:
            push    r12
            push    r13
            push    r14
            mov     r12, rdi
            mov     r13, rsi
            mov     r10, 0x4
            mov     rax, rsi
            mul     r10
            mov     rdi, rax
            call    malloc
            mov     r14, rax
            mov     rdx, 0x0
swaps_CopyLoop:
            mov     eax, dword [r12 + rdx*0x4]
            mov     dword [r14 + rdx*0x4], eax
            inc     rdx
            cmp     rdx, r13
            jl      swaps_CopyLoop
            mov     rdi, r14
            mov     rsi, 0x0
            mov     rdx, r13
            call    qsort
            mov     rdx, 0x0
            mov     rcx, 0x0
swaps_CountLoop:
            mov     r10d, dword [r12 + rdx*0x4]
            mov     r11d, dword [r14 + rdx*0x4]
            cmp     r10d, r11d
            lea     rax, [rcx + 0x1]
            cmovne  rcx, rax
            inc     rdx
            cmp     rdx, r13
            jl      swaps_CountLoop
            pop     r14
            pop     r13
            pop     r12
            mov     rax, rcx
            ret

            section .data

outFmt      db      "%d", 0xa, 0x0
