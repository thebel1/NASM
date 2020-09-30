; ######################################################
; Quicksort
;
; Implementation as per https://en.wikipedia.org/wiki/Quicksort#Lomuto_partition_scheme
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
            push    r14                                 ; int* arr
            push    r15                                 ; int i
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            cmp     r12, 0x1
            je      main_Leave
            lea     rdi, [(r12 - 0x1) * 0x4]
            call    malloc
            mov     r14, rax
            mov     r15, 0x0
            dec     r12
main_SortLoop:
            mov     rdi, qword [r13 + (r15 + 0x1)*0x8]  ; argv[i+1]
            call    atoi
            mov     dword [r14 + r15*0x4], eax
            inc     r15
            cmp     r15, r12
            jne     main_SortLoop
            mov     rdi, r14
            mov     rsi, 0x0
            lea     rdx, [r15 - 0x1]
            call    qsort
            mov     r15, 0x0
main_PrintLoop:
            mov     rdi, outFmt
            mov     esi, dword [r14 + r15*0x4]
            call    printf
            inc     r15
            cmp     r15, r12
            jl      main_PrintLoop
            mov     rdi, outNewLine
            call    printf
main_Leave:
            mov     rdi, r14
            call    free
            add     rsp, 0x8
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            xor     rax, rax
            ret
main_Panic:
            mov     rdi, mainErr
            call    printf
            ud2

; ------------------------------------------------------------------------------
; -- void qsort(int *arr, int lo, int hi);
; ------------------------------------------------------------------------------
qsort:
            push    r12                                 ; int *arr
            push    r13                                 ; int lo
            push    r14                                 ; int hi
            push    r15                                 ; int part
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
            mov     ecx, dword [rdi + rdx*0x4]          ; int pivot
            mov     r8, rsi                             ; int i
            mov     r9, rsi                             ; int j
partition_LoopStart:
            mov     r10d, dword [rdi + r9*0x4]
            mov     r11d, dword [rdi + r8*0x4]
            cmp     r10d, ecx
            jge     partition_LoopEnd
            mov     dword [rdi + r9*0x4], r11d
            mov     dword [rdi + r8*0x4], r10d
            inc     r8
partition_LoopEnd:
            inc     r9
            cmp     r9, rdx
            jne     partition_LoopStart                 ; INVESTIGATE
            mov     r10d, dword [rdi + rdx*0x4]
            mov     r11d, dword [rdi + r8*0x4]
            mov     dword [rdi + rdx*0x4], r11d
            mov     dword [rdi + r8*0x4], r10d
            mov     rax, r8
            ret

            section .data

outFmt      db      "%d", 0x20, 0x0
outNewLine  db      0xa, 0x0
mainErr     db      "Something went wrong.", 0xa, 0x0      