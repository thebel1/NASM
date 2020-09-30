; ######################################################
; Find Words That Can Be Formed by Characters
;
; https://leetcode.com/problems/find-and-replace-pattern/
; ######################################################

            global  main
            extern  malloc
            extern  free
            extern  printf

            section .text

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
; ------------------------------------------------------------------------------
main:
            push    r12                                 ; argc
            push    r13                                 ; argv
            push    r14                                 ; int i
            push    r15                                 ; int out
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, 0x2
            mov     r15, 0x0
main_Loop:
            mov     rdi, qword [r13 + 0x8]              ; argv[1]
            mov     rsi, qword [r13 + r14*0x8]
            call    isGood
            test    rax, rax
            jne     main_AddLen
main_LoopReenter:
            inc     r14
            cmp     r14, r12
            jb      main_Loop
            test    r15, r15
            je      main_SkipNewLine
            mov     rdi, newline
            call    printf
main_SkipNewLine:
            mov     rdi, numFmt
            mov     rsi, r15
            call printf
main_Leave:
            add     rsp, 0x8
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            xor     rax, rax
            ret
main_AddLen:
            mov     rdi, strFmt
            mov     rsi, qword [r13 + r14*0x8]
            call    printf
            mov     rdi, qword [r13 + r14*0x8]
            call    strlen
            add     r15, rax
            jmp     main_LoopReenter

; ------------------------------------------------------------------------------
; -- bool isGood(char *chars, char *str);
; ------------------------------------------------------------------------------
isGood:
            push    r12                                 ; char *dupe
            push    rdi
            push    rsi
            call    strdup
            mov     r12, rax
            pop     rsi
            pop     rdi
            mov     rdx, 0x0                            ; int i
isGood_OuterLoop:
            mov     rcx, 0x0                            ; int j
isGood_InnerLoop:
            mov     al, byte [r12 + rcx]
            cmp     al, byte [rsi + rdx]
            mov     r10b, al
            mov     r11, 0x1
            cmove   rax, r11
            mov     byte [r12 + rcx], al
            je      isGood_Skip
            inc     rcx
            cmp     byte [r12 + rcx], 0x0
            jne     isGood_InnerLoop
            cmp     rax, r11
            jne     isGood_LeaveFalse
isGood_Skip:
            inc     rdx
            cmp     byte [rsi + rdx], 0x0
            jne     isGood_OuterLoop
            mov     rdi, r12
            call    free
            pop     r12
            mov     rax, 0x1
            ret
isGood_LeaveFalse:
            mov     rdi, r12
            call    free
            pop     r12
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

; ------------------------------------------------------------------------------
; -- int strlen(char *str);
; ------------------------------------------------------------------------------
strlen:
            mov     rax, 0x0
strlen_Loop:
            inc     rax
            cmp     byte [rdi + rax], 0x0
            jne     strlen_Loop
            ret

            section .data

strFmt      db      "%s ", 0x0
newline     db      0xa, 0x0
numFmt      db      "%d", 0xa, 0x0