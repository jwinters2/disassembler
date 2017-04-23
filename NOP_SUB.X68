
NOP_SUB
        MOVEM.L   D0-D7/A0-A6,-(SP) ; move the old registers onto the stack

        MOVEA.L   #0,A1             ; load the current opcode into a register
        MOVEA.W   IN_CURR_A,A1
        MOVE.W    (A1)+,D1          ; not necessary here, but for other cmds

        MOVEA.L   #0,A3
        MOVEA.W   OUT_CURR_A,A3 ; move the current output pointer to A3
        LEA       NOP_STR,A4     ; move the to-be-printed string to A4

        * we need to append the string at NOP_STR to the output string
        * we do this char by char (byte by byte) until we see a NULL (0)
        * in NOP_STR

NOP_COPY
        TST.B     (A4)      ; test the contents of A4
        BEQ       NOP_DONE  ; if we hit a 00, we're done copying

        MOVE.B    (A4)+,(A3)+   ; copy A4 into A3, then increment both
        BRA       NOP_COPY      ; do it again
        
NOP_DONE

        MOVE.W    A1,IN_CURR_A  ; move the current A1 back to the input pointer
        MOVE.W    A3,OUT_CURR_A ; move the current A3 back to the output pointer

        MOVEM.L   (SP)+,D0-D7/A0-A6 ; move the old registers back to the stack
        RTS       ; return

*------------------------------------------------------------------------------

