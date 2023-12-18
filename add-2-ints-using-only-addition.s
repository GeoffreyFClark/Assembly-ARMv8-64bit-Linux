// Write an ARM program that takes two integers as input, x and y, and calculates x*y using only addition.  Convert the following C code into ARM:

// int main()
// {
//     int x, y, result=0;

//     //read x
//     printf("Please enter x: ");
//     scanf("%d", &x);
//     //read y
//     printf("Please enter y: ");
//     scanf("%d", &y);

//     if (y<0)
//     {
//             x=0-x;
//             y=0-y;
//      }

//     for (int counter=0; counter<y; counter++)
//     {
//         result+=x;
//     }
//     printf("x*y =  %d\n",result);
//     return 0;
// }

.section .data

input_x_prompt: .asciz "Please enter x: "
input_y_prompt: .asciz "Please enter y: "
input_spec: .asciz "%d"
result: .asciz "x*y = %d\n"

.section .text

.global main

main:
    // create room on stack for x and y (4 bytes each) - practice using stack
    sub sp, sp, 8

    // display x prompt
    ldr x0, = input_x_prompt  // Loads address of input_x_prompt string into x0
    bl printf  // Calls printf to display (first) argument from x0 register

    // get x input value
    ldr x0, =input_spec  // Loads address of input_spec string into x0. This string contains %d to read user's input integer
    add x1, sp, 0  // Sets x1 register to point to stack position for x
    bl scanf  // Calls scanf to read user's input integer and store in the address pointed to by x1
    ldrsw x19, [sp]  // Loads signed word value from the address pointed to by sp into x19

    // display y prompt
    ldr x0, = input_y_prompt
    bl printf

    // get y input value
    ldr x0, = input_spec
    add x1, sp, 4
    bl scanf
    ldrsw x20, [sp, 4]

    // Set result at x21 to 0
    mov x21, 0 

    // Check if y is negative
    cmp x20, 0  // Compares x20 with 0
    blt flip_signs  // (Branch if less than) to flip_signs, if x20's y < 0
    b loop_start // Else branch to loop_start if y >= 0

    // Flip signs of both x and y
    flip_signs:
        neg x19, x19
        neg x20, x20
    
    // Start loop to add x to result, y times
    loop_start:
        subs x20, x20, 1  // Decrement y by 1
        blt loop_end  // (Branch if less than) Terminate loop once y < 0
        add x21, x21, x19  // Add x to result
        b loop_start

    // Print result
    loop_end:
        ldr x0, =result  // Loads address of formatted result string into x0
        mov x1, x21  // Moves value of result from x21 into x1
        bl printf  // Calls printf on first and second arguments from x0 and x1
        b exit

// Program termination
exit:
    add sp, sp, 8  // Clear up stack
    mov x0, 0  // reset x0 to 0
    mov x8, 93  // exit system call number
    svc 0  // supervisor call 0 to terminate program
    ret
    