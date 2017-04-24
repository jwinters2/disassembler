*-----------------------------------------------------------
* Title      : main.X68
* Written by : bisrat for WeMissJava
* Date       : 4/21/2017
* Description: Displays welcome, Gets start and end address of memo to be decoded ,Define Out-start-addres,
*               defines valid-flag (1 for code valid 0 for code invalid),defines constants for start and end 
*               address of the program ,Sets out current add to out -start- add, Starts id running instruction
*-----------------------------------------------------------
CR              EQU     $0D                 ASCII code for carriage return
LF              EQU     $0A                 ASCII code  for line feed  


START:          ORG    $1000                first instruction of program

*---------------------------------------
*   THIS IS FOR TESTING, IGNORE THIS
*---------------------------------------
    MOVE.W      #$4E71,$13000
    MOVE.W      #$4E71,$13002
    MOVE.W      #$2401,$13004
    MOVE.W      #$2A0A,$13006
    MOVE.W      #$2C1B,$13008
    MOVE.W      #$21FC,$1300A
    MOVE.W      #$0000,$1300C
    MOVE.W      #$1234,$1300E
    MOVE.W      #$4000,$13010
    MOVE.W      #$3E3C,$13012
    MOVE.W      #$1234,$13014
    MOVE.W      #$1E3C,$13016
    MOVE.W      #$00CD,$13018
    MOVE.W      #$4E71,$1301A
*---------------------------------------

*Display welcome 
                LEA     welcome_msg,A1      load welcome message to A1
                Move.W  #14,D0              display the string at A1
                TRAP    #15                 run task 14
                
*read starting address message and convert to hex
                        
RD_START_INPUT  LEA     START_ADD_MSG,A1    load start address request msg
                MOVE.W  #14,D0              print data in d0 to screen 
                TRAP    #15                 run task 14
                
                LEA     IN_START_A,A1     load starting adresss input from user 
                MOVE.B  #2,D0               read string from key board and store it in A1
                TRAP    #15                 run task 2
                JSR     CK_INPUT_SIZE       check that input length is between 1-8 characters
                CMP     #1,D3               is input length ok?    
                BEQ     CONTINUE_START1     length ok ,keep on reading input 
                JSR     INVALID_INP_ST       bad input length , display error and start over    
CONTINUE_START1 JSR     CONVERT             go to conversion subroutine
                JSR     MIN_MAX_CHECK       check if input is within the min& max limit for address 
                CMP.B   #1,D2               is input address within allowable interval
                BEQ     CONTINUE_START2     input is within limits, keep reading
                BNE     RD_START_INPUT      input out of limits , ask for new input
                
CONTINUE_START2 JSR     EVEN_CHECK          verify  input adress is even    
                CMP.B   #1,D2               is input address even?
                BNE     RD_START_INPUT      input not even , ask for input again
                MOVEA.L  D6,A2              start adress passed all input tests,save start address in A2
                
RD_END_INPUT    LEA     END_ADD_MSG,A1      load end address request msg
                MOVE.W  #14,D0              display string at A1
                TRAP    #15                 run task 14
                
                LEA     IN_END_A,A1     load starting adresss input from user 
                MOVE.B  #2,D0               read string from key board and store it in A1
                TRAP    #15                 run task 2
                
                JSR     CK_INPUT_SIZE       check that input length is between 1-8 characters
                CMP     #1,D3               is input length ok?    
                BEQ     CONTINUE_END1       length ok ,keep on reading input 
                JSR     INVALID_INP_ED
                
CONTINUE_END1   JSR     CONVERT             go to conversion subroutine
                JSR     MIN_MAX_CHECK       check if input is within the min& max limit for address 
                CMP.B   #1,D2               is input address within allowable interval
                BEQ     CONTINUE_END2     input is within limits, keep reading
                BNE     RD_END_INPUT  
                
