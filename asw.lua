local input = io.open(arg[1], 'r'):read("*a")
local output = io.open(arg[2] or "output.rom", "wb")

local oc = {
	INC = 0x00,
	DEC = 0x01,
	ISZ = 0x02,
	JMP = 0x03,
	STP = 0x04
}

local bytecodes = {}

for token in string.gmatch(input, "[^%s]+") do
	local current = nil
	if oc[token] then
		current = oc[token]
		table.insert(bytecodes, current)
		if current == oc.STP then
			table.insert(bytecodes, 0x00)
		end
	elseif tonumber(token) then
		current = tonumber(token)
		table.insert(bytecodes, current)
	else
		print(string.format("Unrecognized token \"%s\".", token))
		output:close()		
		os.exit(0)
	end
end

output:write(string.char(table.unpack(bytecodes)))
output:close()
