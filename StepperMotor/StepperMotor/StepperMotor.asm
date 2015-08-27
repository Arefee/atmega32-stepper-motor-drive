/*
 * StepperMotor.asm
 *
 *  Created: 09/08/2015 10:15:08
 *   Author: sensei
 */  

 rjmp start
 turn: .db 0x01,0x03,0x02,0x06,0x04,0x0c,0x08,0x09;
   	   .db 0x09,0x08,0x0c,0x04,0x06,0x02,0x03,0x01;
.equ turnsize = 0

 START:
	ldi r16, low(RAMEND)
	out spl, R16
	LDI r16, HIGH(RAMEND)
	out SPH, R16			; intialize stack pointer

	ldi r16, 0xff
	out DDRA, r16			;set port A as output

	ldi r16, 0x00
	out DDRD, r16			;set port D as input

init:	
	ldi ZL, low(turn)
	ldi ZH, high(turn);Z
	ldi r22, turnsize	;reinitialize					;start clockwise
	in r16, PIND
	SBRS r16,7			;check if clockwise/anticlockwise selected
	adiw zl,8

loop:
	lpm r16,Z+
	out portA, r16		; output data
	rcall pause
	inc r22				;increase step count
	cpi r22, 9			;check if stepcount is equal to 9
brne loop

rjmp init


PAUSE:
	in  r23, PIND
	LDI R16, 0x02
	SBRS r23,5
	LDI R16, 0x03 
	OUT TCCR0, R16			; SETS PRESCALER OF 10248 bit timer
COMPARE: 
	IN R16, TIFR ;check timer
	ANDI R16, 0X01; tov0 flag bit 
	BREQ COMPARE ; branches when overflow has not occured. This is due to nature of and 	
	LDI R16, 0X01
	OUT TIFR, R16 ; clear the timer overflow flag by writing one
RET



