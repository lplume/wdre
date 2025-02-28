-- wasp input [output.rom]

if #arg == 0 then
	print([[
wasp - an assambler for WDRe (WDR expanded Paper Computer)
Usage: wasp input [output.rom]

  input		Source file to assemble
  output.rom	(Optional) Output file, default: output.rom

Examples:
	wasp source.asm
	wasp source.asm image.rom

Error: no input file specified.
]])
	os.exit(1)
end

local input = io.open(arg[1], 'r')
local output = io.open(arg[2] or "output.rom", "wb")


local _opc = require("src.opcodes")
local opcode = {}
for code, data in pairs(_opc) do
	opcode[data.m] = code
end

local bytecodes = {}
local labels = {}
local labels_at = {}
local address = 0

for line in input:lines() do
	line = line:gsub(";.*", "")
	for token in line:gmatch("[^%s]+") do
		if token:sub(-1) == ':' then -- is a label definition
			labels[token:sub(1, #token - 1)] = address
		elseif type(tonumber(token)) == "number" then
			table.insert(bytecodes, token)
			address = address + 1
		else
			if opcode[token] ~= nil then
				table.insert(bytecodes, opcode[token])
				address = address + 1
			else
				table.insert(bytecodes, token)
				table.insert(labels_at, address)
				address = address + 1
			end
		end
	end
end

-- second pass
for k, label in ipairs(labels_at) do
	bytecodes[label + 1] = labels[bytecodes[label + 1]]
end

output:write(string.char(table.unpack(bytecodes)))
output:close()
