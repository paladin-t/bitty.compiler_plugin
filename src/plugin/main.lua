--[[
Plugin for the Bitty Engine

Copyright (C) 2020 - 2021 Tony Wang, all rights reserved

Homepage: https://paladin-t.github.io/bitty/
]]

local assets = {
	'bf/compiler.lua',
	'bf/README.txt'
}

local tips = 'Usage:\n  require \'bf/compiler\'\n  f = compile(\'source.bf\')\n  f()'
local code = 'require \'bf/compiler\'\nf = compile(\'source.bf\')\nf()\n'

function usage()
	return { 'compiler' }
end

function schema()
	return {
		-- Common.
		name = 'BF',
		extension = 'bf',

		-- List of string.
		keywords = { },
		identifiers = { },
		quotes = { '\'', '"' },
		-- String.
		multiline_comment_start = nil,
		multiline_comment_end = nil,
		-- C++ regex.
		comment_patterns = { '\\#.*' },
		number_patterns = { },
		identifier_patterns = { },
		punctuation_patterns = { '[\\<\\>\\+\\-\\.\\,\\[\\]]' },
		-- Boolean.
		case_sensitive = true,
		-- List of string.
		assets = assets
	}
end

function compiler()
	print('Install BF compiler to the current project.')

	waitbox('Installing')
		:thus(function (rsp)
			local install = function (name)
				local data = Project.main:read(name)
				data:poke(1)
				Project.editing:write(name, data)
			end

			for _, asset in ipairs(assets) do
				install(asset)
			end

			print('Done.')

			msgbox(tips)
				:thus(function ()
					Platform.setClipboardText(code)
				end)
		end)
end
