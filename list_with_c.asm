            global  main
            extern  atoi
            extern  malloc
            extern  free
            extern  printf
            default rel

;   struct ListNode {
;       struct ListNode *next;
;       int val;
;   };
struc       ListNode
            .next    resq    1
            .val     resd    1
endstruc

            section .text

;   int main(int argc, char **argv)
;   {
main:

;       if (argc == 1) {
;           goto main_Leave;
;       }
            cmp     rdi, 0x1
            je      main_Leave

;       int count = atoi(argv[1]);  // Number of repititions
            mov     rdi, [rsi+0x8]
            call    atoi

;       struct ListNode *node = initList(count);
            mov     rbx, rax
            mov     rdi, rbx
            call    initList

;       struct ListNode *head = node;
            mov     r12, rax

;       do {
main_Loop:

;           printf(format, node, node->val);
            mov     rdi, format
            mov     rsi, rax
            mov     edx, dword [rax + ListNode.val]
            push    rax
            call    printf
            pop     rax

;           node = node->next;
            mov     rax, [rax]

;       } while (node->next != NULL);
            test    rax, rax            ; Loop until struc ListNode.next == 0x0
            jne     main_Loop

;       freeList(head);
            mov     rdi, r12
            call    freeList

;   main_Leave:
main_Leave:

;       return 0;
;   }
            xor     rax, rax
            ret

;   struct ListNode *initList(int count)
;   {
initList:
            push    rbx
            push    rcx
            push    rbp
            sub     rsp, 0x8            ; Align stack
            mov     rbx, rdi

;       struct ListNode *node = NULL;
            mov     rbp, 0x0

;       int i = 0;
            mov     r12, 0x0

;   initList_Loop:
;       do {
initList_Loop:

;           struct ListNode *prev = node;
            mov     r15, rbp

;           node = malloc(12);
            mov     rdi, 0xc            ; Size of struc ListNode
            push    rcx
            call    malloc
            pop     rcx
            mov     rbp, rax

;           if (node == NULL) {
            test    rax, rax

;               goto malloc_Panic;
;           }
            je      malloc_Panic

;           node->next = NULL;
            mov     qword [rbp + ListNode.next], 0x0

;           node->val = i;
            mov     dword [rbp + ListNode.val], r12d

;           i++;
            inc     r12

;           if (i == 1) {
            cmp     r12, 0x1

;               goto initList_GetListPtr;
;           }
            je      initList_GetListPtr

;           prev->next = node;
            mov     qword [r15 + ListNode.next], rbp

;       } while (i <= count);
            cmp     r12, rbx
            jne     initList_Loop

;       return head;
            mov     rax, rcx
            add     rsp, 0x8
            pop     rbp
            pop     rcx
            pop     rbx
            ret

;   initList_GetListPtr:
;       struct ListNode *head = node;
;       goto initList_Loop;
initList_GetListPtr:
            mov     rcx, rbp
            jmp     initList_Loop

;   // No equivalent in C: Produces an invalid instruction exception.
malloc_Panic:
            ud2

;   void freeList (struc ListNode* head)
;   {
freeList:
            mov     r12, rdi

;       struct ListNode *node = head;
            mov     rax, r12

;       do {
freeList_Loop:

;           struct ListNode *next = node->next;
            mov     r13, [rax]

;           free(node);
            mov     rdi, rax
            call    free

            ; node = next;
            mov     rax, r13

;       } while (node != NULL);
            test    rax, rax            ; Loop until struc ListNode.next == 0x0
            jne     freeList_Loop

;   }
            ret

            section .data

;   const char format[] = "%p: %d\n";
format:     db      "%p: %d", 0xa, 0x0