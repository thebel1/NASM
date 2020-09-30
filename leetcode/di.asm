; ######################################################
; DI String Match
;
; https://leetcode.com/problems/di-string-match/
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
            mov     r15, 0x0
            mov     rdx, qword [r13 + 0x8]
            movzx   rax, byte [rdx]
main_LenLoop:
            inc     r15
            movzx   rax, byte [rdx + r15]
            cmp     rax, 0x0
            jne     main_LenLoop
            mov     r14, 0x0                            ; vmin
            mov     rbx, r15                            ; vmax
            mov     r15, 0x0
main_PrintLoop:
            mov     rax, qword [r13 + 0x8]
            movzx   rax, byte [rax + r15]
            cmp     rax, 0x49                           ; ASCI 'I'
            mov     rdi, outFmt
            cmove   rsi, r14
            cmovne  rsi, rbx
            call    printf
            mov     rax, qword [r13 + 0x8]
            movzx   rax, byte [rax + r15]
            cmp     rax, 0x49                           ; ASCI 'I'
            lea     rax, [r14 + 0x1]
            cmove   r14, rax
            lea     rax, [rbx - 0x1]
            cmovne  rbx, rax
            inc     r15
            mov     rax, qword [r13 + 0x8]
            movzx   rax, byte [rax + r15 - 0x1]
            cmp     rax, 0x0
            jne     main_PrintLoop
            mov     rdi, newline
            call    printf
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

            section .data

outFmt      db      "%d ", 0x0
newline     db      0xa, 0x0