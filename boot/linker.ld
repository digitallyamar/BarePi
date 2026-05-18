ENTRY (_start)

SECTIONS
{
    /* 
     * =========================================================================
     * RASPBERRY PI 5 BARE-METAL PHYSICAL MEMORY MAP
     * =========================================================================
     *
     *  Physical RAM Address      Memory Region / Linker Section
     *  ────────────────────      ──────────────────────────────
     *  0x00000000            ┌────────────────────────────────────┐
     *                        │ Reserved for Bootloader Firmware   │
     *                        │ & Low-Level ARM Architecture Stubs │
     *                        │ (Size: 2 MB)                       │
     *  0x00200000            ├────────────────────────────────────┤ <── Linker Base (.)
     *                        │ .text.boot (Startup Assembly Code) │
     *                        │ .text      (Compiled C/C++ Code)   │
     *                        ├────────────────────────────────────┤
     *                        │ .rodata    (Read-Only Constants)   │
     *                        ├────────────────────────────────────┤
     *                        │ .data      (Initialized Variables) │
     *                        ├────────────────────────────────────┤ <── 16-Byte Aligned
     *                        │ .bss       (Zero-Init Variables)   │ <── __bss_start
     *                        │                                    │ <── __bss_end
     *                        ├────────────────────────────────────┤
     *                        │ Free RAM Space for Stack / Heap    │
     *                        └────────────────────────────────────┘
     *
     * =========================================================================
     * ARCHITECTURAL & HARDWARE DESIGN NOTES
     * =========================================================================
     * 1. BASE ADDRESS (0x200000): 
     *    Older 64-bit Pi models (Pi 3/4) booted at 0x80000. The Pi 5's BCM2712 
     *    bootloader updates this baseline to 0x200000 (2 MB) to leave room for 
     *    system firmware. This base address ensures our linker address 
     *    calculations perfectly match physical reality when global C variables 
     *    are introduced.
     *
     * 2. SECTION ISOLATION (.text vs .rodata):
     *    We split executable code (.text) from data constants (.rodata) to allow 
     *    modern MMU memory protection (marking data as Non-Executable to block 
     *    exploits) and to optimize distinct CPU L1 Instruction/Data caches.
     *
     * 3. ALIGN(16):
     *    The AArch64 (ARM64) architecture strictly requires 16-byte alignment 
     *    for stack operations and high-performance memory bus access.
     */

    . = 0x200000;

    .text : {
        /* Force bootloader entry point to sit at the absolute front of the binary */
        KEEP(*(.text.boot))
        *(.text)
    }

    .rodata : {
        *(.rodata)
    }

    .data : {
        *(.data)
    }

    /* Aligning the allocation boundary to satisfy 64-bit hardware standards */
    . = ALIGN(16);
    __bss_start = .;
    .bss : {
        *(.bss)
    }
    __bss_end = .;
}
