*-----------------------------------------------------------
* Title      : main.X68
* Written by : bisrat belayneh
* Date       : 4/21/2017
* Description: Displays welcome, Gets start and end address of memo to be decoded ,Define Out-start-addres
                ,defines valid-flag 1 for code valid 0 for code invalid,defines constants for strt and address of the program   
                Sets out current add to out -start- add, Starts id running instruction

*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
