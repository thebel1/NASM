            default rel
            global  main
            extern  malloc
            extern  free
            extern  printf

            section .data

trueMsg     db      "True", 0xa, 0x0
falseMsg    db      "False", 0xa, 0x0

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
            cmp     rdi, 0x2
            jl      main_Leave
            mov     r12, rsi
            mov     rdi, qword [r12 + 0x8]
            lea     rsi, [rsp + 0x4]
            lea     rdx, [rsp]
            call    getMatrixFromString
            mov     r12, rax
            mov     r13d, dword [rsp + 0x4]
            mov     r14d, dword [rsp]
            mov     rdi, r12
            mov     esi, r13d
            mov     edx, r14d
            call    isToeplitz
main_Leave:
            ud2
            add     rsp, 0x8
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- int *getMatrixFromString(char *str, int *cols, int *rows);
; ------------------------------------------------------------------------------
getMatrixFromString:
            push    r12
            push    r13
            push    r14
            push    r15
            push    rbx
            push    rbp
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx
            mov     r15, 0x0
            mov     rbx, 0x0                            ; cols
            mov     rbp, 0x0                            ; rows
            mov     al, byte [r12]
            mov     r8, 0x0                             ; # digits
            mov     r9, 0x0                             ; Was last char a digit?
getMatrixFromString_CheckLoop:
            cmp     al, 0x2c                            ; ASCII ','
            lea     r10, [rbx + 0x1]
            cmove   rbx, r10
            mov     r10, 0x0
            cmove   r9, r10
            je      getMatrixFromString_CheckLoopEnd
            cmp     al, 0x3b                            ; ASCII ';'
            lea     r10, [rbp + 0x1]
            mov     r11, 0x0
            cmove   rbp, r10
            cmove   rbx, r11
            mov     r10, 0x0
            cmove   r9, r10
            je      getMatrixFromString_CheckLoopEnd
            cmp     r9, 0x0
            lea     r10, [r8 + 0x1]
            cmove   r8, r10
            mov     r9, 0x1
getMatrixFromString_CheckLoopEnd:
            inc     r15
            mov     al, byte [r12 + r15]
            cmp     al, 0x0
            jne     getMatrixFromString_CheckLoop
            inc     rbx
            inc     rbp
            mov     rax, rbp
            mul     rbx
            cmp     r8, rax
            jne     getMatrixFromString_Error
            mov     dword [r13], ebx                    ; Store cols
            mov     dword [r14], ebp                    ; Store rows
            lea     rdi, [r8 * 0x4]
            call    malloc
            test    rax, rax
            je      getMatrixFromString_Error
            mov     rbx, rax                            ; Matrix array
            mov     al, byte [r12]
            mov     r15, 0x0                            ; i
            mov     rbp, 0x0                            ; j
            mov     r9, 0x0                             ; k
getMatrixFromString_MatrixLoop:
            mov     r8, 0x0                             ; cur num
getMatrixFromString_AtoiLoop:
            ; TODO: Add support for negative numbers. Problem: I'm out of registers!!
            mov     r10, 0x1
            mov     r11, 0x0
            cmp     al, 0x2c                            ; ASCII ','
            cmove   r11, r10
            cmp     al, 0x3b                            ; ASCII ';'
            cmove   r11, r10
            cmp     r11, 0x1
            je      getMatrixFromString_MatrixLoopEnd
            movzx   r11, al
            mov     rax, r8
            mov     r10, 0xa
            mul     r10
            mov     r8, rax
            lea     r8, [r8 + r11 - 0x30]
            mov     dword [rbx + rbp*0x4], r8d
            mov     rax, r11
            inc     r15
            mov     al, byte [r12 + r15]
            cmp     al, 0x0
            je      getMatrixFromString_Leave
            jmp     getMatrixFromString_AtoiLoop
getMatrixFromString_MatrixLoopEnd:
            inc     rbp
            inc     r15
            mov     al, byte [r12 + r15]
            cmp     al, 0x0
            jne     getMatrixFromString_MatrixLoop
getMatrixFromString_Leave:
            mov     rax, rbx
            add     rsp, 0x8
            pop     rbp
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret
getMatrixFromString_Error:
            xor     rax, rax
            add     rsp, 0x8
            pop     rbp
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12            
            ret

; ------------------------------------------------------------------------------
; -- bool isToeplitz(int *matrix, int cols, int rows);
; ------------------------------------------------------------------------------
isToeplitz:
            sub     rsp, 0x8
            mov     eax, esi
            xor     rsi, rsi
            mov     esi, eax
            xor     r8, r8
            mov     r8d, edx                            ; rows (b/c rdx gets swallowed by mul)
            xor     rax, rax
            mov     eax, esi
            mul     rdx
            mov     r9, rax                             ; Matrix size
            mov     r10, 0x0                            ; i
            mov     r11, 0x0                            ; j
isToeplitz_OuterLoop:
isToeplitz_InnerLoop:
            ud2
            ;lea     r11, [r11 + rsi*]
            cmp     r11, r9
            jl      isToeplitz_InnerLoop
            inc     r10
            cmp     r10, r9
            jl      isToeplitz_OuterLoop
            ud2
            add     rsp, 0x8
            ret