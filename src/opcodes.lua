local debug = DEBUG or false

local opcode = {

	[0x00] = { -- increment register n
		m = "INC",
		s = 2,
		f = function()
			local reg = memory[pc + 1]
			register[reg] = register[reg] + 1
			if(debug) then print(string.format("%d: INC reg %d", pc, reg)) end
		end
	},
	[0x01] = { -- decrement register n
		m = "DEC",
		s = 2,
		f = function()
			local reg = memory[pc + 1]
			register[reg] = register[reg] - 1
			if(debug) then print(string.format("%d: DEC reg %d", pc, reg)) end
		end
	},
	[0x02] = { -- load value into register 0
		m = "LD0",
		s = 2,
		f = function()
			register[0] = memory[pc + 1]
			if(debug) then print(string.format("%d: LD0 %d", pc, register[0])) end
		end
	},
	[0x03] = { -- load ram value at address in register 0 into register 1
		m = "LDR",
		s = 1,
		f = function()
			local address = register[0]
			register[1] = ram[address]
			if(debug) then print(string.format("%d: LDR reg1 %d from ram @%d", pc, register[1], address)) end
		end
	},
	[0x04] = { -- store the value in register 1 into ram at address in register 0
		m = "STR",
		s = 1,
		f = function()
			local address = register[0]
			ram[address] = register[1]
			if(debug) then print(string.format("%d: STR ram @%d with %d", pc, address, register[1])) end
		end
	},
	[0x10] = { -- if register n is 0 ingore the next instruction
		m = "ISZ",
		s = 2,
		f = function()
			local reg = memory[pc + 1]
			local _pc = pc
			if register[reg] == 0 then
				pc = pc + 2
			end
			if(debug) then print(string.format("%d: ISZ %d", _pc, reg)) end
		end
	},
	[0x11] = { -- move the pc to the memory address n
		m = "JMP",
		s = 0,
		f = function()
			local inc = memory[pc + 1]
			local _pc = pc
			pc = inc
			if(debug) then print(string.format("%d: JMP to %d", _pc, inc)) end
		end
	},
	[0xFF] = { -- stop the execution of the program
		m = "STP",
		s = 1,
		f = function()
			state = false
			if(debug) then print(string.format("%d: STP", pc)) end
		end
	}
}

return opcode
