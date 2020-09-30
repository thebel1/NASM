; ######################################################
; Singly-linked list
;
; https://en.wikipedia.org/wiki/Linked_list#Linearly_linked_lists
; https://www.techiedelight.com/linked-list-implementation-part-2/
; ^ The code in this article is terrible, by the way
; ######################################################
; TODO: implement freeList() function.

            default rel
            global  main
            extern  malloc
            extern  free
            extern  printf

struc       ListNode
            .next   resq    1
            .val    resd    1
endstruc

            section .text

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
; ------------------------------------------------------------------------------
; TODO: do atoi & apppendNode in one loop.
main:
            push    r12
            push    r13
            push    r14
            push    r15
            push    rbx
            sub     rsp, 0x10
            mov     r12, rdi
            mov     r13, rsi
            lea     rbx, [rsp + 0x8]
            mov     qword [rbx], 0x0                    ; struct ListNode *head = NULL
            cmp     r12, 0x2
            jl      main_Leave
            lea     rdi, [(r12 - 0x1) * 0x4]
            call    malloc
            mov     r14, rax
            mov     r15, 0x1
main_ArrLoop:
            mov     rdi, qword [r13 + r15*0x8]
            call    atoi
            mov     dword [r14 + (r15 - 0x1)*0x4], eax
            inc     r15
            cmp     r15, r12
            jl      main_ArrLoop
            dec     r12
            mov     r15, 0x0
main_ListLoop:
            mov     rdi, rbx
            mov     esi, dword [r14 + r15*0x4]
            call    appendNode
            inc     r15
            cmp     r15, r12
            jl      main_ListLoop
            mov     rdi, qword [rbx]
            call    printList
main_Leave:
            add     rsp, 0x10
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- void pushNode(struct ListNode **head, int val);
; ------------------------------------------------------------------------------
pushNode:
            push    rdi
            push    rsi
            mov     rdi, ListNode_size
            call    malloc
            mov     rdx, rax
            pop     rsi
            pop     rdi
            mov     rax, qword [rdi]
            mov     qword [rdx + ListNode.next], rax
            mov     dword [rdx + ListNode.val], esi
            mov     qword [rdi], rdx
            ret

; ------------------------------------------------------------------------------
; -- void appendNode(struct ListNode **head, int val);
; ------------------------------------------------------------------------------
appendNode:
            mov     rax, qword [rdi]
            cmp     rax, 0x0
            jne     appendNode_Loop
            push    rsi
            call    pushNode
            pop     rsi
            ret
appendNode_Loop:
            mov     rdx, rax
            mov     rax, qword [rax + ListNode.next]
            cmp     rax, 0x0
            je      appendNode_Leave
            jmp     appendNode_Loop
appendNode_Leave:
            lea     rdi, [rdx + ListNode.next]
            call    pushNode
            ret

; ------------------------------------------------------------------------------
; -- void printList(struct ListNode *head);
; ------------------------------------------------------------------------------
printList:
            push    rbx
            mov     rbx, rdi
printList_Loop:
            cmp     rbx, 0x0
            je      printList_Leave
            mov     rdi, outFmt
            mov     esi, dword [rbx + ListNode.val]
            call    printf
            mov     rbx, qword [rbx + ListNode.next]
            jmp     printList_Loop
printList_Leave:
            mov     rdi, newline
            call    printf
            pop     rbx
            ret

; ------------------------------------------------------------------------------
; -- int atoi(char *str);
; ------------------------------------------------------------------------------
atoi:
            mov     rsi, 0x0
            mov     rcx, 0x1
            movzx   r8, byte [rdi]
            mov     r9, 0x0                             ; Sum
            cmp     r8, 0x2d                            ; ASCII '-'
            mov     r10, -0x1
            cmove   rcx, r10
            lea     r10, [rsi + 0x1]
            cmove   rsi, r10
            movzx   r8, byte [rdi + rsi]
atoi_Loop:
            mov     r10, 0xa
            mov     rax, r9
            xor     rdx, rdx
            mul     r10
            lea     rax, [rax + r8 - 0x30]
            mov     r9, rax
            inc     rsi
            movzx   r8, byte [rdi + rsi]
            cmp     r8, 0x0
            jne     atoi_Loop
            mov     rax, r9
            mul     ecx
            ret

            section .data
outFmt      db      "%d ", 0x0
newline     db      0xa, 0x0