CONTINUE_END2   JSR     EVEN_CHECK          verify  input adress is even    
                CMP.B   #1,D2               is input address even?
                BNE     RD_END_INPUT      input not even , ask for input again
                MOVEA.L  D6,A3              start adress passed all input tests,save start address in A2
                MOVE.L  A2,IN_START_A       copy start input to IN_START_A
                MOVE.L  A2,IN_CURR_A        copy current input to IN_CURR_A
                MOVE.L  A3,IN_END_A         copy end input to IN_END_A

                * start building the string right after the input
                * to avoid conflicts
                MOVE.L  IN_END_A,OUT_START_A
                ADDI.L  #2,OUT_START_A
                MOVE.L  OUT_START_A,OUT_CURR_A

                * it starts valid, so make IS_VALID 1
                MOVE.B  #1,IS_VALID
                
MAIN_LOOP
    JSR         CMD_IDENTIFY
    MOVE.L      IN_CURR_A,D1
    MOVE.L      IN_END_A,D2
    CMP.W       D2,D1
    BGT         END_MAIN_LOOP
    BRA         MAIN_LOOP

END_MAIN_LOOP

    * add a 00 to the very end of the output
    MOVEA.L   OUT_CURR_A,A1
    MOVE.B    #0,(A1)+

    MOVEA.L   OUT_START_A,A1
    MOVE.B    #13,D0
    TRAP      #15

    SIMHALT             ; halt simulator

* this was bisrat's old loop
* MAIN_LOOP       CMP.L   IN_CURR_A,IN_END_A     IS CURRENT LESS THAN END?               
                * BLE     IDINSRUCTION              go to idinstruction
                * simHalt



* check input string length is 1 minimum and 8 max

CK_INPUT_SIZE   MOVE.L  #0,D2               set d2 to zero 
                MOVE.L  #0,D3               set d3 to zero 
                MOVE.L  #8,D4
                CMP.W   D2,D1              IS string length zero?
                BEQ     INVALID_INP_ST      length is 0, print input error message 
                CMP.B   D4,D1             compare string length to 8
                BGT     INVALID_INP_ST       input greater than 8 chrs ,display error message
                MOVE.B  #1,D3              save 1 in d3 meaning input size is ok 
                *CLR.L   D1 
                RTS
 *print invalid input error message 
   
INVALID_INP_ST  LEA     INPUT_ERROR_MSG,A1  load input error message to A1
                MOVE.W  #14,D0              print data in d0 to screen 
                TRAP    #15                 run task 14
                BRA     RD_START_INPUT      prompt user for input again
 
INVALID_INP_ED  LEA     INPUT_ERROR_MSG,A1  load input error message to A1
                MOVE.W  #14,D0              print data in d0 to screen 
                TRAP    #15                 run task 14
                BRA     RD_END_INPUT      prompt user for input again
*convert to ASCII
CONVERT         CLR.L    D6
CNV_LOOP        CMP.B   #0,D1              are all characters of the input are converted?
                BEQ     FINISH 
                CLR.L   D4                 use cleared d4 for input storage
                MOVE.B  (A1)+,D4           save the first character input in to D4   
                CMPI.B   #$39,D4           subtract $39 from character to check if its a digit                   
                BLE     DIGIT_TO_HEX       use digit converter character is less than or equal to $39
                BGT     ALPHA_TO_HEX
FINISH          RTS                
*convert num to hex                
ALPHA_TO_HEX    SUBI.B  #$37,D4            convert alpahbet to hex number, keep it in D4
                BRA     KEEP_COUNT         manage the unconverted count 
           
*convert letters to hex
DIGIT_TO_HEX    SUBI.B  #$30,D4            convert digit to hexadecimal number , keep it in D4
                BRA     KEEP_COUNT         manage the unconverted count 
