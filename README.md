# The Very Gameboy Emulator #

[Current Repo](https://github.com/geky/gb)

The Very Gameboy Emulator, as I'm calling it, is a functional
implementation of the original Nintendo Gameboy in Verilog targeting
the [Cyclone V GX](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=167&No=830). 
The Emulator communicates over UART for controller input and displays
the Gameboy's graphics over HDMI along with the Gameboy's audio. The 
Emulator was implemented for CS 350c, the Advanced Computer Architecture 
class taught by Professor Ahmed Gheith at UT.

Unfortunately, the emulator not completely accurate and has a few major 
limitations. The biggest limitation currently is the restriction to 
512kbyte roms or less due to the size of the external SRAM and lack of
functioning DDR controller. Additionally, battery backed RAM is not fully
implemented, which both prevents saving, and can cause very interesting
artifacts on games that expect a consistent initial state.

For a more depth explanation of how the Gameboy is implemented, feel free
to look at the [Report](REPORT.md) required for the class.

## Instructions ##

These quick instructions are going to assume you are already able to load
images onto the Cyclone V.

First, you will need to connect the board over HDMI and run the initial 
image until the test picture is displayed. This is due to the HDMI chip 
needing several I2C registers initialized which would require significant
overhead to take care of in the emulator.

Next, you should be able to load the emulator's image onto the board. The 
screen should appear slightly greenish, and the state machine shown on the 
7-seg displays should initialize to the default state "0041"

Several switches are used to configure the running emulator:
```
 Switches           
[9 8 7 6 5 4 3 2 1 0]
 | | | | | | \-----/- Used to select the current display on the 7-segs
 | | | | | \- 1/16th clock
 | | | | \- 1/8th clock
 | | | \- 1/4th clock
 | | \- normal clock
 | \- 2x clock
 \- enable flashing
```

To run the emulator at normal speed, you will want to enable only switch 7.
If no rom has been flashed, you should see a corrupted square slide down the 
screen. This is actually normal behaviour for the original Gameboy.

To flash the emulator with a rom, you will need to enable switch 9. If you 
leave the emulator itself running, very strange things can happen, so it is
suggested to leave the other switches disabled. You should then plug the board
to a Linux machine over a USB cable and connect through UART. The "gbflash"
script can then be used to flash the Emulator with a Gameboy rom. The offset
and size of the ROM must be specified in hexadecimal. These can be found by
using the hexdump command on the rom itself. The following commands can be 
used assuming the device appears as /dev/ttyUSB0.
``` bash
sudo chmod 777 /dev/ttyUSB0
stty -F /dev/ttyUSB0 115200
./scripts/gbflash.py 0 80000 rom.gb /dev/ttyUSB0
```

To send controller input over UART, the "controls" script can be used as 
long as an xsession is currently running.
``` bash
./scripts/controls.py /dev/ttyUSB0
```

By default controls are mapped as such, although this can easily be changed
by modifying the python script to use different PyGame key values.

- Up/Left/Down/Right = W/A/S/D
- A/B = Enter/Quote
- Start/Select = Space/E

## Debugging ##

There are several displays to assist with debugging. First the leds on the
board can be used to get a large amount of information of the processor state
```
 Red LEDS
[9 8 7 6 5 4 3 2 1 0]
 | | | | |       \-/- PPU Display mode
 | | | | \- VBlank interrupt
 | | | \- Display status interrupt
 | | \- Timer interrupt
 | \- Link cable interrupt
 \- Joypad interrupt

 Green LEDS
[7 6 5 4 3 2 1 0]
 | | | | \-/ \-/- CPU load and store signals
 | | | |  \- DMA load and store signals
 | | | \- Carry flag
 | | \- Half-carry flag
 | \- Subtraction flag
 \- Zero flag
```

Additionally, the 4 on board 7-segs can display a 16-bit hex value specified
by the lowest 4 switches
- 0000 = State machine state
- 0100 = Timer value
- 1000 = AF Register pair
- 1001 = BC Register pair
- 1010 = DE Register pair
- 1011 = HL Register pair
- 1100 = Stack Pointer
- 1101 = Program Counter

Finally, the link cable is transmits all written data through the UART
connection and can be monitored like so.
``` bash
screen /dev/ttyUSB0 115200
```

## Resources ###

The following are very useful resources for Gameboy information and are really
what made this project possible.

- [Opcode Listing](http://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html) A very useful listing of the LR35902 instructions
- [Gameboy Manual](http://marc.rawer.de/Gameboy/Docs/GBCPUman.pdf) Documentation on the Gameboy for writing software which covers the expected functionality.
- [Gameboy Dev Wiki](http://gbdev.gg8.se/wiki/articles/Main_Page) A collection of important information regarding the Gameboy for emulation.
