BotRush:CreateEvent( 
	"Random Reveal ", "Temporarily highlight a random player.",
	
	function()
		if SERVER then
			local players = player.GetAll()
			if #players == 0 then return end -- Event skipped

			--@TODO Add a bot check so only real players are highlighed

			local targettedPlayer = table.Random(players)

			net.Start("BotRush::Events::RandomReveal")
				net.WriteBool(true) -- Starting event
				net.WriteEntity(targettedPlayer)
			net.Broadcast()
		end
	end,

	function()
		if SERVER then
			net.Start("BotRush::Events::RandomReveal")
				net.WriteBit(false) -- End event
			net.Broadcast()
		end
	end,

	math.random(5, 10) -- 5 to 10 seconds
 )