; ######################################################
; Towers of Hanoi (recursive)
;
; https://en.wikipedia.org/wiki/Tower_of_Hanoi#Recursive_implementation
; ######################################################

            default rel
            global  main
            extern  printf

struc       Towers
            .A      resd    3
            .lenA   resd    1
            .B      resd    3
            .lenB   resd    1
            .C      resd    3
            .lenC   resd    1
endstruc

            section .data

pfxFmt      db "%d: ", 0x0
elemFmt     db "%d ", 0x0
newline     db 0xa, 0x0

towers:
istruc      Towers
            at Towers.A,    dd 0x3, 0x2, 0x1
            at Towers.lenA, dd 0x3
            at Towers.B,    dd 0x0, 0x0, 0x0
            at Towers.lenB, dd 0x0
            at Towers.C,    dd 0x0, 0x0, 0x0
            at Towers.lenC, dd 0x0
iend

HANOI_SZ    equ     0x3

            section .text

; ------------------------------------------------------------------------------
; -- int main();
; ------------------------------------------------------------------------------
main:
            sub     rsp, 0x8
            mov     edi, HANOI_SZ
            lea     rsi, [towers + Towers.A]
            lea     rdx, [towers + Towers.C]
            lea     rcx, [towers + Towers.B]
            call    move
            add     rsp, 0x8
            ret

; ------------------------------------------------------------------------------
; -- void move(int n, int *source, int *target, int *aux);
; ------------------------------------------------------------------------------
move:
            push    r12
            push    r13
            push    r14
            push    r15
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx
            mov     r15, rcx
            cmp     r12, 0x0
            jle     move_Leave
            lea     rdi, [r12 - 0x1]
            mov     rsi, r13
            mov     rdx, r15
            mov     rcx, r14
            call    move
            xor     r10, r10
            xor     r11, r11
            mov     r10d, dword [r13 + HANOI_SZ*0x4]
            mov     r11d, dword [r14 + HANOI_SZ*0x4]
            mov     eax, dword [r13 + (r10 - 0x1)*0x4]
            mov     edx, dword [r14 + (r11 + 0x1)*0x4]
            mov     dword [r13 + (r10 - 0x1)*0x4], 0x0
            mov     dword [r14 + r11*0x4], eax
            dec     dword [r13 + HANOI_SZ*0x4]
            inc     dword [r14 + HANOI_SZ*0x4]
            call    printTowers
            lea     rdi, [r12 - 0x1]
            mov     rsi, r15
            mov     rdx, r14
            mov     rcx, r13
            call    move
move_Leave:
            add     rsp, 0x8
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- void printTowers(void);
; ------------------------------------------------------------------------------
printTowers:
            push    rbx
            push    rbp
            sub     rsp, 0x8
            mov     rbx, 0x0
printTowers_OuterLoop:
            mov     rdi, pfxFmt
            mov     esi, ebx
            call    printf
            mov     rbp, 0x0
printTowers_InnerLoop:
            mov     rdx, towers
            lea     rdx, [rdx + rbx*0x8]
            lea     rdx, [rdx + rbx*0x8]
            mov     r10d, dword [rdx + rbp*0x4]
            mov     rdi, elemFmt
            mov     esi, r10d
            call    printf
            mov     rdx, towers
            lea     rdx, [rdx + rbx*0x8]
            lea     rdx, [rdx + rbx*0x8]
            mov     r11d, dword [rdx + HANOI_SZ*0x4]
            inc     ebp
            cmp     ebp, r11d
            jl      printTowers_InnerLoop
            mov     rdi, newline
            call    printf
            inc     rbx
            cmp     rbx, HANOI_SZ
            jl      printTowers_OuterLoop
            mov     rdi, newline
            call    printf
            add     rsp, 0x8
            pop     rbp
            pop     rbx
            ret
