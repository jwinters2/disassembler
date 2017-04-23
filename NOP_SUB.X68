NOP_SUB
        MOVEM.L   D0-D7/A0-A6,-(SP) ; move the old registers onto the stack

        MOVEA.L   #0,A1
        MOVEA.W   OUT_CURR_A,A1 ; move the current output pointer to A1
        LEA       NOP_STR,A2     ; move the to-be-printed string to A2

        * we need to append the string at NOP_STR to the output string
        * we do this char by char (byte by byte) until we see a NULL (0)
        * in NOP_STR
COPY
        TST.B     (A2)  ; test the contents of A2
        BEQ       DONE  ; if we hit a 00, we're done copying

        MOVE.B    (A2)+,(A1)+   ; copy A2 into A1, then increment both
        BRA       COPY          ; do it again
        
DONE

        MOVE.L    A1,OUT_CURR_A ; move the current A1 back to the output pointer

        MOVEM.L   (SP)+,D0-D7/A0-A6 ; move the old registers back to the stack
        RTS       ; return
      

NOP_S   EQU   $4E70
NOP_P   EQU   $FFFF
NOP_STR DC.B  'NOP',$0A,$0D,0
