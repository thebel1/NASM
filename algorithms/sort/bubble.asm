; ######################################################
; Bubble sort
;
; Implementation as per https://en.wikipedia.org/wiki/Bubble_sort
; ######################################################

            global  main
            extern  malloc
            extern  free
            extern  atoi
            extern  printf

            section .text

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
;
; TODO: add some maximum input array length.
; ------------------------------------------------------------------------------
main:
            push    r12                                 ; argc
            push    r13                                 ; argv
            push    r14                                 ; int *arr
            push    r15                                 ; int i
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            cmp     r12, 0x1
            je      main_Leave
            mov     rax, r12
            dec     rax
            mov     r10, 0x4                            ; sizeof(int)
            mul     r10
            mov     rdi, rax
            call    malloc                              ; Allocate arr
            test    rax, rax
            je      main_Panic
            mov     r14, rax
            dec     r12
            mov     r15, 0x0
main_SortLoop:
            mov     rdi, qword [r13 + r15*0x8 + 0x8]    ; argv[i+1]
            call    atoi
            mov     dword [r14 + r15*0x4], eax          ; arr[i]
            inc     r15
            cmp     r15, r12
            jb      main_SortLoop
            mov     rdi, r14
            mov     rsi, r15
            call    bubble
            mov     r15, 0x0
main_PrintLoop:
            mov     rdi, outFmt
            mov     esi, dword [r14 + r15*0x4]
            call    printf
            inc     r15
            cmp     r15, r12
            jb      main_PrintLoop
            mov     rdi, outNewLine
            call    printf
main_Leave:
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            add     rsp, 0x8
            xor     rax, rax
            ret
main_Panic:
            mov     rdi, mainErr
            call    printf
            ud2                                         ; So a core can be gathered

; ------------------------------------------------------------------------------
; -- void bubble(int *arr, int size);
;
; ------------------------------------------------------------------------------
bubble:
            push    r12                                 ; arr
            push    r13                                 ; size
            push    r14                                 ; n
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, r13
bubble_LoopOuter:
            mov     rcx, 0x0                            ; newn
            mov     rdx, 0x1                            ; i
bubble_LoopInner:
            mov     r10d, dword [r12 + rdx*0x4 - 0x4]    ; arr[i-1]
            mov     r11d, dword [r12 + rdx*0x4]          ; arr[i]
            cmp     r10, r11
            cmova   rax, r10
            cmova   r10, r11
            cmova   r11, rax
            cmova   rcx, rdx
            mov     dword [r12 + rdx*0x4 - 0x4], r10d
            mov     dword [r12 + rdx*0x4], r11d
            inc     rdx
            cmp     rdx, r14
            jb      bubble_LoopInner
            mov     r14, rcx
            cmp     r14, 0x1
            ja      bubble_LoopOuter
            pop     r14
            pop     r13
            pop     r12
            ret

            section .data

outFmt      db      "%d", 0x20, 0x0
outNewLine  db      0xa, 0x0
mainErr     db      "Something went wrong.", 0xa, 0x0