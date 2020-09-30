; ######################################################
; Linked list implementation
;
; https://www.techiedelight.com/linked-list-implementation-part-1/
; https://www.techiedelight.com/linked-list-implementation-part-2/
; ######################################################

            default rel
            global  main
            extern  malloc
            extern  free
            extern  printf

struc       Node
            .data   resd    1
            .next   resq    1
endstruc

            section .text

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
; ------------------------------------------------------------------------------
main:
            push    r12
            push    r13
            push    r14
            push    r15
            push    rbx
            ;sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            mov     qword [rsp], 0x0                    ; Node *head = NULL;
            cmp     r12, 0x2
            jl      main_Leave
            lea     rdi, [(r12 - 0x1) * 0x4]            ; Array size
            call    malloc
            mov     r14, rax
            mov     r15, 0x1
main_ArrLoop:
            mov     rdi, qword [r13 + r15*0x8]
            call    atoi
            mov     dword [r14 + (r15-0x1)*0x4], eax
            inc     r15
            cmp     r15, r12
            jl      main_ArrLoop
            mov     rbx, rsp                            ; Node *head
            dec     r12
            mov     r15, 0x0
main_ListLoop:
            mov     rdi, rbx
            mov     esi, dword [r14 + r15*0x4]
            call    appendNode
            inc     r15
            cmp     r15, r12
            jl      main_ListLoop
main_Leave:
            ud2
            mov     rdi, r14
            call    free
            ;add     rsp, 0x8
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- struct Node *newNode(int data);
; ------------------------------------------------------------------------------
newNode:
            push    rdi
            mov     rdi, Node_size
            call    malloc
            pop     rdi
            mov     dword [rax + Node.data], edi
            mov     qword [rax + Node.next], 0x0
            ret

; ------------------------------------------------------------------------------
; -- void printList(struct Node *head);
; ------------------------------------------------------------------------------
printList:
            ud2
            ret

; ------------------------------------------------------------------------------
; -- void appendNode(struct Node **head, int data);
; ------------------------------------------------------------------------------
appendNode:
            push    r12
            push    r13
            mov     rdi, rsi
            call    newNode
            mov     rdx, rax
            mov     rcx, qword [r12]
            cmp     rcx, 0x0
            jne     appendNode_Loop
            mov     rdi, r12
            mov     rsi, r13
            call    pushNode
            ret
appendNode_Loop:
            ud2
            mov     r8, qword [rdx]
            mov     rdx, qword [r8 + Node.next]
            cmp     rdx, 0x0
            je      appendNode_Leave
            jmp     appendNode_Loop
appendNode_Leave:
            ud2
            ret

; ------------------------------------------------------------------------------
; -- void pushNode(struct Node **head, int data);
; ------------------------------------------------------------------------------
pushNode:
            push    rdi
            push    rsi
            mov     rdi, Node_size
            call    malloc
            pop     rsi
            pop     rdi
            mov     dword [rax + Node.data], esi
            mov     rdx, qword [rdi]
            mov     qword [rax + Node.next], rdx
            mov     qword [rdi], rax
            ret

; ------------------------------------------------------------------------------
; -- int atoi(char *str);
; ------------------------------------------------------------------------------
atoi:
            mov     rsi, 0x0
            mov     ecx, 0x1
            movzx   r9, byte [rdi]
            mov     r10, 0x0                            ; Sum
atoi_Loop:
            cmp     r9, 0x2d                            ; ASCII '-'
            mov     eax, -0x1
            cmove   ecx, eax
            mov     rax, r10
            mov     r11, 0xa
            xor     rdx, rdx
            mul     r11
            lea     rax, [rax + r9 - 0x30]              ; curr + prev
            cmp     r9, 0x2d
            cmovne  r10, rax
            inc     rsi
            movzx   r9, byte [rdi + rsi]
            cmp     r9, 0x0
            jne     atoi_Loop
            mov     rax, r10
            mul     ecx
            ret

            section .data

outFmt      db      "%d ", 0x0
newline     db      0xa, 0x0