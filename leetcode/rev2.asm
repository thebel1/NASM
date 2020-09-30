; ######################################################
; Reverse Words in a String III
;
; https://leetcode.com/problems/reverse-words-in-a-string-iii/
; ######################################################
; This one relies on libc's main caller to split the args for us.

            global  main
            extern  printf

            section .text

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
; ------------------------------------------------------------------------------
main:
            push    r12
            push    r13
            push    r14
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, 0x1
main_OuterLoop:
            mov     rcx, qword [r13 + r14*0x8]
            mov     r8, 0x0
main_LenLoop:
            mov     al, byte [rcx + r8]
            inc     r8
            cmp     al, 0x0
            jne     main_LenLoop
            sub     r8, 0x2
            mov     r9, r8
            mov     r8, 0x0
main_RevLoop:
            mov     r10b, byte [rcx + r8]
            mov     r11b, byte [rcx + r9]
            mov     byte [rcx + r8], r11b
            mov     byte [rcx + r9], r10b
            inc     r8
            dec     r9
            cmp     r8, r9
            jb      main_RevLoop
            mov     rdi, outFmt
            mov     rsi, rcx
            call    printf
            inc     r14
            cmp     r14, r12
            jne     main_OuterLoop
            mov     rdi, newline
            call    printf
            pop     r14
            pop     r13
            pop     r12
            ret

            section .data

outFmt      db      "%s ", 0x0
newline     db      0xa, 0x0