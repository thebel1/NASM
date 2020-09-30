; ######################################################
; Deserialize binary tree
;
; https://www.geeksforgeeks.org/serialize-deserialize-binary-tree/
; ######################################################

            default rel
            global  main
            extern  malloc
            extern  free
            extern  printf

struc       TreeNode
            .left   resq    1
            .right  resq    1
            .val    resd    1
endstruc

; ------------------------------------------------------------------------------
; -- int main(int argc, char **argv);
; ------------------------------------------------------------------------------
main:
            push    r12
            push    r13
            push    r14
            push    r15
            sub     rsp, 0x8
            mov     r12, rdi
            mov     r13, rsi
            lea     rdi, [(r12 - 0x1) * 0x4]
            call    malloc
            mov     r14, rax
            mov     r15, 0x1
main_Loop:
            mov     rdi, qword [r13 + r15*0x8]
            call    atoi
            mov     dword [r14 + (r15 - 0x1)*0x4], eax
            inc     r15
            cmp     r15, r12
            jl      main_Loop
            dec     r12
            mov     rdi, rsp
            mov     rsi, r14
            mov     rdx, 0x0
            mov     rcx, r12
            call    deserialize
            ud2
            mov     rdi, r14
            call    free
            mov     rdi, qword [rsp]
            call    serialize
            mov     rdi, newline
            call    printf
main_Leave:
            add     rsp, 0x8
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- int atoi(char *str);
; ------------------------------------------------------------------------------
atoi:
            movzx   rax, byte [rdi]
            cmp     rax, 0x2d                           ; ASCII '-'
            mov     rax, -0x1
            cmove   rcx, rax
            mov     rax, 0x1
            cmovne  rcx, rax
            mov     rsi, 0x0
            cmove   rsi, rax
            mov     r8, 0x0                             ; Sum
            movzx   r9, byte [rdi + rsi]
atoi_Loop:
            mov     rax, r8
            mov     r10, 0xa
            xor     rdx, rdx
            mul     r10
            lea     r8, [rax + r9 - 0x30]
            inc     rsi
            movzx   r9, byte [rdi + rsi]
            cmp     r9, 0x0
            jne     atoi_Loop
            mov     rax, r8
            mul     ecx
            ret

; ------------------------------------------------------------------------------
; -- TreeNode *newNode(int val);
; ------------------------------------------------------------------------------
newNode:
            push    rdi
            mov     rdi, TreeNode_size
            call    malloc
            pop     rdi
            mov     qword [rax + TreeNode.left], 0x0
            mov     qword [rax + TreeNode.right], 0x0
            mov     dword [rax + TreeNode.val], edi
            ret

; ------------------------------------------------------------------------------
; -- int serialize(TreeNode *root);
; ------------------------------------------------------------------------------
serialize:
            push    r12
            mov     r12, rdi
            cmp     r12, 0x0
            jne     serialize_Skip
            mov     rdi, outFmt
            mov     esi, -0x1
            call    printf
            pop     r12
            ret
serialize_Skip:
            mov     rdi, outFmt
            mov     esi, dword [r12 + TreeNode.val]
            call    printf
            mov     rdi, qword [r12 + TreeNode.left]
            call    serialize
            mov     rdi, qword [r12 + TreeNode.right]
            call    serialize
serialize_Leave:
            pop     r12
            ret

; ------------------------------------------------------------------------------
; -- int deserialize(TreeNode **root, int  *arr, int arrIdx, int arrSz);
; ------------------------------------------------------------------------------
deserialize:
            push    r12
            push    r13
            push    r14
            push    r15
            push    rbx
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx
            mov     r15, rcx
            cmp     r14, r15
            mov     eax, r14d
            je      deserialize_Leave
            mov     edi, dword [r13 + r14*0x4]
            cmp     edi, -0x1
            lea     rax, [r14 + 0x1]
            je      deserialize_Leave
            call    newNode
            mov     rbx, rax
            mov     qword [r12], rbx
            lea     rdi, [rbx + TreeNode.left]
            mov     rsi, r13
            lea     rdx, [r14 + 0x1]
            mov     rcx, r15
            call    deserialize
            lea     rdi, [rbx + TreeNode.right]
            mov     rsi, r13
            mov     rdx, rax
            mov     rcx, r15
            call    deserialize
deserialize_Leave:
            pop     rbx
            pop     r15
            pop     r14
            pop     r13
            pop     r12
            ret

            section .data

outFmt      db      "%d ", 0x0
newline     db      0xa, 0x0