# wdr
The **WDR Paper Computer** is a simple educational
computer model designed to teach the fundamentals
of computer architecture and assembly language.
It was introduced by **Wolfang D. Rautenberg**
in the 1980s and it's a useful learning tool for
low-level programming concepts.

More details: [Paper Computer on XXIIVV wiki](https://wiki.xxiivv.com/site/paper_computer.html)


# wdre, aka this implementation

While the **WDR Paper Computer** was originally designed as
a purely **paper-based** tool, this project brings it into
the **digital realm** using **Lua**.

The goal is not to replace the original learning experience
but rather to use WDR as a foundation for exploring **computer
architecture, assembly language, and low-level programming concept**
in a more interactive way.

# Assembly
The WDRE assembly language is a minimalistic intruction set.
Unlike the original WDR Paper Computer, which uses line numbers for jumps
and data manipulation, WDRE operates with memory addresses. This expanded
version introduces RAM and additional instructions for working with it.

Register 0 servers as a memory address pointer, while register 1 is used to
store or retrieve data from RAM.

This implementation limits the number of registers to 4: 0, 1, 2 and 3.

## Instruction Set
- `INC REG` - Increments the value of register `REG`
- `DEC REG` - Decrements the value of register `REG`
- `LD0 ARG` - Load the value `ARG` into register 0
- `LDR` - Loads into register 1 the value stored in memory at the address specified by register 0
- `STR` - Stores the value of register 1 into memory at the address specified by register 0
- `ISZ REG` - If register `REG` is 0, skip the next instruction; otherwise, execution continues normally.
- `JMP ARG` - Sets the program counter to `ARG`
- `STP` - Stops program execution

## wasp - the assembler
wasp is the assembler used for the WDRE implementation. It converts the assembly code in machine-readable
instructions that can be executed by the WDRE.

- Comments: anything starting from `;` to the end of the row is considered a comment and will be ignored
during the assembly process.
- Labels: you can define label  using the syntax `LABEL:`. Labels are useful for
specifying jump target

Example:
```assembly
; This is a comment
START:
	LD0 10 		; Load the value 10 into register 0
	JMP START 	; Jump back to START
```
