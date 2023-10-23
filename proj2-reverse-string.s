// Take an input string and use recursion to print the string \n + the reverse of the string.

.section .data
input_prompt: .asciz "Please enter a string: \n"
input_format: .asciz "%[^\n]"
output_format: .asciz "%c"
new_line_format: .asciz "\n"

.section .text
.global main

main:
    // Load prompt string + print
    ldr x0, =input_prompt
    bl printf

    // Create stack space + store return address
    sub sp, sp, #16
    stur x30, [sp, 8]

    // Prepare for scanf + read user input string
    mov x1, sp
    ldr x0, =input_format
    bl scanf

    // Set base address of string + initialize index in x3
    mov x2, sp
    mov x3, #0

    // Begin recursion
    bl recursivefunction

    // Print newline
    ldr x0, =new_line_format
    bl printf

    // Restore return address, clear stack, branch to exit
    ldur x30, [sp, 8]
    add sp, sp, #16
    b exit

recursivefunction:
    // Decrement stack to next frame + store base string, current index, return address
    sub sp, sp, #24
    stur x3, [sp, #0] // current index
    stur x2, [sp, #8] // base address of input string
    stur x30, [sp, #16] // return address of stack frame

    // Load next char (current index + string base), basecase if null terminator
    ldrb w4, [x2, x3]
    cbz w4, basecase

    // Print char (for recursive forward order)
    mov x1, x4
    ldr x0, =output_format
    bl printf

    // Restore variables + increment index
    ldur x3, [sp, #0]
    ldur x2, [sp, #8]
	ldur x30, [sp, #16]
    add x3, x3, #1  //increment index by 1

    // Recursive call
    bl recursivefunction

	// The following is executed as recursions unravel
    // Restore variables, load + print char (reverse order)
    ldur x3, [sp, #0]
    ldur x2, [sp, #8]
    ldrb w4, [x2, x3]
    mov x1, x4
    ldr x0, =output_format
    bl printf

    // Restore return address, increment stack to prior frame, return
    ldur x30, [sp, #16]
    add sp, sp, #24
    br x30

basecase:
    // Store variables
    stur x3, [sp]
    stur x2, [sp, #8]
    stur x30, [sp, #16]

    // Print newline (after forward print, before reverse print)
    ldr x0, =new_line_format
    bl printf

    // Restore variables, increment stack (to not print \0), return
    ldur x3, [sp]
    ldur x2, [sp, #8]
    ldur x30, [sp, #16]
    add sp, sp, #24
	
    br x30

exit:
    // Exit code, system call, return
    mov x0, #0
    mov x8, #93
    svc #0
    ret
