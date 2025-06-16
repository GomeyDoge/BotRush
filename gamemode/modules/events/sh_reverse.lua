BotRush:CreateEvent( 
	"Reverse Controls", "Temporarily reverse player controls.",
	
	function()
		if SERVER then
			hook.Add("StartCommand", "BotRush::Events::Reverse", function( ply, cmd )
				local mv = cmd:GetForwardMove()
				cmd:SetForwardMove(-mv)

				local sv = cmd:GetSideMove()
				cmd:SetSideMove(-sv)
			end )
		end
	end,

	function()
		if SERVER then
			hook.Remove( "StartCommand", "BotRush::Events::Reverse" )
		end
	end,

	math.random(5, 10) -- 5 to 10 seconds
 )