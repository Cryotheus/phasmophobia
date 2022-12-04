--[[
	loading methods
		client: server does AddCSLuaFile, client does include
		download: server does AddCSLuaFile
		server: server does include
		shared: server does AddCSLuaFile, server and client does include
	
	loading modifiers
		dedicated: must be hosted on a dedicated server
		developer: developer convar must be set
		listen: must be a listen server
		simple: must be a listen or single player server
		single: must be a single player server
]]

local config = {
	{
		loader = "download",
		
		global = {
			color = "shared",
			shared = true
		},
	},
	
	{shared = true},
	
	{
		render = {client = true},
		
		entity = {
			meta = {
				server = true,
				shared = true,
			},
			
			lamp = "shared",
		},
		
		player = {
			binding = "client",
			flashlight = "server",
			shared = true,
			
			item = {
				model = "shared",
				shared = true,
			},
			
			meta = {
				client = true,
				server = true,
				shared = true,
			},
		},
		
		prop = {
			server = true,
			shared = true,
		},
		
		team = {shared = true},
	},
	
	{hud = {block = "client"}},
}

local branding = "Phasmophobia"
local color = Color(46, 55, 72)
--local color_error = Color(255, 96, 72)
local color_generic = Color(240, 240, 240)
--local color_success = Color(72, 255, 96)

do --do not touch
	--locals
	local block_developer = not GetConVar("developer"):GetBool()
	local include_list = {}
	
	--local tables
	local load_methods = SERVER and {
		client = AddCSLuaFile,
		download = AddCSLuaFile,
		server = true,
		
		shared = function(script)
			AddCSLuaFile(script)
			
			return true
		end
	} or {client = true, shared = true}
	
	local word_methods = {
		dedicated = not game.IsDedicated(),
		developer = block_developer,
		listen = game.IsDedicated() or game.SinglePlayer(),
		simple = game.IsDedicated(),
		single = not game.SinglePlayer(),
	}
	
	--local functions
	local function check_words(words)
		for index, word in ipairs(words) do
			local word_method = word_methods[word] or nil
			
			if word_method and (word_method == true or word_method()) then return false end
		end
		
		return true
	end
	
	local function build_list(include_list, prefix, tree) --recursively explores to build load order
		for name, object in pairs(tree) do
			local trimmed_path = prefix .. name
			
			if istable(object) then build_list(include_list, trimmed_path .. "/", object)
			elseif object then
				local words = isstring(object) and string.Split(object, " ") or {name}
				local script = trimmed_path .. ".lua"
				local word = table.remove(words, 1)
				local load_method = load_methods[word]
				
				if load_method and (load_method == true or load_method(script)) and check_words(words) then table.insert(include_list, script) end
			end
		end
	end
	
	--build the load order
	for priority, tree in ipairs(config) do build_list(include_list, "", tree) end
	
	--load the scripts
	if GM then MsgC(color, "\nLoading " .. branding .. " (Gamemode) scripts...\n")
	else MsgC(color, "\nLoading " .. branding .. " scripts...\n") end
	
	MsgC(color_generic, "This load is running in the " .. (SERVER and "SERVER" or "CLIENT") .. " realm.\n")
	
	for index, script in ipairs(include_list) do
		MsgC(color_generic, "\t" .. index .. ": " .. script .. "\n")
		include(script)
	end
	
	if GM then MsgC(color, "Gamemode load concluded.\n")
	else MsgC(color, "Load concluded.\n\n") end
end