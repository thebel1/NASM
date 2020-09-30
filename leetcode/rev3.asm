; ######################################################
; Reverse Words in a String III
;
; https://leetcode.com/problems/reverse-words-in-a-string-iii/
; ######################################################
; The real deal.

            default rel
            global  main
            extern  printf

main:
            push    r12
            push    r13
            push    r14
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, 0x1
main_OuterLoop:
            mov     rcx, qword [r13 + r14*0x8]
            mov     rdx, 0x0
            mov     r8, 0x0
main_LenLoop:
            mov     al, byte [rcx + rdx]
            inc     rdx
            lea     r9, [rdx - 0x2]
            cmp     al, 0x20
            je      main_RevLoop
            mov     r9, rdx
            mov     r11b, byte [rcx + rdx + 0x1]
            cmp     r11b, 0x0                           ; Next char == 0x0?
            je      main_RevLoop
            cmp     al, 0x0
            jne     main_LenLoop
            mov     rdi, outFmt
            mov     rsi, rcx
            call    printf
            inc     r14
            cmp     r14, r12
            jb      main_OuterLoop
main_Leave:
            pop     r14
            pop     r13
            pop     r12
            xor     rax, rax
            ret
main_RevLoop:
            ; Enter main_RevLoop at the end of each word
            mov     r10b, byte [rcx + r8]
            mov     r11b, byte [rcx + r9]
            mov     byte [rcx + r8], r11b
            mov     byte [rcx + r9], r10b
            inc     r8
            dec     r9
            cmp     r8, r9
            jb      main_RevLoop
            mov     r8, rdx
            jmp     main_LenLoop

            section .data

outFmt      db      "%s", 0xa, 0x0