*update count  
KEEP_COUNT      ADD.B   D4,D6              save the conversion in the hex holder D6
                SUBI.B  #$1,D1             decrease the unconverted input count by 1 
                CMPI.B  #$0,D1             are we done converting all input ?
                BEQ     CNV_LOOP           we are done counting , go to convert     
                MOVE.L  #0,D5              set up D5=0 for later
                ASL.L   #4,D6              shift d4 contents left by 4 to receive next input
                ADD.B   D5,D6              adjust zeros 
                BRA     CNV_LOOP           updating the count is done go back to convert
                
* check if user input is between the interval [$7000,FFFFFE]
                
MIN_MAX_CHECK   MOVE.L  #0,D2               reset d2 to store data 
                MOVE.L  #$00007000,D2       save min input limit in d2
                CMP.L   D2,D6               is input less than min?
                BLT     BELOW_MIN_ERROR     input is less, display error msg
                MOVE.L  #$00FFFFFE,D2       save max input limit in d2
                CMP.L   D2,D6               is input greater than max?
                BGT     ABOVE_MAX_ERROR     input is higher than max
                MOVE.B  #1,D2               input checks out , mark d2=1
                RTS
*display min & max errors to console                 
BELOW_MIN_ERROR LEA     ADDR_BELOW_MSG,A1    load input address below min msg
                MOVE    #14,D0               display the string at A1
                TRAP    #15                  run task 14  
                RTS
ABOVE_MAX_ERROR LEA     ADDR_ABOVE_MSG,A1    load input address above max msg 
                MOVE    #14,D0               display the string at A1
                TRAP    #15                  run task 14 
                RTS         
*check if the input adress is even(odd not allowed)     
 
EVEN_CHECK     MOVE.L   D6,D7
                ANDI.B  #1,D7                and input with bit one 
                BEQ.S   EVEN                 input is even
                BRA     INPUT_ODD           input is odd ,display message
   
EVEN            MOVE.B   #1,D2               input is even ,mark D1=1 
                RTS                          passed even test,return to stack
                
INPUT_ODD       LEA      EVEN_CHECK_MSG,A1   load odd address enteresd msg
                MOVE    #14,D0               dispaly string at A1
                TRAP    #15                  run task 14
                
* Put variables and constants here
   * INCLUDE 'opcode_subroutine.x68'
    *INCLUDE 'ea_subroutine.x68'
    *INCLUDE 'io_subroutine.x68'
    *INCLUDE 'variables.x68'
    *INCLUDE 'strings.x68'
    INCLUDE     'CmdIdentify.X68'
                
WELCOME_MSG          dc.b    'Welcome to the MC68000 Microprocessor Disassembler',CR,LF,0   
START_ADD_MSG        dc.b    'Please enter Start memory address in hexadecimal: ',0
END_ADD_MSG          dc.b    'Please enter End address in hexadecimal(greater than start address): ',0
INPUT_ERROR_MSG      dc.b    'ERROR: Invalid address entered. Please try again.',CR,LF,0
END_ADD_SMALLER_MSG  dc.b    'ERROR: End address can not be less than starting address',CR,LF,0
ADDR_BELOW_MSG       dc.b    'ERROR: Address below minimum. enter address greater than or equal to $7000',CR,LF,0
ADDR_ABOVE_MSG       dc.b    'ERROR: Address above maximum. enter address less than or equal to $00FFFFFE',CR,LF,0
EVEN_CHECK_MSG        dc.b    'ERROR: odd address entered. please enter even address',CR,LF,0       
IN_START_A           ds.b    4        allocate 4 bytes of memory to store starting memory address input  
IN_CURR_A         ds.b    4        allocate 4 bytes of memory to store current memory address
IN_END_A             ds.b    4        allocate 4 bytes of memory to store ending memory address input
OUT_START_A          ds.b    4         allocate 4 bytes of memory to store starting program output
OUT_CURR_A          ds.b    4         allocate 4 bytes of memory to store current program output
IS_VALID            ds.b    1         allocate a byte for whether for error checking
      

    INCLUDE 'CONSTANTS.X68'

        

     *SIMHALT             ; halt simulator
     

    END    START        ; last line of source
