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
        MOVEA.L   IN_CURR_A,A1
        
        MOVE.W    (A1)+,D1          ; ***move A1 to next command or to parameter

        MOVEA.L   #0,A3
        MOVEA.L   OUT_CURR_A,A3 ; move the current output pointer to A3
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
        
MOVE_XMODE  ;get source EA
        MOVE.W  #$38,D2
        AND.W   D1,D2
        LSR.B   #3,D2
        MOVE.B  #$7,D7
        AND.B   D1,D7
        
        CMP.B   #$0,D2
        BEQ MOVE_DATA
        CMP.B   #$1,D2
        BEQ MOVE_ADD
        CMP.B   #$2,D2
        BEQ MOVE_IADD
        CMP.B   #$3,D2
        BEQ MOVE_ADDP
        CMP.B   #$4,D2
        BEQ MOVE_PADD
        CMP.B   #$7,D2
        BEQ MOVE_GETEA


              
MOVE_AMODE
        MOVE.B  #',',(A3)+
               
        MOVE.W  #$1C0,D2
        AND.W   D1,D2
        LSR.L   #6,D2
        
        MOVE.W  #$E00,D7
        AND.W   D1,D7
        LSR.W   #8,D7
        LSR.W   #1,D7
        
        CMP.B   #$0,D2
        BEQ MOVE_ADATA
        CMP.B   #$2,D2
        BEQ MOVE_AIADD
        CMP.B   #$3,D2
        BEQ MOVE_AADDP
        CMP.B   #$4,D2
        BEQ MOVE_APADD
        CMP.B   #$7,D2
        BEQ MOVE_AGETEA
        
 

MOVE_FIN 
        MOVE.B  #$A,(A3)+
        MOVE.B  #$D,(A3)+       
        MOVE.L    A1,IN_CURR_A  ; move the current A1 back to the input pointer
        MOVE.L    A3,OUT_CURR_A ; move the current A3 back to the output pointer

        MOVEM.L   (SP)+,D0-D7/A0-A6 ; move the old registers back to the stack
        RTS       ; return

*------------------------------------------------------------------------------
MOVE_DATA
    JSR PRINTDN
    BRA MOVE_AMODE
MOVE_ADD
    JSR PRINTAN
    BRA MOVE_AMODE
MOVE_IADD
    JSR PRINTIAN
    BRA MOVE_AMODE
MOVE_ADDP
    JSR PRINTAP
    BRA MOVE_AMODE
MOVE_PADD
    JSR PRINTPA
    BRA MOVE_AMODE
MOVE_ADATA
    JSR PRINTDN
    BRA MOVE_FIN
MOVE_AIADD
    JSR PRINTIAN
    BRA MOVE_FIN
MOVE_AADDP
    JSR PRINTAP
    BRA MOVE_FIN
MOVE_APADD
    JSR PRINTPA
    BRA MOVE_FIN
*ABSOLUTE OR IMMEDIATE  
MOVE_GETEA  
    MOVE.L  #0,D3
    CMP #0,D7
    BEQ MOVE_ABSW
    CMP #1,D7
    BEQ MOVE_ABSL
    CMP #4,D7
    BEQ MOVE_IMM


MOVE_ABSW
                  MOVE.B  #'$',(A3)+
MOVE_ABSW_LOOP    JSR MOVE_GETBYTE
                  ADDQ.B    #1,D3
                  CMP.B     #2,D3
                  BNE   MOVE_ABSW_LOOP
                  BRA MOVE_AMODE
MOVE_ABSL
                  MOVE.B  #'$',(A3)+
               
MOVE_ABSL_LOOP    JSR MOVE_GETBYTE
                  ADDQ.B    #1,D3
                  CMP.B     #4,D3
                  BNE   MOVE_ABSL_LOOP
                  BRA MOVE_AMODE
MOVE_IMM
                  MOVE.B  #'#',(A3)+
                  MOVE.B  #'$',(A3)+
                  MOVE.W    #$3000,D2
                  AND.W     D1,D2
                  CMP.W     #$2000,D2
                  BEQ   MOVE_IMML_LOOP
MOVE_IMMW_LOOP    JSR MOVE_GETBYTE
                  ADDQ.B    #1,D3
                  CMP.B     #2,D3
                  BNE   MOVE_IMMW_LOOP
                  BRA MOVE_AMODE                  
MOVE_IMML_LOOP    JSR MOVE_GETBYTE
                  ADDQ.B    #1,D3
                  CMP.B     #4,D3
                  BNE   MOVE_IMML_LOOP
                  BRA MOVE_AMODE
MOVE_GETBYTE
    MOVE.B  (A1)+,D5
    MOVE.B  D5,D6
    AND.B   #$F0,D6
    LSR.B   #4,D6
    JSR MOVE_CONVERT
    MOVE.B  D6,(A3)+
    MOVE.B  D5,D6
    AND.B   #$F,D6
    JSR MOVE_CONVERT
    MOVE.B  D6,(A3)+
    RTS
MOVE_CONVERT
    CMP.B   #10,D6
    BLT MOVE_DIGIT
    ADD.B   #$37,D6
    RTS
MOVE_DIGIT
    ADD.B #$30,D6
    RTS    



MOVE_AGETEA 
    MOVE.L  #0,D3
    CMP #0,D7
    BEQ MOVE_ABSWD
    CMP #1,D7
    BEQ MOVE_ABSLD   
MOVE_ABSWD
                  MOVE.B  #'$',(A3)+
MOVE_ABSWD_LOOP    JSR MOVE_GETBYTE
                  ADDQ.B    #1,D3
                  CMP.B     #2,D3
                  BNE   MOVE_ABSWD_LOOP
                  BRA MOVE_FIN
MOVE_ABSLD
                  MOVE.B  #'$',(A3)+
                
MOVE_ABSLD_LOOP    JSR MOVE_GETBYTE
                  ADDQ.B    #1,D3
                  CMP.B     #4,D3
                  BNE   MOVE_ABSLD_LOOP
                  BRA MOVE_FIN    
PRINTNUM    ;takes value in D7 and prints it to output
        ADD.B   #$30,D7
        MOVE.B  D7,(A3)+
        RTS
PRINTDN     ;takes value in D7 and prints D#
        MOVE.B  #'D',(A3)+
        JSR PRINTNUM
        RTS
PRINTAN     ;takes value in D7 and prints A#
        MOVE.B  #'A',(A3)+
        JSR PRINTNUM
        RTS
PRINTIAN    ;takes value in D7 and prints (A#)
        MOVE.B  #'(',(A3)+
        MOVE.B  #'A',(A3)+
        JSR PRINTNUM
        MOVE.B  #')',(A3)+
        RTS
PRINTAP    ;takes value in D7 and prints (A#)+
        MOVE.B  #'(',(A3)+
        MOVE.B  #'A',(A3)+
        JSR PRINTNUM
        MOVE.B  #')',(A3)+
        MOVE.B  #'+',(A3)+
        RTS
PRINTPA    ;takes value in D7 and prints -(A#)
        MOVE.B  #'-',(A3)+
        MOVE.B  #'(',(A3)+
        MOVE.B  #'A',(A3)+
        JSR PRINTNUM
        MOVE.B  #')',(A3)+
        RTS                
*size helpers       
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
      







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
