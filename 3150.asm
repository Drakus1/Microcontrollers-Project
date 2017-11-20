#include <reg932.inc>

MOV 301H, #00H; Inputs to be loaded here
MOV 302H, #00H
MOV 303H, #00H
MOV 304H, #00H
MOV 305H, #00H
MOV 306H, #00H
MOV 307H, #00H
MOV 308H, #00H

MOV 309H, #00H
MOV 30AH, #00H
MOV 30BH, #00H
MOV 30CH, #00H
MOV 30DH, #00H
MOV 30EH, #00H
MOV 30FH, #00H
MOV 310H, #00H

MOV R1, #311H; The location the answer will be stored

MOV R7, #8;The number of input bytes here

;I don't know how to calculate carry bits

MOV R6, #00H;Load the carry bits here
MOV R0, #300H;Load the location of the input

START:
MOV A, R6;Load carry bits into A
RRC A; move the proper carry bit into C
 
MOV A, @R0;load current bytes into R2 and A
MOV R2, A
ADD R0, #09H
MOV A, @R0
SUB R0, #09H
INC R0

ADDC A, R2;do the addition and store the answer
MOV @R1, A
INC R1

DJNZ R7, START;loop end

;calculate the number of cycles the addition took

;Output all of the calculated data. Serial output?
