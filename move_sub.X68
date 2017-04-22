*-----------------------------------------------------------
* Title      :MOVE
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
MOVE_S  EQU $0000
MOVE_P  EQU $C000


    *check for move command
MOVE    
    MOVE.L  #MOVE_P,D0
    MOVE.L  IN_CURRENT_ADD,A0
    MOVE.W  (A0),D1
    AND.L   D1,D0
    *compare move signature with anded move_p and machine code
    CMP.L   #MOVE_S,D0
    
    BNE NOTFOUND    not move instruction, call RTS from helper file
    
    *instruction found, set FOUND TRUE
    MOVE.B  #1,FOUND
    
    *define out starting address
    MOVE.W  #$0100,OUT_CURRENT_ADD
    MOVE.W  OUT_CURRENT_ADD,A1
    
    *add ascii 'MOVE' into result address
    MOVE.L    ADDMOVE,(A1)+
    MOVE.W  A1, OUT_CURRENT_ADD
    *add null to print out string
    MOVE.B  #$00,(A1)
    *put OUT_START_ADD in A! to print
    MOVE.W  #$0100,A1
    *display string
    MOVE.B  #14,D0
    TRAP    #15

    *return to ID_INSTRUCTION
    RTS
    

* Put variables and constants here
ADDMOVE     DC.B    'MOVE' 








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
