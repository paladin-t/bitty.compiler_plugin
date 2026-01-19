--[[
BF compiler for the Bitty Engine

Copyright (C) 2021 - 2026 Tony Wang, all rights reserved

Homepage: https://paladin-t.github.io/bitty/
]]

-- Based on https://github.com/prapin/LuaBrainFuck.
local interpreter = 'local output = \'\'\n' ..
	'local input_ = function()\n' ..
	'	local i = input()\n' ..
	'	return i and i:byte(1) or 0\n' ..
	'end\n' ..
	'local function interpret(s)\n' ..
	'	local subst = {["+"]="v=v+1 ", ["-"]="v=v-1 ", [">"]="i=i+1 ", ["<"]="i=i-1 ",\n' ..
	'		["."] = "w(v)", [","]="v=r()", ["["]="while v~=0 do ", ["]"]="end "}\n' ..
	'	local env = setmetatable({ i=0, t=setmetatable({},{__index=function() return 0 end}),\n' ..
	'		r=function() return input_() end, w=function(c) output=output..string.char(c) end },\n' ..
	'		{__index=function(t,k) return t.t[t.i] end, __newindex=function(t,k,v) t.t[t.i]=v end })\n' ..
	'	load(s:gsub("[^%+%-<>%.,%[%]]+",""):gsub(".", subst), "brainfuck", "t", env)()\n' ..
	'	print(output)\n' ..
	'end\n'

-- Compiles from an asset.
function compile(asset)
	if not asset then
		error('Invalid asset.')
	end

	local bytes = Project.main:read(asset)
	if not bytes then
		error('Invalid asset.')
	end
	bytes:poke(1)

	local src = bytes:readString()
	local dst = ''
	for ln in src:gmatch('([^\n]*)\n?') do
		local ln_ = ln
		if #ln_ > 0 then
			local comment = ln_:find('#')
			if comment then
				ln_ = ln_:sub(1, comment - 1) -- Remove comment.
			end
			dst = dst .. ln_                  -- Concat lines.
		end
	end
	local full = interpreter .. 'interpret(\'' .. dst .. '\')' -- Link the source code with the interpreter together.

	return load(full) -- Return loaded and parsed Lua chunk.
end
