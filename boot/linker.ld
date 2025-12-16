ENTRY (_start)

SECTIONS
{
    /* Raspberry Pi 5 bootloader loads our image at this address */
    . = 0x80000;

    .text : {
        /* Ensure the entry point code is at the very beginning */
        KEEP(*(.text.boot))
        *(.text)
    }

    .rodata : {
        *(.rodata)
    }

    .data : {
        *(.data)
    }

    /* Align to 16 bytes for AArch64 stack requirements */
    . = ALIGN(16);
    __bss_start = .;
    .bss : {
        *(.bss)
    }
    __bss_end = .;
}