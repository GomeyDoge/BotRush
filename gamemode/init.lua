AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString("BotRush::Events::RandomReveal")

function GM:PlayerSpawn( ply )
	ply:SetModel("models/player/combine_super_soldier.mdl")
end