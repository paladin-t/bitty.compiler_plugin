--[[
Plugin for the Bitty Engine

Copyright (C) 2020 - 2021 Tony Wang, all rights reserved

Homepage: https://paladin-t.github.io/bitty/
]]

-- Which assets are supposed to be injected from this plugin to target project.
local assets = {
	'bf/compiler.lua',
	'bf/README.txt'
}

-- Tips and example code.
local tips = 'Usage:\n  require \'bf/compiler\'\n  f = compile(\'source.bf\')\n  f()'
local code = 'require \'bf/compiler\'\nf = compile(\'source.bf\')\nf()\n'

-- Plugin entry, called to determine the usage of this plugin.
function usage()
	return { 'compiler' } -- This plugin is a compiler.
end

-- Plugin entry, called to determine the schema of this plugin.
function schema()
	return {
		-- Common.
		name = 'BF',      -- Asset name registered for this plugin.
		extension = 'bf', -- Asset extension registered for this plugin.

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

-- Plugin entry, called to install necessary assets to your target project.
function compiler()
	print('Install BF compiler to the current project.')

	waitbox('Installing')
		:thus(function (rsp)
			local install = function (name)
				local data = Project.main:read(name)
				data:poke(1)
				Project.editing:write(name, data) -- Write into the target project.
			end

			for _, asset in ipairs(assets) do -- Install all necessary assets.
				install(asset)
			end

			print('Done.')

			msgbox(tips)
				:thus(function ()
					Platform.setClipboardText(code) -- Put example code to clipboard.
				end)
		end)
end
