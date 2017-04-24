* ------------------------------------------------------------------------------
* CONSTANTS
* VERSION 1 (23 APR 2017)
* Written by James Winters
* ------------------------------------------------------------------------------

BAD_COMMAND_STR DC.B  'DATA $',0

NOP_STR DC.B  'NOP',$0A,$0D,0
NOP_S   EQU   $4E71
NOP_P   EQU   $FFFF

MOVE_STR  DC.B  'MOVE',$0A,$0D,0
MOVE_S    EQU   $0000
MOVE_P    EQU   $C000
