// --- Hardware Constants ---
// GIO_AON (Always-On GPIO) Base for BCM2712
.equ GIO_AON_BASE,    0x107D517C00

// Register Offsets within the GIO_AON block
.equ GIO_DATA,        0x04    // Register to Read/Write pin state
.equ GIO_IODIR,       0x08    // Register to set Input (1) or Output (0)

// Pin Definitions
.equ ACT_LED_PIN,     9       // Pi 5 Activity LED is on AON_GPIO 9
.equ LED_BIT,         (1 << ACT_LED_PIN)

// Delay Constant
.equ DELAY_VAL,       0x1F0000


    //  Tell assembler that this is the Beginning of boot code section.

    .section ".text.boot"

   // To run this code as an executable file, we need to export atleast
    // one function to the system linker as an entry point to our code.
    // Any symbol in assembly code is usually local, so we need to export
    // atleast one global function for the linker to use as an entry point.

    .global _start

    // (ARM instruction set needs to be on a 32-bit (4-byte) boundary).
    // Align the following code on a 4-byte boundary as reqd by ARM CPU

    .align 2

_start:
    // We will be blinking ACT LED of the Raspberry Pi 5 to signal
    // that our program is loaded and executing.

    // Raspberry Pi 5 uses RP1 controller chip to control GPIO pins 
    // via PCIe bus. The built-in ACT LED of the Raspberry Pi 5 
    // is connected to AON_GPIO of the gpio_aon (GPIO Always ON) block.

    // The true 64-bit base physical address for the AON GPIO block 
    // is 0x107D510000.
    // Adding offset to this base address, we get the final address as 
    // 0x107D517C00 for accessing it's GPIO data and direction registers.

    // Load the base address of the GPIO control registers
    ldr x0, =GIO_AON_BASE

    /* 
       1. Set ACT_LED_PIN as OUTPUT 
       Note: In this specific register, 0 = Output, 1 = Input.
    */
    ldr w1, [x0, #GIO_IODIR]    // Read current direction register
    and w1, w1, #~LED_BIT       // Clear bit 9 to set it as OUTPUT
    str w1, [x0, #GIO_IODIR]    // Write back to register

loop:
    /* 2. Turn LED ON (Set Pin High) */
    ldr w1, [x0, #GIO_DATA]     // Read current data
    orr w1, w1, #LED_BIT        // Set bit 9
    str w1, [x0, #GIO_DATA]     // Write to hardware
    
    mov x2, #DELAY_VAL
    bl  delay

    /* 3. Turn LED OFF (Set Pin Low) */
    ldr w1, [x0, #GIO_DATA]     // Read current data
    and w1, w1, #~LED_BIT       // Clear bit 9
    str w1, [x0, #GIO_DATA]     // Write to hardware
    
    mov x2, #DELAY_VAL
    bl  delay

    b   loop                    // Repeat forever

// Simple busy-wait delay function
// Expects iteration count in x2
delay:
1:  subs x2, x2, #1
    bne  1b
    ret
