;
; clock.asm
;
; Created: 12/15/2023 2:35:55 PM
; Author : sepri
;
.INCLUDE "M64DEF.INC"
.ORG 0X0000
JMP MAIN
.ORG 0X0020
JMP TI0_ISR
.ORG 0X0050
MAIN:
     //// initialize
	 LDI R16,LOW(RAMEND)
     OUT SPL,R16
	 LDI R16,HIGH(RAMEND)
	 OUT SPH,R16 ;stack pointer:10ff
	 ldi r16,6    //from 6 to--> 255 ==250us (clock freq=1M) if we run 4000=40 *100 times the Timer0 then we
	              //have a 4000*250us=1s delay(timer delay) 
	 OUT TCNT0,r16
	 ldi r16,1
	 OUT TCCR0,r16 // pre scaler 1
	 OUT TIMSK,r16
	 clr r16 // for count
    ////////start
	clr r17 //for count
	clr r18
	ldi r18,0xff
	out DDRA, r18 
	out DDRB, r18
	out DDRC, r18
	clr r18
	out PORTA,r18
	out PORTB,r18
	out PORTC,r18
	clr r18 //sec
	clr r19 //min 
	clr r26 //hour
	SEI
	//while(1){}
	 here:
	 clr r30
	
	 jmp here
    //FUNCTION
	separate_number:
	 clr r23
	 cpi r22,10
	 brcs tak_ragham
	////
	 do_ragahm:
	 loop:subi r22,10
	 inc r23
	 cpi r22,10
	 brcc loop
	 mov r20,r22 //r20 ones
	 mov r21,r23 //r21 tens
	 jmp end 
	 ////
	 ////
	 tak_ragham:
	 mov r20,r22  //r20 ones
	 ldi r21,0    //r21 tens
	 jmp end
	 ////
	 end:RET
     
	 ///timer 
	 TI0_ISR:
	 ldi r25,6
	 OUT TCNT0,r25
     inc r16
	 cpi r16,40
	 brne next1
	 inc r17
	 clr r16
	 cpi r17,100
	 brne next2
	 clr r17
	 inc r18 // sec
	 cpi r18,60
	 brne next3
	 clr r18
	 inc r19 //min
	 cpi r19,60
	 brne next4
	 clr r19
	 inc r26 //h
	 cpi r26,24
	 brne next5
	 clr r26 //hour
	 clr r19 //min
	 clr r18 //sec

	 next5:
	 next4:
	 next3:
	 next2:
	 next1:
	 ////
	// displaying portA sec
	  mov r22,r18
	  call separate_number
	  clr r30
	  clr r31
      mov r30,r20
      mov r31,r21
      lsl r31
	  lsl r31
	  lsl r31
	  lsl r31
	  ADD r31,r30
      out PORTA,r31
	// displaying portB min
	  mov r22,r19
	  call separate_number
	  clr r30
	  clr r31
      mov r30,r20
      mov r31,r21
      lsl r31
	  lsl r31
	  lsl r31
	  lsl r31
	  ADD r31,r30
      out PORTB,r31
	  // displaying portC hour
	  mov r22,r26
	  call separate_number
	  clr r30
	  clr r31
      mov r30,r20
      mov r31,r21
      lsl r31
	  lsl r31
	  lsl r31
	  lsl r31
	  ADD r31,r30
      out PORTC,r31	   

	 ////
	 RETI
