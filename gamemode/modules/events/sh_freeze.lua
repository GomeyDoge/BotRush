BotRush:CreateEvent( 
	"Freeze", "Temporarily freeze all the bots and see if your friends can react in time.",
	
	function()
		if SERVER then
			RunConsoleCommand("bot_zombie", 1) -- Freeze bots
		end
	end,

	function()
		if SERVER then
			RunConsoleCommand("bot_zombie", 0) -- Unfreeze bots
		end
	end,

	math.random(5, 10) -- 5 to 10 seconds
 )