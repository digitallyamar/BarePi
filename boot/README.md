# Notes

## How to prepare your SD Card to run baremetal programs on Raspberry Pi

Note: This is currently only tested Raspberry Pi 5 4GB.

- Format your SD Card to FAT32 format.
- Raspberry Pi 5 bootloader does all the initialization from the VPU core while keeping ARM cores hanging.
- Raspberry Pi 5 bootloader is by default designed to boot a Linux kernel image. 
- When it finds FAT32 partition in a select BOOT device such as an SD Card, it checks primarily for two files:
    1. Linux kernel image file named kernel_2712.img. Here 2712 is derived from the SOC number used in the Raspberry Pi 5 board.
    2. A device tree blob file ending with .dtb extension. This provides hardware info for the board.
    3. If dtb is not found, it expects a configuration file called config.txt to be present with an entry **os_check=0** to tell the bootloader that it should not check for an OS as this is going to be a bare metal boot operation. 
- Since we are doing bare metal programming here, we **must** have **config.txt** file present along with our binary output image named **kernel_2712.img**.




 

## Content of FAT32 formatted SD Card ready for booting

    1. kernel_2712.img: Linux kernel image file.
    2. config.txt: Configuration file to tell the bootloader that it should not check for an OS as this is going to be a bare metal boot operation.


## How to build the code

We provide a Makefile to build the binary image file and also to delete the files during fresh rebuilds. The commands to build and clean are as follows:

```
make clean  # This will delete old generated files
make    # This will generate the output files 
```

Once built, you should be able to see kernel_2712.img file generated. Copy this file along with config.txt to your FAT32 formatted SD Card and you are good to go.

Connect the SD Card to your Raspberry Pi and boot the device. Your green ACT LED should start blinking after some time.