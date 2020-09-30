            global  main
            extern  malloc
            extern  free
            extern  printf

            section .text

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
;
; TODO: add some maximum input string length.
; ------------------------------------------------------------------------------
main:
            sub     rsp, 0x8
            cmp     rdi, 0x1
            je      main_Leave
            mov     r12, rsi            ; argv
            mov     r13, 0x1            ; argv[i]
            mov     r14, 0x0            ; argv[i][j]
            mov     r15, rdi            ; Length of argv[]
            mov     rbp, 0x0            ; Destination string
            mov     rbx, 0x0            ; Length of destination string (incl. NULL)
main_Loop:
            mov     rdx, qword [r12 + r13*0x8]
            push    rdx
            mov     rdi, rdx
            call    strlen
            pop     rdx
            cmp     r13, 0x1
            je      main_FirstAlloc
            add     rax, 0x1
            push    rax
            add     rax, rbx
            inc     rax                 ; Add room for space char
            push    rdx
            mov     rdi, rax
            call    malloc              ; Malloc new string
            test    rax, rax
            je      main_Panic
            push    rax
            mov     rdi, rax
            mov     rsi, 0x0
            mov     rdx, rbx
            call    memset              ; Zero out new string
            pop     rax
            pop     rdx
            push    rdx
            push    rax
            mov     rdi, rax
            mov     rsi, rbp
            mov     rdx, rbx
            call    strncpy             ; Copy old string
            pop     rax
            mov     rdi, rbp
            mov     rbp, rax
            call    free                ; Free old string
            pop     rdx
            mov     byte [rbp + rbx - 1], 0x20  ; Add space char
            pop     rax
            add     rbx, rax
            mov     rdi, rbp
            mov     rsi, rdx
            mov     rdx, rax
            call    strncat             ; Concatenate new string
main_LoopReenter:
            inc     r13
            cmp     r13, r15
            jne     main_Loop
            mov     rdi, rbp
            call    rev
            mov     rdi, outFormat
            mov     rsi, rbp
            call    printf              ; Print reversed string
            mov     rdi, rbp
            call    free                ; Free reversed string
main_Leave:
            add     rsp, 0x8
            xor     rax, rax
            ret
main_FirstAlloc:
            add     rax, 0x1            ; Add NULL byte
            mov     rbx, rax
            push    rdx
            mov     rdi, rbx
            call    malloc
            test    rax, rax
            je      main_Panic
            mov     rbp, rax
            mov     rdi, rbp
            mov     rsi, 0x0
            mov     rdx, rbx
            call    memset
            pop     rdx
            push    rdx
            mov     rdi, rbp
            mov     rsi, rdx
            mov     rdx, rbx
            call    strncpy
            pop     rdx
            jmp     main_LoopReenter
main_Panic:
            mov     rdi, panicMsg
            call    printf
            mov     rax, 0x3c           ; exit syscall
            mov     rdi, 0x0
            syscall
            ud2

; ------------------------------------------------------------------------------
; -- void rev(char *str);
;
; Reverses a string in-place.
; ------------------------------------------------------------------------------
rev:
            push    r12
            push    r13
            mov     r12, rdi            ; str
            call    strlen
            mov     r13, rax            ; str length
            mov     rdi, r12
            lea     rsi, [rdi + r13 - 1]
rev_Loop:
            mov     al, byte [rdi]
            mov     r10b, byte[rsi]
            mov     byte [rsi], al
            mov     byte [rdi], r10b
            inc     rdi
            dec     rsi
            cmp     rsi, rdi
            ja      rev_Loop
            xor     rax, rax
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- int strlen(char *str);
;
; Calculates string length, excluding NULL byte.
; ------------------------------------------------------------------------------
strlen:
            push    r12
            push    r13
            mov     r12, rdi
            mov     r13, 0x0            ; length
strlen_Loop:
            inc     r13
            inc     r12
            cmp     byte [r12], 0x0     ; NULL byte termination
            jne     strlen_Loop
            mov     rax, r13
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- void strncpy(char *str, int c, int n);
;
; Copies char c into str n times
; ------------------------------------------------------------------------------
memset:
            mov     rcx, rdx
            mov     rax, rsi
            cld
            rep stosb
            ret

; ------------------------------------------------------------------------------
; -- void strncpy(char *dst, char *src, int size);
;
; Copy string.
; ------------------------------------------------------------------------------
strncpy:
            mov     rcx, rdx
strncpy_Loop:
            mov     rax, [rsi]
            stosb
            inc     rsi
            dec     rcx
            test    rcx, rcx
            jne     strncpy_Loop
            ret

; ------------------------------------------------------------------------------
; -- void strncat(char *dst, char *src, int n);
;
; Concatentate strings.
; ------------------------------------------------------------------------------
strncat:
            push    r12
            push    r13
            push    r14
            mov     r12, rdi            ; dst
            mov     r13, rsi            ; src
            mov     r14, rdx            ; n
            call    strlen
            mov     rdi, r12
            add     rdi, rax
            mov     rsi, r13
            mov     rdx, r14
            call    strncpy
            pop     r14
            pop     r13
            pop     r12
            ret

            section .data

outFormat   db      "%s", 0xa, 0x0
panicMsg    db      "Something went wrong.", 0xa, 0x0