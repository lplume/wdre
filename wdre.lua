-- args init
local args = {}
local file = nil

for i = 1, #arg do
	local key, value = arg[i]:match("^%-([^%d=]+)(%d*)$")
	if key and value then
		args[key] = value
	else
		file = arg[i]
	end	
end

-- registers and memory init
local nregisters 	= args['r'] or 8
local nmemory 		= args['m'] or 21

local register = {}
local memory = {}
local pc = 1
local state = 1

for i = 1, nregisters do
	register[i] = 0
end

for i = 1, nmemory do
	memory[i] = nil
end

register[1] = 3
register[2] = 2

-- opcodes
local oc = {
	[0x00] = function() -- INC
		local reg = memory[pc + 1]
		register[reg] = register[reg] + 1
		return 2
	end,
	[0x01] = function() -- DEC
		local reg = memory[pc + 1]
		register[reg] = register[reg] - 1
		return 2
	end,
	[0x02] = function(reg) -- ISZ
		local reg = memory[pc + 1]
		local inc = 2
		if register[reg] == 0 then
			inc = 4
		end
		return inc
	end,
	[0x03] = function() -- JMP
		local addr = memory[pc + 1]
		return (pc - ((addr * 2) - 1)) * -1
	end,
	[0x04] = function() -- STP
		state = false
		return 0
	end
}

-- load rom into memory
local rom = io.open(file, "rb"):read("*a")

for i=1, #rom do
	local ins = string.byte(rom, i)
	table.insert(memory, ins)
end

-- eval loop
while state do
	ins = memory[pc]
	local inc = 0
	
	if oc[ins] then
		inc = oc[ins]()
	end

	pc = pc + inc
end

-- register dump
for i=1, #register do
	print(string.format("Register %d: %d", i, register[i]))
end
