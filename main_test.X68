*-----------------------------------------------------------
* Title      : main.X68
* Written by : bisrat belayneh
* Date       : 4/21/2017
* Description: Displays welcome, Gets start and end address of memo to be decoded ,Define Out-start-addres,
*               defines valid-flag (1 for code valid 0 for code invalid),defines constants for start and end 
*               address of the program ,Sets out current add to out -start- add, Starts id running instruction
*-----------------------------------------------------------
CR              EQU     $0D                 ASCII code for carriage return
LF              EQU     $0A                 ASCII code  for line feed  

    ORG    $1000
START:                  ; first instruction of program

* Put program code here
*----------------------code for output------------------------
                LEA             welcome_msg,A1   ; load welcome msg to A1
                Move.W          #14,D0           ; move 14 to D0   
                Trap            #15              ; display the string at A1   

   


    MOVE.W      #$3000,IN_START_A
    MOVE.W      IN_START_A,IN_CURR_A
    MOVE.W      #$3006,IN_END_A

    MOVE.W      #$4E70,$3000
    MOVE.W      #$3456,$3002
    MOVE.W      #$4E70,$3004
    MOVE.W      #$4E70,$3006

LOOP
    JSR         CMD_IDENTIFY
    MOVE.W      IN_CURR_A,D1
    CMP.W       IN_END_A,D1
    BEQ         END_LOOP
    BRA         LOOP

END_LOOP

    SIMHALT             ; halt simulator

* Put variables and constants here
  * INCLUDE     'OPCODE_TEST.X68'
    INCLUDE     'CmdIdentify.X68'

WELCOME_MSG          dc.b    'Welcome to the Motorola MC68000 Microprocessor Disassembler',CR,LF,0   
START_ADD_MSG        dc.b    'Please enter Start memory address in hexadecimal: ',0
END_ADD_MSG          dc.b    'Please enter End memory address in hexadecimal(must be greater than start address): ',0
INPUT_FAIL_MSG       dc.b    'Invalid address entered. Please try again.',CR,LF,0
END_ADD_SMALLER_MSG  dc.b    'End address can not be less than starting address',CR,LF,0
ADD_TOO_SMALL        dc.b    'Address below minimum. enter address greater than or equal to $7000',CR,LF,0
ADD_TOO_BIG          dc.b    'Address above maximum. enter address less than or equal to $FFFFFFFE',CR,LF,0
IN_START_A           ds.w    1        ; stores program starting memory address 
IN_CURR_A            ds.w    1         ; stores current memory address
IN_END_A             ds.w    1         ; stores program ending memory address 
OUT_CURR_A           ds.w    1         ; stores current memory address
OUT_END_A            ds.w    1         ; stores program ending memory address 

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~









        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
