;@============================================================================
;@ Name        : bigAdd.s
;@ Written by Dakota Crozier 2021
;@ Subroutine to add large numbers stored in memory written in ARM assembly
;@ Resources: https://developer.arm.com/documentation/dui0204/j/arm-and-thumb-instructions/instruction-summary
;@ Subroutine follows C calling convention result will be stored in r0
;@ Address of the large numbers should be stored in r0,r1 and length of largest in number in words in r3

;@ Functon interface: int bigAdd(bigNumN bigN0P, const bigNumN bigN1P, unsigned int maxN0Size);
;@============================================================================

;@ Tabs set for 8 characters in Edit > Configuration

	GLOBAL	bigAdd
	AREA	||.text||, CODE, READONLY
		
bigAdd		
	;@ check for error condition
	push {r4-r11,lr}
	
	mov r10,r0
	ldr r5,[r0]
	ldr r6,[r1]
	mov r11,r5
	mov r9,#0
	cmp r5,r6
	moveq r9,#1 ;@same length
	bmi bigone
	cmp r2,r5 ;@check max size
	bmi error
	moveq r7,#0
	movne r7,#1
	subs r6,#0;@see if adding nothing
	moveq r0, #0
	beq done
	
	adds r0,#0 ;@ reset carry flag

loop0
	add r0,r0,#4 ;@increment array pointers
	add r1,r1,#4
	ldr r3,[r0];@load each word
	ldr r4,[r1]
	adcs r8,r3,r4
	str r8,[r0]
	mrs r12,CPSR ;@store possible carry from addition
	sub r5,r5,#1
	subs r6,r6,#1
	beq check0
	msr CPSR_cxsf,r12
	b loop0

check0
	msr CPSR_cxsf,r12
	movcc r0,#0
	bcc done;@no final carry
	cmp r9,#1;@see if same length if not go to last0
	bne last0 
	;@ if same length:
	cmp r7,#0;@no more room so final carry r0=1
	moveq r0,#1
	beq done 
	;@increase number of elements
	add r11,r11,#1
	str r11,[r10] 
	mov r8,#1
	add r0,r0,#4
	str r8,[r0]
	mov r0, #0
	b done
;@last 0 takes care of propegating carry into remaining r0 words
last0	msr CPSR_cxsf,r12
	add r0,r0,#4
	ldr r3,[r0]
	adcs r8,r3,#0
	str r8,[r0]
	mrs r12,CPSR;@store
	movcc r0,#0
	bcc done;@no final carry
	subs r5,r5,#1
	bne last0
	
	cmp r7,#0;@no more room so final carry r0=1
	moveq r0,#1
	beq done
	;@increase number of elements
	add r11,r11,#1
	str r11,[r10] 
	mov r8,#1
	add r0,r0,#4
	str r8,[r0];@ add carry in next word 
	mov r0, #0
	b done

bigone ;@ if r1 contains the bigger array
	cmp r2,r6
	bmi error
	moveq r7,#0
	movne r7,#1
	subs r5,#0;@see if length is 0
	beq last1
	adds r0,#0 ;@ reset carry flag
loop1	
	add r0,r0,#4
	add r1,r1,#4
	ldr r3,[r0];@load each word
	ldr r4,[r1]
	adcs r8,r3,r4
	str r8,[r0]
	mrs r12,CPSR
	sub r6,r6,#1
	subs r5,r5,#1
	beq check1
	msr CPSR_cxsf,r12;@load
	b loop1



check1
	msr CPSR_cxsf,r12
	cmp r9,#1;@see if same length
	bne last1

	cmp r7,#0;@no more room so final carry r0=1
	moveq r0,#1
	beq done
	;@increase number of elements
	add r11,r11,#1
	str r11,[r10] 
	mov r8,#1
	add r0,r0,#4
	str r8,[r0]
	mov r0, #0
	b done
;@last1 takes care of propegating carry and copying elements to r0 
last1	msr CPSR_cxsf,r12
	;@increase number of elements
	add r11,r11,#1
	str r11,[r10] 
	add r0,r0,#4
	add r1,r1,#4
	ldr r4,[r1]
	adcs r8,r4,#0
	str r8,[r0]
	mrs r12,CPSR;@store possible carry
	subs r6,r6,#1
	bne last1
	msr CPSR_cxsf,r12
	movcc r0,#0
	bcc done;@no final carry
	
	cmp r7,#0;@no more room so final carry r0=1
	moveq r0,#1
	beq done
	;@increase number of elements
	add r11,r11,#1
	str r11,[r10] 
	mov r8,#1
	add r0,r0,#4
	str r8,[r0]
	mov r0, #0
	
	b done

error	mov r0,#-1
	pop{r4-r11,lr}
	mov	pc, lr
	
done	pop{r4-r11,lr}
	mov	pc, lr
	END
