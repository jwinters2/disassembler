* -----------------------------------------------------------------------------
* CMD_IDENTIFY subroutine
*
* Author: James Winters of WeMissJava
*
* CSS 422
*
* this subroutine checks the current opcode (word at IN_CURR_A)
* and determines which command it corresponds to
*
* then it runs that command's subroutine, which writes prints the dissassembled
* code onto the screen increments IN_CURR_A
* -----------------------------------------------------------------------------

CMD_IDENTIFY

        MOVEM.L   D0-D7/A0-A6,-(SP) ; move the old registers onto the stack
  
        MOVEA.L   #0,A1
        MOVEA.W   IN_CURR_A,A1  ; A1 is a pointer to the current position
        MOVE.W    (A1),D1       ; D1 is the current opcode
        
        * check NOP
        MOVE.W    D1,D2        ; move the value into D2 for temp storage
        MOVE.W    #NOP_P,D3    ; move values into registers for CMD_CHECK
        MOVE.W    #NOP_S,D4  
        MOVE.W    #NOP_SUB,D5
        JSR       CMD_CHECK
        CMP.B     #1,D6         ; check the answer CMD_CHECK gave us
        BEQ       END_IDENTIFY  ; skip to the end if it's equal

        * check MOVE
        MOVE.W    D1,D2        ; move the value into D2 for temp storage
        MOVE.W    #MOVE_P,D3    ; move values into registers for CMD_CHECK
        MOVE.W    #MOVE_S,D4  
        MOVE.W    #MOVE_SUB,D5
        JSR       CMD_CHECK
        CMP.B     #1,D6         ; check the answer CMD_CHECK gave us
        BEQ       END_IDENTIFY  ; skip to the end if it's equal
        
        * if we hit here it's not a valid command
        JSR       BAD_COMMAND_SUB

END_IDENTIFY

        MOVEM.L   (SP)+,D0-D7/A0-A6 ; move the old registers back to the stack
        RTS       ; return

* ------------------------------------------------------------------------------

CMD_CHECK
        MOVEM.L   A1,-(SP)   ; A1 is the only thing we need to keep from the
                             ; parent routine
        
        MOVE.B    #0,D6      ; we're storing the answer in D6

        AND.W     D3,D2      ; get rid of all the unimportant parts
        CMP.W     D4,D2      ; compare the result with the signature of the cmd
        BNE       NEGATIVE   ; if they don't match skip everything else

        MOVEA.L   D5,A1
        JSR       (A1)        ; jump to the subroutine at D5
        MOVE.B    #1,D6
 
NEGATIVE
        MOVEM.L   (SP)+,A1
        RTS

* ------------------------------------------------------------------------------

        INCLUDE 'BAD_COMMAND.X68'
        INCLUDE 'NOP_SUB.X68'
        INCLUDE 'MOVE_SUB.X68'

* BAD_COMMAND_STR DC.B  'DATA $',0

* NOP_STR DC.B  'NOP',$0A,$0D,0
* NOP_S   EQU   $4E70
* NOP_P   EQU   $FFFF

* ------------------------------------------------------------------------------


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
