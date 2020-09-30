; ######################################################
; Klotski written in NASM
;
; Tom Hebel, 2020
; ######################################################

            default rel
            global  _start

; +----+----+----+----+
; | a1 | b1 | c1 | d1 |
; +----+----+----+----+
; | a2 | b2 | c2 | d2 |
; +----+----+----+----+
; .                   .
; .        etc.       .
; .                   .
; +----+----+----+----+
struc       GameBoard
            .a1     resb    1
            .a2     resb    1
            .a3     resb    1
            .a4     resb    1
            .a5     resb    1
            .b1     resb    1
            .b2     resb    1
            .b3     resb    1
            .b4     resb    1
            .b5     resb    1
            .c1     resb    1
            .c2     resb    1
            .c3     resb    1
            .c4     resb    1
            .c5     resb    1
            .d1     resb    1
            .d2     resb    1
            .d3     resb    1
            .d4     resb    1
            .d5     resb    1
endstruc

; State for each square on the board.
VERT_1_T    equ     0x1
VERT_1_B    equ     0x2
VERT_2_T    equ     0x3
VERT_2_B    equ     0x4
VERT_3_T    equ     0x5
VERT_3_B    equ     0x6
VERT_4_T    equ     0x7
VERT_4_B    equ     0x8
LARG_TL     equ     0x9
LARG_TR     equ     0xa
LARG_BL     equ     0xb
LARG_BR     equ     0xc
HORI_L      equ     0xd
HORI_R      equ     0xe
SMOL_1      equ     0xf
SMOL_2      equ     0x10
SMOL_3      equ     0x11
SMOL_4      equ     0x12
EMPT_1      equ     0x13
EMPT_2      equ     0x14

; Game piece bash colors.
; See: https://misc.flogisoft.com/bash/tip_colors_and_formatting
CLR_NORM    equ     0x6b                                ; White
CLR_LARG    equ     0x65                                ; Light red
TXT_NORM    equ     0x5a                                ; Dark gray
TXT_LARG    equ     0x61                                ; White

; Block constants.
BLCK_COLS   equ     0x3
BLCK_ROWS   equ     0x2
BLCK_EMPT   equ     0x20                                ; Space char

; Misc. constants
EOF         equ     -1

            section .data

gameBoard:
istruc  GameBoard
            at GameBoard.a1, db VERT_1_T
            at GameBoard.a2, db VERT_1_B
            at GameBoard.a3, db VERT_2_T
            at GameBoard.a4, db VERT_2_B
            at GameBoard.a5, db SMOL_1
            at GameBoard.b1, db LARG_TL
            at GameBoard.b2, db LARG_BL
            at GameBoard.b3, db HORI_L
            at GameBoard.b4, db SMOL_2
            at GameBoard.b5, db EMPT_1
            at GameBoard.c1, db LARG_TR
            at GameBoard.c2, db LARG_BR
            at GameBoard.c3, db HORI_R
            at GameBoard.c4, db SMOL_3
            at GameBoard.c5, db EMPT_2
            at GameBoard.d1, db VERT_3_T
            at GameBoard.d2, db VERT_3_B
            at GameBoard.d3, db VERT_4_T
            at GameBoard.d4, db VERT_4_B
            at GameBoard.d5, db SMOL_4
iend

            section .text
     
; ------------------------------------------------------------------------------
; -- void _start();
; ------------------------------------------------------------------------------
_start:
            sub     rsp, 0x8
            call    gameLoop
            ud2
            add     rsp, 0x8
            ret

; ------------------------------------------------------------------------------
; -- void gameLoop(void);
; ------------------------------------------------------------------------------
gameLoop:
            sub     rsp, 0x8
            call   drawBoard 
            ud2
            add     rsp, 0x8
            ret

; ------------------------------------------------------------------------------
; -- void movePiece(int square, int x, int y);
; ------------------------------------------------------------------------------
movePiece:
            ud2
            ret

; ------------------------------------------------------------------------------
; -- void drawBoard(void);
; ------------------------------------------------------------------------------
drawBoard:
            mov     rdi, 0x0
drawBoard_OuterLoop:
            mov     rsi, 0x0
drawBoard_InnerLoop:
            ud2
            inc     rsi
            cmp     rsi, BLCK_COLS
            jl      drawBoard_InnerLoop
            inc     rdi
            cmp     rdi, BLCK_ROWS
            jl      drawBoard_OuterLoop
            ud2
            ret

; ------------------------------------------------------------------------------
; -- int puts(char *str);
; ------------------------------------------------------------------------------
puts:
            mov     rax, 0x0
            cmp     byte [rdi + rax], 0x0
            je      puts_Leave
puts_StrlenLoop:
            inc     rax
            cmp     byte [rdi + rax], 0x0
            jne     puts_StrlenLoop
            mov     rsi, rdi
            mov     rdx, rax
            mov     rax, 0x1                            ; Syscall
            mov     rdi, 0x0
            syscall
puts_Leave:
            mov     rax, EOF
            ret

; ------------------------------------------------------------------------------
; -- int strlen(char *str);
; ------------------------------------------------------------------------------
strlen:
            mov     rax, 0x0
            cmp     byte [rdi + rax], 0x0
            je      strlen_Leave
strlen_Loop:
            inc     rax
            cmp     byte [rdi + rax], 0x0
            jne     strlen_Loop
strlen_Leave:
            ret
