GM.Name = "BotRush"
GM.Author = "@realdotty"

BotRush = {
	_VERSION = "1.0.0-alpha", -- semver

	_CREDITS = {
		{
			["name"] = "Dotty",
			["discord"] = "@realdotty",
			["id64"] = "76561198362949858",
			["title"] = "Project Manager"
		}
	},

	Events = {},
	Minigames = {}
}

function printf(...)
	print( string.format(...) )
end

local function LoadModules()
	local path = GAMEMODE.FolderName .. "/gamemode/modules/"
	local _, folders = file.Find( path .. "*", "LUA" )
	local StartTime = math.Round( CurTime() )

	print("@DEBUG Module Loader Started " .. StartTime)

	for _, folder in SortedPairs( folders ) do

		-- Mount server files
		for __, fil in SortedPairs( file.Find( path .. folder .. "/sv_*.lua", "LUA" ) ) do
			print("Initialize", folder, fil)
			timer.Simple( 0, function() include( path .. folder .. "/" .. fil ) end )
		end

		-- Mount shared files
		for __, fil in SortedPairs( file.Find( path .. folder .. "/sh_*.lua", "LUA" ) ) do
			print("Initialize", folder, fil)
			timer.Simple( 0, function()
				if SERVER then AddCSLuaFile( path .. folder .. "/" .. fil ) end
				include( path .. folder .. "/" .. fil )
			end )
		end

		-- Mount client files
		for __, fil in SortedPairs( file.Find( path .. folder .. "/cl_*.lua", "LUA" ) ) do
			print("Initialize", folder, fil)
			timer.Simple( 0, function()
				if SERVER then AddCSLuaFile( path .. folder .. "/" .. fil ) end
				if CLIENT then include( path .. folder .. "/" .. fil ) end
			end )
		end
	end

	local TimeElapsed = ( StartTime - CurTime() )
	TimeElapsed = math.Round( TimeElapsed, 2 )

	print("Module loader finished " .. TimeElapsed)
end

hook.Add( "Think", "BotRush::LoadModules", function() -- Lua refresh
	hook.Remove( "Think", "BotRush::LoadModules" )
	LoadModules()
end )

if SERVER then
	concommand.Add( "_remount_all_gamemode_lua_server", function( ply )
		if not ply:IsSuperAdmin() then return end
		LoadModules()
	end )

	concommand.Add( "_remount_all_gamemode_lua_shared", function( ply )
		if not ply:IsSuperAdmin() then return end
		LoadModules()
		for _, ply in ipairs( player.GetAll() ) do p:ConCommand("remount_all_gamemode_lua_client") end
	end )
end

if CLIENT then concommand.Add( "remount_all_gamemode_lua_client", function() LoadModules() end ) end

function BotRush:GetRandomBot()
	local bots = player.GetBots()
	if #bots == 0 then return end -- No bots
	return bots[math.random(#bots)]
end

function BotRush:GetRandomHuman()
	local humans = player.GetHumans()
	if #humans == 0 then return end -- No humans
	return humans[math.random(#humans)]
end

function BotRush:GetRandom() -- Bots and players
	local players = player.GetAll()
	if #players == 0 then return end
	return players[#players]
end

local Event = {}
Event.__index = Event

function Event:GetName()
	return self.name
end

function Event:GetDescription()
	return self.description
end

function Event:Start()
	if self.startFunc then self.startFunc() end

	if self.duration and self.duration > 0 then
		timer.Simple( self.duration, function()
			if self.endFunc then self.endFunc() end
		end )
	end
end

function Event:Stop()
	if self.endFunc then self.endFunc() end
end

function BotRush:CreateEvent(name, description, startFunc, endFunc, duration)
	return setmetatable( {
		name = name,
		description = description,
		startFunc = startFunc,
		endFunc = endFunc,
		duration = duration or 0 -- 0 means no auto-end
	}, Event )
end