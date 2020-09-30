            global  main
            extern  atoi
            extern  malloc
            extern  free
            extern  printf
            default rel

struc       ListNode
            .next    resq    1
            .val     resd    1
endstruc

            section .text

main:       ; main(argc, argv)
            cmp     rdi, 0x1
            je      main_Leave
            mov     rdi, [rsi+0x8]
            call    atoi
            mov     rbx, rax
            mov     rdi, rbx
            call    initList
            mov     r12, rax
main_Loop:
            mov     rdi, format
            mov     rsi, rax
            mov     edx, dword [rax + ListNode.val]
            push    rax
            call    printf
            pop     rax
            mov     rax, [rax]
            test    rax, rax            ; Loop until struc ListNode.next == 0x0
            jne     main_Loop
            mov     rdi, r12
            call    freeList
main_Leave:
            xor     rax, rax
            ret

initList:   ; initList(count)
            push    rbx
            push    rcx
            push    rbp
            sub     rsp, 0x8            ; Align stack
            mov     rbx, rdi
            mov     rbp, 0x0
            mov     r12, 0x0
initList_Loop:
            mov     r15, rbp
            mov     rdi, 0x12           ; Size of struc ListNode
            push    rcx
            call    malloc
            pop     rcx
            test    rax, rax
            je      malloc_Panic
            mov     rbp, rax
            mov     qword [rbp + ListNode.next], 0x0
            mov     dword [rbp + ListNode.val], r12d
            inc     r12
            cmp     r12, 0x1
            je      initList_GetListPtr
            mov     qword [r15 + ListNode.next], rbp
            cmp     r12, rbx
            jne     initList_Loop
            mov     rax, rcx
            add     rsp, 0x8
            pop     rbp
            pop     rcx
            pop     rbx
            ret
initList_GetListPtr:
            mov     rcx, rbp
            jmp     initList_Loop

malloc_Panic:
            ud2

freeList:   ; freeList(struc ListNode*)
            mov     r12, rdi
            mov     rax, r12
freeList_Loop:
            mov     rdi, rax
            push    rax
            call    free
            pop     rax
            mov     rax, [rax]
            test    rax, rax            ; Loop until struc ListNode.next == 0x0
            jne     freeList_Loop
            ret

            section .data

format:     db      "%p: %d", 0xa, 0x0