; ######################################################
; Find and replace pattern
;
; https://leetcode.com/problems/find-and-replace-pattern/
; ######################################################

            global  main
            extern  malloc
            extern  free
            extern  printf

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
; ------------------------------------------------------------------------------
main:
            push    r12                                 ; argc
            push    r13                                 ; argv
            push    r14                                 ; char *dupe
            push    r15                                 ; int i
            push    rbx                                 ; int j
            mov     r12, rdi
            mov     r13, rsi
            cmp     r12, 0x1
            je      main_Leave
            lea     rdi, [(r12 - 0x2) * 0x4]
            mov     rdi, qword [r13 + 0x8]
            call    getPerm
            mov     r15, 0x2
            dec     r12
            mov     rbx, 0x0
main_Loop:
            mov     rdi, qword [r13 + r15*0x8]
            call    strdup
            mov     r14, rax
            mov     rdi, r14
            call    getPerm
            mov     rdi, r14
            mov     rsi, qword [r13 + 0x8]
            call    streq
            test    rax, rax
            jne     main_Print
main_LoopReenter:
            mov     rdi, r14
            call    free
            inc     r15
            cmp     r15, r12
            jle     main_Loop
            mov     rdi, outNewLine
            call    printf
main_Leave:
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            xor     rax, rax
            ret
main_Print:
            mov     rdi, outFmt
            mov     rsi, qword [r13 + r15*0x8]
            call    printf
            jmp     main_LoopReenter

; ------------------------------------------------------------------------------
; -- void getPerm(char *str);
; ------------------------------------------------------------------------------
getPerm:
            push    rdi
            call    strdup
            mov     rdx, rax                            ; char *dupe
            pop     rdi
            mov     r8, 0x0                             ; int i
            mov     r9, 0x0                             ; int j
            mov     r10b, byte [rdi + r8]               ; char prev
            cmp     r10b, 0x0
            je      getPerm_Leave
            mov     byte [rdi + r8], 0x30               ; ASCII '0'
            inc     r8
getPerm_PermLoop:
            mov     r11b, byte [rdi + r8]               ; char curr
            mov     rsi, 0x0                            ; int k
getPerm_MapLoop:
            mov     cl, byte [rdx  + rsi]
            cmp     r11b, cl
            mov     al, byte [rdi + rsi]
            cmove   r9, rsi
            je      getPerm_Skip
            inc     rsi
            cmp     byte [rdx + rsi], 0x0
            jne     getPerm_MapLoop
            cmp     r11b, r10b
            lea     rax, [r9 + 0x1]
            cmovne  r9, rax
getPerm_Skip:
            lea     rax, [r9 + 0x30]
            mov     byte [rdi + r8], al
            mov     r10b, r11b
            inc     r8
            cmp     byte [rdi + r8], 0x0                ; Loop until NULL
            jne     getPerm_PermLoop
getPerm_Leave:
            mov     rdi, rdx
            call    free
            ret

; ------------------------------------------------------------------------------
; -- bool streq(char *str1, char *str2);
; ------------------------------------------------------------------------------
streq:
            mov     r8, 0x0                             ; int i
streq_Loop:
            mov     r9b, byte [rdi + r8]                ; str1[i]
            mov     r10b, byte [rsi + r8]               ; str2[i]
            cmp     r9b, r10b
            jne     streq_RetFalse
            movzx   rax, r9b
            mul     r10b
            inc     r8
            test    rax, rax
            jne     streq_Loop
            mov     rax, 0x1
            ret
streq_RetFalse:
            xor     rax, rax
            ret

; ------------------------------------------------------------------------------
; -- char *strdup(char *str);
; ------------------------------------------------------------------------------
strdup:
            mov     rsi, 0x0
strdup_LenLoop:
            inc     rsi
            mov     al, byte [rdi + rsi]
            test    al, al
            jne     strdup_LenLoop
            push    rdi
            push    rsi
            mov     rdi, rsi
            call    malloc
            mov     rdx, rax
            pop     rsi
            pop     rdi
            dec     rsi
            lea     rcx, [rdi + rsi]
            mov     r8, 0x0
strdup_DupLoop:
            mov     al, byte [rdi]
            mov     byte [rdx + r8], al
            inc     r8
            inc     rdi
            cmp     rdi, rcx
            jle     strdup_DupLoop
            mov     byte [rdx + r8], 0x0
            mov     rax, rdx
            ret

            section .data

outFmt      db      "%s", 0x20, 0x0
outNewLine  db      0xa, 0x0