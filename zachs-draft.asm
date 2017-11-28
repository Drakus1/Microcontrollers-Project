#include <reg932.inc>

ORG 0000H

MOV 30H, #00H    ; Inputs to be loaded here
MOV 31H, #00H
MOV 32H, #00H
MOV 33H, #00H
MOV 34H, #00H
MOV 35H, #00H
MOV 36H, #00H
MOV 37H, #00H

MOV 38H, #00H
MOV 39H, #00H
MOV 3AH, #00H
MOV 3BH, #00H
MOV 3CH, #00H
MOV 3DH, #00H
MOV 3EH, #00H
MOV 3FH, #00H

MOV R7, #8             ; Number of input bytes (CHANGE AT START OF PROGRAM)
MOV R6, #00H           ; Where the carry bits are stored
MOV R0, #30H           ; Load the location of input
MOV TMOD, #00010000B   ; Load Timer 1 into Mode 1 to count the clock pulses.
SETB TCON.6

LCALL CARRYBITS  ; Calculate the carry bits using look-ahead logic

MOV R0, #30H
MOV R7, #8       ; CHANGE AT START OF PROGRAM

MOV 30H, #00H    ; Inputs to be loaded here
MOV 31H, #00H
MOV 32H, #00H
MOV 33H, #00H
MOV 34H, #00H
MOV 35H, #00H
MOV 36H, #00H
MOV 37H, #00H

MOV 38H, #00H
MOV 39H, #00H
MOV 3AH, #00H
MOV 3BH, #00H
MOV 3CH, #00H
MOV 3DH, #00H
MOV 3EH, #00H
MOV 3FH, #00H

MOV R1, #40H     ; The location the answer will be stored

START:
MOV A, R6        ; Load carry bits into ACC
RRC A            ; Move the proper carry bit into C
MOV R6, A

MOV A, @R0       ; Load current bytes into B and ACC  ;;
MOV B, A
MOV A, R0
ADD A, #08H
MOV R0, A
MOV A, @R0

ADDC A, B        ; Do the addition and store the answer with the carries calculated.
MOV @R1, ACC
MOV A, R0
SUBB A, #08H
MOV R0, A
INC R0
INC R1

DJNZ R7, START   ; Loop end

CLR TCON.6       ; Stop the timer
MOV A, TH1       ; Load the clock pulse count in B and A registers
MOV B, A
MOV A, TL1
SJMP OUTPUT

ORG 00AFH                  ; Memory Location 175
CARRYBITS:  MOV R7, #7     ; (CHANGE AT START OF PROGRAM (# of operands - 1))
            CLR 03H        ; initial carry-in is 0
BEGIN:                     ; loop to calculate the carry out for all bytes
        MOV R5, #8
        LOOP:                   ; loop to calculate the carry out for one byte pair
              MOV A, @R0
              RRC A
              MOV 00H, C        ; store Ai in 00H
              MOV @R0, A

              MOV A, R0
	            ADD A, #08H
	            MOV R0, A
	            MOV A, @R0
              RRC A
              MOV 01H, C        ; store Bi in 01H
              MOV @R0, A
              MOV A, R0
	            SUBB A, #08H
	            MOV R0, A

              ; Calculate Gi
              MOV C, 00H
              ANL C, 01H
              MOV 02H, C        ; store Gi in 02H

              ; Calculate Pi
              CLR A
	            MOV C, 00H
              MOV ACC.1, C      ; XOR only takes byte operands so put Ai and Bi as first bits of ACC and B
	            MOV C, 01H
              MOV B.1, C
              XRL A, B
              MOV C, ACC.1
              ANL C, 03H        ; 03H holds carry-in
              MOV 04H, C        ; store Pi in 04H

              ; Calculate Ci+1
              MOV C, 02H
              ORL C, 03H
              MOV 03H, C        ; load the carry-out as the next carry-in
              DJNZ R5, LOOP
        MOV C, 03H
        MOV A, R6
        RRC A
        MOV R6, A
        DJNZ R7, BEGIN
RET

ORG 0113H              ; Memory Location 275
OUTPUT:



END
