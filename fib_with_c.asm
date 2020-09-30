            global  main
            extern  atoi
            extern  printf

            section .text

;   int main(int argc, char **argv)
;   {
main:

;       if (argc == 1) {
;           goto main_Leave;
;       }
            cmp     rdi, 0x1
            je      main_Leave

;       int count = atoi(argv[1]); // Number of repititions
            mov     rdi, [rsi + 0x8]
            call    atoi

;       fib(0, 1, count);
            mov     rdi, 0x0
            mov     rsi, 0x1
            mov     rdx, rax
            call    fib

;   main_Leave:
main_Leave:
;       return 0;
;   }
            xor     rax, rax
            ret

;   void fib(int left, int right, int count)
;   {
fib:

;       if (count == 0) {
;           goto fib_Leave;
            test    rdx, rdx
            je      fib_Leave

;       int intMax = 2^31;
            mov     rax, 0x1
            shl     rax, 0x1f

;       if (count >= intMax) {
;           goto fib_Overflow;
;       }
            cmp     rdi, rax
            jge     fib_Overflow

;       printf(format, left);
            mov     r12, rdi
            mov     r13, rsi
            mov     r14, rdx
            mov     rdi, format
            mov     rsi, r12
            call    printf
            mov     rdx, r14

;       int tmp = right;
            mov     r15, r13

;       ight = left + right;
            mov     rsi, r13
            add     rsi, r12

;       left = right;
            mov     rdi, r13

;       count--;
            dec     rdx

;       fib(left, right, count);
            jmp     fib

;   fib_Overflow:
fib_Overflow:

;       printf(overflow, left);
            mov     r15, rdi
            mov     rdi, overflow
            call    printf

;   fib_Leave:
fib_Leave:

;       return;
;   }
            pop     rbx
            ret

            section .data

;   const char format[] = "%ld\n";
format:     db      "%ld", 0xa, 0x0

;   const char overflow[] = "%lld -> integer overflow!\n";
overflow:   db      "%lld -> integer overflow!", 0xa, 0x0