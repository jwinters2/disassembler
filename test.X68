*-----------------------------------------------------------
* Title      :TEST
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
     



    ORG    $1000
    
START:                  ; first instruction of program
    MOVE.L  #$7002,IN_CURRENT_ADD
    JSR MOVE

    SIMHALT             ; halt simulator

* Put variables and constants here

    INCLUDE 'helper.X68'
    INCLUDE 'move_sub.X68'
    INCLUDE 'OPCODE_TEST.X68'
    
IN_CURRENT_ADD  DS.L    1 
OUT_CURRENT_ADD DS.W    1  
FOUND   DS.W     1     flag for function found


    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
