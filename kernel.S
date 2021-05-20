.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

#define A #7
#define B #2
#define C #3

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector

vtable_kernel:
	.word __stack_start
	.word __kernel_reset__+1
	.size vtable_kernel, .-vtable_kernel

.section .rodata

	data: .asciz "kernel started!\n"
	final: .asciz "Result value in register #3: "
    
.section .text

__kernel_reset__:
	ldr r0, =data
	bl dbgput_line

// calculate
	mov r2, A		// A
	mov r3, B		// B
	mul r3, r2		// A * B
	mov r4, 10		// 10
	cmp r3, r4		// A * B ||| 10
	
ITE	GE
	orrGE r3, r2, B	// A | B
	andLT r3, r2, B	// A & B
	
	mov r4, C		// C
	mul r3, r4		// (A [] B) * C

	ldr r0, =final
	bl dbgput
	mov r0, r3
	bl dbgput_num
    
end:
	b end
