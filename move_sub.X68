*DECODED
*SIZE
*SOURCE Dn
*ADDRESS Dn
*
*-MOVE.B D0,D1
*
*------------------------------------------------------------------------------

MOVE_SUB
        MOVEM.L   D0-D7/A0-A6,-(SP) ; move the old registers onto the stack
       

        * sets up the data registers
        *
        * A1 - the current opcode's address
        * A3 - the current position of the output
        * A4 - the location of the text for printing
        *
        *
        * D1 - the actual opcode
        *
        MOVEA.L   #0,A1             ; load the current opcode into a register
        MOVEA.W   IN_CURR_A,A1
        
        MOVE.W    (A1)+,D1          ; ***move A1 to next command or to parameter

        MOVEA.L   #0,A3
        MOVEA.W   OUT_CURR_A,A3 ; move the current output pointer to A3
        LEA       MOVE_STR,A4     ; move the to-be-printed string to A4

        * we need to append the string at ###_STR to the output string
        * we do this char by char (byte by byte) until we see a NULL (0)
        * in ###_STR

MOVE_COPY
        TST.B     (A4)      ; test the contents of A4
        BEQ       MOVE_DONE  ; if we hit a 00, we're done copying

        MOVE.B    (A4)+,(A3)+   ; copy A4 into A3, then increment both
        BRA       MOVE_COPY      ; do it again
        
MOVE_DONE
        
        *get operation size
        MOVE.W  #$3000,D2
        AND.W   D1,D2
        CMP.W   #$1000,D2
        BEQ MOVE_B
        CMP.W   #$3000,D2
        BEQ MOVE_W
        CMP.W   #$2000,D2
        BEQ MOVE_L
        
MOVE_XMODE
        MOVE.W  #$38,D2
        AND.W   D1,D2
        CMP.B   #$0,D2
        BEQ     MOVE_DN

MOVE_XN
        MOVE.W  #$7,D2
        AND.W   D1,D2
        CMP.B   #$0,D2
        BEQ     MOVE_0                
MOVE_AMODE
        MOVE.W  #$1C0,D2
        AND.W   D1,D2
        CMP.W   #$0,D2
        BEQ     MOVE_AD  
MOVE_AN
        MOVE.W  #$E00,D2
        AND.W   D1,D2
        CMP.W   #$200,D2
        BEQ     MOVE_A1  

MOVE_FIN        
        MOVE.W    A1,IN_CURR_A  ; move the current A1 back to the input pointer
        MOVE.W    A3,OUT_CURR_A ; move the current A3 back to the output pointer

        MOVEM.L   (SP)+,D0-D7/A0-A6 ; move the old registers back to the stack
        RTS       ; return

*------------------------------------------------------------------------------
MOVE_B
        MOVE.B  #'.',(A3)+
        MOVE.B  #'B',(A3)+
        MOVE.B  #$09,(A3)+
        BRA MOVE_XMODE

MOVE_W
        MOVE.B  #'.',(A3)+
        MOVE.B  #'W',(A3)+
        MOVE.B  #$09,(A3)+
        BRA MOVE_XMODE
MOVE_L
        MOVE.B  #'.',(A3)+
        MOVE.B  #'L',(A3)+
        MOVE.B  #$09,(A3)+
        BRA MOVE_XMODE
MOVE_DN
        MOVE.B  #'D',(A3)+
        BRA MOVE_XN
MOVE_0        
        MOVE.B  #'0',(A3)+
        MOVE.B  #',',(A3)+
        MOVE.B  #' ',(A3)+
        BRA MOVE_AMODE
MOVE_AD 
        MOVE.B  #'D',(A3)+
        BRA MOVE_AN        
MOVE_A1        
        MOVE.B  #'1',(A3)+
        MOVE.B  #$0A,(A3)+
        MOVE.B  #$0D,(A3)+
        BRA MOVE_FIN        





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
