include( "shared.lua" )

local randomRevealed = nil
net.Receive( "BotRush::Events::RandomReveal", function()
	local bStatus = net.ReadBool() -- Starting or ending
	if bStatus then -- starting event
		randomRevealed = net.ReadEntity()
	else -- ending
		randomRevealed = nil
	end
end )

local color_red = Color(255, 0, 0)
hook.Add( "PreDrawHalos", "BotRush::Events::RandomReveal", function()
	if not IsValid(randomRevealed) then return end -- event not going OR player left
	halo.Add( {randomRevealed}, color_red, 2, 2, 1, true, true) -- this having to be a table is stupid
end )