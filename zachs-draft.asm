#include <reg932.inc>

ORG 0000H

MOV 301H, #00H    ; Inputs to be loaded here
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

MOV R7, #8       ; Number of input bytes (CHANGE AT START OF PROGRAM)
MOV R6, #00H     ; Where the carry bits are stored
MOV R0, #301H    ; Load the location of the input

LCALL CARRYBITS  ; Calculate the carry bits using look-ahead logic

MOV R0, #301H
MOV R7, #8       ; CHANGE AT START OF PROGRAM

MOV 301H, #00H   ; Inputs to be re-loaded here
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

MOV R1, #311H    ; The location the answer will be stored

START:
MOV ACC, R6      ; Load carry bits into ACC
RRC ACC          ; Move the proper carry bit into C
MOV R6, ACC

MOV ACC, @R0     ; Load current bytes into R2 and ACC
MOV R2, ACC
ADD R0, #08H     ; Get the operand to add to R2
MOV ACC, @R0
SUB R0, #08H
INC R0

ADDC ACC, R2     ; Do the addition and store the answer with the carries calculated.
MOV @R1, ACC
INC R1

DJNZ R7, START   ; Loop end

; Calculate the number of cycles the addition took

; Output all of the calculated data. Serial output?

ORG 0100H
CARRYBITS:  MOV R7, #7     ; (CHANGE AT START OF PROGRAM (# of operands - 1))
            CLR 03H        ; initial carry-in is 0
BEGIN:                     ; loop to calculate the carry out for all bytes
        MOV R5, #8
        LOOP:  ; loop to calculate the carry out for one byte pair
              MOV ACC, @R0
              RRC ACC
              MOV 00H, C ; store Ai in 00H
              MOV @R0, ACC
              ADD R0, #08H
              MOV ACC, @R0
              RRC ACC
              MOV 01H, C ; store Bi in 01H
              MOV @R0, ACC
              SUBB R0, #08H

              ; Calculate Gi
              MOV C, 00H
              ANL C, 01H
              MOV 02H, C ; store Gi in 02H

              ; Calculate Pi
              CLR ACC
              SETB ACC.1, 00H   ; XOR only takes byte operands
              CLR B             ; so put Ai and Bi as first bits of ACC and B
              SETB B.1, 01H
              XRL ACC, B
              MOV C, ACC.1
              ANL C, 03H        ; 03H holds carry-in
              MOV 04H, C        ; store Pi in 04H

              ; Calculate Ci+1
              MOV C, 02H
              ORL C, 03H
              MOV 03H, C        ; load the carry-out as the next carry-in
              DJZN R5, LOOP
        MOV C, 03H
        MOV ACC, R6
        RRC ACC
        MOV R6, ACC
        DJNZ R7, BEGIN
RET
