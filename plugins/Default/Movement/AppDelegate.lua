waxClass{"PGMovement", Plugin}

-- Declarations
local controller, botController, movementController

function ePluginLoaded(self)
  
  -- plugin loaded! lets initiate our local variables
	controller = NSApplication:sharedApplication():delegate()
	botController = controller:botController()
	movementController = controller:movementController()
  
	print("PGMovement loaded successfully")
end

function ePlayerFound(self, player)
	print("Found a player! Yay!")
	
	if ( player ) then
		print("Argument is of type: " .. type(player))
		
		print("Class is " .. player:className())
		
		--puts(wax.instance.methods(player))
		
		print("Player name: " .. tostring(player:name()))
	end
end

function ePlayerDied(self)

end

function eBotStart(self)

	-- prints everything in the global table
	--for k,v in pairs(_G) do print(k) end
	
	
	-- make sure we have a valid route to run

	
	--DisplayError("No", "I don't want you to start!")
	

	return YES;

end