; ######################################################
; Binary search algorithm
;
; https://en.wikipedia.org/wiki/Binary_search_algorithm#Procedure
; https://en.wikipedia.org/wiki/Quicksort#Lomuto_partition_scheme
; ######################################################

            default rel
            global  main
            extern  malloc
            extern  free
            extern  printf

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
            lea     rdi, [(r12-0x2) * 0x4]
            call    malloc
            mov     rbx, rax
            mov     r15, 0x2
main_SrchLoop:
            mov     rdi, qword [r13 + r15*0x8]
            call    atoi
            mov     dword [rbx + (r15-0x2)*0x4], eax
            inc     r15
            cmp     r15, r12
            jl      main_SrchLoop
            mov     rdi, rbx
            mov     rsi, 0x0
            lea     rdx, [r12 - 0x3]
            call    qsort
            mov     r15, 0x0
            sub     r12, 0x2
main_PrintLoop:
            mov     rdi, arrFmt
            mov     esi, r15d
            mov     edx, dword [rbx + r15*0x4]
            call    printf
            inc     r15
            cmp     r15, r12
            jl      main_PrintLoop
            mov     rdi, newline
            call    printf
            mov     rdi, qword [r13 + 0x8]
            call    atoi
            push    rax
            mov     rdi, rbx
            lea     rsi, [r12 - 0x2]
            mov     edx, eax
            call    binsrch
            mov     rdi, resFmt
            pop     rsi
            mov     edx, eax
            call    printf
main_Leave:
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- int atoi(char *str);
; ------------------------------------------------------------------------------
atoi:
            mov     rsi, 0x0
            mov     rcx, 0x1
            mov     r8, 0x0                             ; Sum
            movzx   r9, byte [rdi]
            cmp     r9, 0x2d                            ; ASCII '-'
            mov     r10, -0x1
            cmove   rcx, r10
            lea     r10, [rsi + 0x1]
            cmove   rsi, r10
            movzx   r9, byte [rdi + rsi]
atoi_Loop:
            mov     rax, r8
            mov     r10, 0xa
            mul     r10
            lea     r8, [rax + r9 - 0x30]               ; prev + curr
            inc     rsi
            movzx   r9, byte [rdi + rsi]
            cmp     r9, 0x0
            jne     atoi_Loop
            mov     rax, r8
            mul     ecx
            ret

; ------------------------------------------------------------------------------
; -- void qsort(int *arr, int lo, int hi);
; ------------------------------------------------------------------------------
qsort:
            push    r12
            push    r13
            push    r14
            push    r15
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx
            cmp     r13, r14
            jge     qsort_Leave
            call    partition
            mov     r15, rax
            mov     rdi, r12
            mov     rsi, r13
            lea     rdx, [r15 - 0x1]
            call    qsort
            mov     rdi, r12
            lea     rsi, [r15 + 0x1]
            mov     rdx, r14
            call    qsort
qsort_Leave:
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- int partition(int *arr, int lo, int hi);
; ------------------------------------------------------------------------------
partition:
            mov     ecx, dword [rdi + rdx*0x4]          ; pivot
            mov     r8, rsi                             ; j
partition_Loop:
            mov     r10d, dword [rdi + r8*0x4]          ; arr[j]
            mov     r11d, dword [rdi + rsi*0x4]         ; arr[i]
            cmp     r10d, ecx
            cmovl   eax, r11d
            cmovge  eax, r10d
            mov     dword [rdi + r8*0x4], eax
            cmovl   eax, r10d
            cmovge  eax, r11d
            mov     dword [rdi + rsi*0x4], eax
            lea     rax, [rsi + 0x1]
            cmovl   rsi, rax
            inc     r8
            cmp     r8, rdx
            jle     partition_Loop
            mov     r10d, dword [rdi + rdx*0x4]
            mov     r11d, dword [rdi + rsi*0x4]
            mov     dword [rdi + rdx*0x4], r11d
            mov     dword [rdi + rsi*0x4], r10d
            mov     eax, esi
            ret

; ------------------------------------------------------------------------------
; -- int binsrch(int *arr, int n, int T);
; ------------------------------------------------------------------------------
binsrch:
            mov     ecx, 0xffffffff80000000             ; INT_MIN
            mov     r8d, edx
            mov     r9, 0x0                             ; L
            xor     r10, r10
            lea     r10d, [esi - 1]                     ; R
binsrch_Loop:
            lea     rax, [r9 + r10]
            mov     r11d, 0x2
            xor     rdx, rdx
            div     r11d
            mov     r11d, dword [rdi + rax*0x4]         ; arr[m]
            cmp     r11d, r8d
            lea     rdx, [rax + 1]
            cmovl   r9, rdx
            lea     rdx, [rax - 1]
            cmovg   r10d, edx
            je      binsrch_Leave
            cmp     r9d, r10d
            jle     binsrch_Loop
            mov     eax, ecx
binsrch_Leave:
            ret

            section .data

arrFmt      db      "[%d]", 0x9, "%d", 0xa, 0x0
resFmt      db      "%d is at index [%d]", 0xa, 0x0
noMatch     db      "No match found.", 0xa, 0x0
newline     db      0xa, 0x0