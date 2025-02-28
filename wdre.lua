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

-- debug
DEBUG = args['d'] or false

-- memory init
local nmemory = args['m'] or 256
local nram = args['r'] or 256

register = {}
memory = {}
pc = 0
state = true

for i = 0, 3 do
	register[i] = 0
end

for i = 0, nmemory do
	memory[i] = nil
end

local oc = require("src.opcodes")

-- load rom into memory
local rom = io.open(file, "rb"):read("*a")

for i=1, #rom do
	local ins = string.byte(rom, i)
	memory[i - 1] = ins
end

-- eval loop
while state do
	ins = memory[pc]
	local inc = 0

	local current = oc[ins]	
	if current then
		current.f()
	else
		os.exit()
	end

	pc = pc + current.s
end

-- register dump
for i=0, #register do
	print(string.format("Register %d: %d", i, register[i]))
end
