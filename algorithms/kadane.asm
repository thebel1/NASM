; ######################################################
; Maximum subarray problem
;
; https://en.wikipedia.org/wiki/Maximum_subarray_problem#Kadane's_algorithm
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
            cmp     r12, 0x3
            jle     main_Leave
            lea     rdi, [(r12 - 0x1) * 0x4]
            call    malloc
            mov     rbx, rax
            mov     r14, 0x1
main_Loop:
            mov     rdi, qword [r13 + r14*0x8]
            call    atoi
            mov     dword [rbx + (r14 - 0x1)*0x4], eax
            inc     r14
            cmp     r14, r12
            jl      main_Loop
            mov     rdi, rbx
            lea     rsi, [r12 - 0x1]
            call    kadane
            mov     rdi, outFmt
            mov     rsi, rax
            call    printf
            mov     rdi, rbx
            call    free
main_Leave:
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- int kadane(int *arr, int arrSz);
; ------------------------------------------------------------------------------
kadane:
            mov     rdx, 0x0                            ; int bestSum
            mov     rcx, 0x0                            ; int currSum
            mov     r8, 0x0                             ; int i
            xor     r9, r9                              ; int x
kadane_Loop:
            mov     r9d, dword [rdi + r8*0x4]
            lea     rax, [rcx + r9]
            mov     r10, 0x0
            test    eax, eax                            ; 32 bit op used b/c typeof(arr) = int*
            cmovns  rcx, rax
            cmovs   rcx, r10
            cmp     edx, ecx
            cmovb   rdx, rcx
            inc     r8
            cmp     r8, rsi
            jl      kadane_Loop
            mov     rax, rdx
            ret

; ------------------------------------------------------------------------------
; -- int atoi(char *str);
; ------------------------------------------------------------------------------
atoi:
            mov     rsi, 0x0
            mov     rdx, 0x0
            mov     rcx, 0x1
            movzx   rax, byte [rdi]
atoi_Loop:
            cmp     rax, 0x2d                           ; ASCII '-'
            mov     r10, -0x1
            cmove   rcx, r10
            mov     r10, rax
            mov     rax, rdx
            mov     r11, 0xa
            mul     r11
            cmp     r10, 0x2d
            cmovne  rdx, rax
            lea     rax, [r10 + rdx - 0x30]             ; ASCII->num + prev*10
            cmovne  rdx, rax
            inc     rsi
            movzx   rax, byte [rdi + rsi]
            cmp     rax, 0x0
            jne     atoi_Loop
            mov     eax, edx
            mul     ecx
            ret

            section .data

outFmt      db      "%d", 0xa, 0x0