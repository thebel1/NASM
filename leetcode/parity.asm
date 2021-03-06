; ######################################################
; Sort Array By Parity II
;
; https://leetcode.com/problems/sort-array-by-parity-ii/
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
            push    rbx
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, 0x1
            cmp     r12, 0x2
            jle     main_Leave
            lea     rdi, [(r12 - 0x1) * 0x4]
            call    malloc
            mov     rbx, rax
main_SortLoop:
            mov     r15, r14
            mov     rdi, qword [r13 + r14*0x8] 
            call    atoi
            mov     dword [rbx + r15*0x4 - 0x4], eax
            inc     r14
            cmp     r14, r12
            jl      main_SortLoop
            mov     rdi, rbx
            lea     rsi, [r15 - 0x1]
            call    psort
            mov     r15, 0x0
            dec     r14
main_PrintLoop:
            mov     rdi, outFmt
            mov     esi, dword [rbx + r15*0x4]
            call    printf
            inc     r15
            cmp     r15, r14
            jl      main_PrintLoop
            mov     rdi, newline
            call    printf
            mov     rdi, rbx
            call    free
main_Leave:
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            xor     rax, rax
            ret

; ------------------------------------------------------------------------------
; -- void psort(int *arr, int arrSz);
; ------------------------------------------------------------------------------
psort:
            push    r12
            mov     r12, 0x0
psort_OuterLoop:
            mov     ecx, r12d
            mov     eax, dword [rdi + r12*0x4]
            mov     r8d, 0x2
            xor     rdx, rdx
            div     r8d                                 ; eax % 2
            mov     r8d, edx
            mov     eax, ecx
            mov     r9d, 0x2
            xor     rdx, rdx
            div     r9d
            mov     r9d, edx
            cmp     r8d, r9d
            je      psort_Continue
psort_InnerLoop:
            mov     r10d, dword [rdi + r12*0x4]
            mov     r11d, dword [rdi + rcx*0x4]
            mov     eax, r10d
            mov     r8d, 0x2
            xor     rdx, rdx
            div     r8d
            mov     r8d, edx
            mov     eax, r11d
            mov     r9d, 0x2
            xor     rdx, rdx
            div     r9d
            mov     r9d, edx
            cmp     r8d, r9d
            cmove   r8d, r10d
            cmove   r9d, r11d
            cmovne  r8d, r11d
            cmovne  r9d, r10d
            mov     dword [rdi + r12*0x4], r8d
            mov     dword [rdi + rcx*0x4], r9d
            jne     psort_Continue
            inc     rcx
            cmp     rcx, rsi
            jl      psort_InnerLoop
psort_Continue:
            inc     r12
            cmp     r12, rsi
            jl      psort_OuterLoop
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- int atoi(char *str);
; ------------------------------------------------------------------------------
atoi:
            mov     rsi, 0x0
            mov     edx, 0x0
            movzx   ecx, byte [rdi]
atoi_Loop:
            cmp     rsi, 0x0
            lea     r10d, [ecx - 0x30]                  ; ASCII->num
            mov     eax, 0xa
            mul     edx                                 ; Move one digit to the left
            add     r10d, eax
            cmovne  edx, r10d
            inc     rsi
            movzx   rcx, byte [rdi + rsi]
            cmp     ecx, 0x0
            jne     atoi_Loop
            mov     eax, edx
            ret

            section .data

outFmt      db      "%d ", 0x0
newline     db      0xa, 0x0